import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Envios } from './Envios.entity';
import { Direcciones } from '../Direcciones/Direcciones.entity';
import { Paquetes } from '../Paquetes/Paquetes.entity';
import { DireccionesService } from '../Direcciones/Direcciones.service';
import { PaquetesService } from '../Paquetes/Paquetes.service';
import { NotificacionesService } from '../Notificaciones/Notificaciones.service';
import { NotificacionesGateway } from '../Notificaciones/Notificaciones.gateway';
import { CreateEnvioCompletoDto } from './dto/create-envio-completo.dto';

@Injectable()
export class EnviosService {
  constructor(
    @InjectRepository(Envios)
    private readonly enviosRepository: Repository<Envios>,
    private readonly direccionesService: DireccionesService,
    private readonly paquetesService: PaquetesService,
    private readonly notificacionesService: NotificacionesService,
    private readonly notificacionesGateway: NotificacionesGateway,
  ) {}

  async findAll(): Promise<Envios[]> {
    return this.enviosRepository.find();
  }

  async findOne(id: number): Promise<Envios> {
    const envio = await this.enviosRepository.findOne({ where: { id } });
    if (!envio) {
      throw new NotFoundException(`El envío con ID ${id} no existe`);
    }
    return envio;
  }

  async create(data: Partial<Envios>): Promise<Envios> {
    const nuevoEnvio = this.enviosRepository.create(data);
    return this.enviosRepository.save(nuevoEnvio);
  }

  async update(id: number, data: Partial<Envios>): Promise<Envios> {
    const envio = await this.findOne(id);
    const estadoAnterior = envio.estado;
    
    Object.assign(envio, data);
    const envioActualizado = await this.enviosRepository.save(envio);
    
    // Si el estado cambió, enviar notificación
    if (data.estado && data.estado !== estadoAnterior) {
      await this.notificarCambioEstado(envioActualizado, estadoAnterior);
    }
    
    return envioActualizado;
  }

  /**
   * Notifica al cliente sobre un cambio de estado del envío
   */
  private async notificarCambioEstado(envio: Envios, estadoAnterior: string): Promise<void> {
    try {
      // Mensajes según el nuevo estado
      const mensajes: Record<string, string> = {
        'registrado': '📦 Tu envío ha sido registrado exitosamente',
        'en_transito': '🚚 Tu envío está en camino',
        'en_almacen': '📍 Tu envío llegó al almacén',
        'en_reparto': '🏃 Tu envío está en reparto, ¡pronto llegará!',
        'entregado': '✅ Tu envío ha sido entregado exitosamente',
        'cancelado': '❌ Tu envío ha sido cancelado',
        'devuelto': '↩️ Tu envío está siendo devuelto',
      };

      const mensaje = mensajes[envio.estado] || `Tu envío cambió de estado: ${envio.estado}`;
      const destinatario = envio.remitenteEmail || envio.remitenteTelefono || 'Cliente';

      // Determinar si el cliente está conectado
      const clienteConectado = envio.clienteId ? 
        this.notificacionesGateway.isClienteConectado(envio.clienteId) : false;

      // 1. Guardar notificación en BD (historial para soporte)
      const notificacion = await this.notificacionesService.create({
        envioId: envio.id,
        clienteId: envio.clienteId,
        tipo: envio.estado === 'entregado' ? 'success' : 'info',
        titulo: 'Estado de envío actualizado',
        mensaje: `${mensaje}. Código de seguimiento: ${envio.trackingCode}`,
        destinatario,
        enviadaTiempoReal: clienteConectado,
        metadata: {
          estadoAnterior,
          estadoNuevo: envio.estado,
          trackingCode: envio.trackingCode,
          fechaCambio: new Date(),
        },
      });

      console.log('✅ Notificación guardada en BD:', notificacion.id);

      // 2. Enviar notificación en tiempo real por WebSocket (si el cliente está conectado)
      if (envio.clienteId && clienteConectado) {
        this.notificacionesGateway.notificarCambioEstadoEnvio(envio.clienteId, {
          id: notificacion.id,
          envioId: envio.id,
          trackingCode: envio.trackingCode,
          estado: envio.estado,
          estadoAnterior,
          titulo: 'Estado de envío actualizado',
          mensaje,
          tipo: notificacion.tipo,
          fechaCreacion: notificacion.fechaCreacion,
        });
        
        console.log('📢 Notificación enviada por WebSocket al cliente:', envio.clienteId);
      } else if (envio.clienteId) {
        console.log('⚠️ Cliente no conectado, notificación guardada solo en BD');
      }
    } catch (error) {
      console.error('❌ Error al enviar notificación:', error);
      // No lanzar error para no interrumpir la actualización del envío
    }
  }

  async remove(id: number): Promise<void> {
    const envio = await this.findOne(id);
    await this.enviosRepository.remove(envio);
  }

  /**
   * Crea un envío completo con sus direcciones y paquete
   * Este método maneja la transacción completa del formulario
   */
  async crearEnvioCompleto(dto: CreateEnvioCompletoDto): Promise<any> {
    try {
      // 1. Crear o buscar dirección de origen
      const direccionOrigen = await this.direccionesService.findOrCreate({
        clienteId: dto.clienteId || undefined,
        microzonaId: 1, // Por defecto microzona 1 (ajustar según lógica de negocio)
        direccionTexto: dto.direccionOrigen.direccion,
        ciudad: dto.direccionOrigen.ciudad || dto.direccionOrigen.municipio,
        provincia: dto.direccionOrigen.departamento,
        pais: dto.direccionOrigen.pais,
        codigoPostal: dto.direccionOrigen.codigoPostal || undefined,
        esPrincipal: 0,
      });

      // 2. Crear o buscar dirección de destino
      const direccionDestino = await this.direccionesService.findOrCreate({
        clienteId: dto.clienteId || undefined,
        microzonaId: 1, // Por defecto microzona 1
        direccionTexto: dto.direccionDestino.direccion,
        ciudad: dto.direccionDestino.ciudad || dto.direccionDestino.municipio,
        provincia: dto.direccionDestino.departamento,
        pais: dto.direccionDestino.pais,
        codigoPostal: dto.direccionDestino.codigoPostal || undefined,
        esPrincipal: 0,
      });

      // 3. Generar tracking code único
      const trackingCode = await this.generarTrackingCode();

      // 4. Calcular costo (por ahora usar valor declarado, luego implementar lógica de tarifas)
      const valorDeclarado = parseFloat(dto.paquete.valor) || 0;
      const costoTotal = this.calcularCostoEnvio(valorDeclarado, dto.paquete.peso);

      // 5. Crear el envío
      const nuevoEnvio = await this.create({
        clienteId: dto.clienteId || undefined,
        origenId: direccionOrigen.id,
        destinoId: direccionDestino.id,
        remitenteNombre: dto.remitente.nombre,
        remitenteTelefono: dto.remitente.telefono,
        remitenteDocumento: dto.remitente.documento || undefined,
        remitenteEmail: dto.remitente.email || undefined,
        trackingCode: trackingCode,
        costoTotal: costoTotal,
        metodoEnvio: dto.metodoEnvio || 'terrestre',
        estado: 'registrado',
        fechaCreacion: new Date(),
      });

      // 6. Parsear dimensiones (formato: "largo x ancho x alto")
      let largo: number | undefined = undefined;
      let ancho: number | undefined = undefined;
      let alto: number | undefined = undefined;
      
      if (dto.paquete.dimensiones) {
        const dims = dto.paquete.dimensiones.split('x').map(d => parseFloat(d.trim()));
        if (dims.length >= 3) {
          largo = dims[0];
          ancho = dims[1];
          alto = dims[2];
        }
      }

      // 7. Crear el paquete asociado
      const nuevoPaquete = await this.paquetesService.create({
        envioId: nuevoEnvio.id,
        tipoPaqueteId: 1, // Por defecto tipo 1 (ajustar según lógica)
        descripcion: dto.paquete.descripcion || 'Sin descripción',
        pesoKg: parseFloat(dto.paquete.peso) || 0,
        largoCm: largo,
        anchoCm: ancho,
        altoCm: alto,
        valorDeclarado: valorDeclarado,
        fragil: dto.paquete.fragil ? 1 : 0,
        estadoActual: 'registrado',
      });

      // 8. Retornar el envío completo con información adicional
      return {
        id: nuevoEnvio.id,
        trackingCode: nuevoEnvio.trackingCode,
        estado: nuevoEnvio.estado,
        costoTotal: nuevoEnvio.costoTotal,
        metodoEnvio: nuevoEnvio.metodoEnvio,
        fechaCreacion: nuevoEnvio.fechaCreacion,
        remitente: {
          nombre: nuevoEnvio.remitenteNombre,
          telefono: nuevoEnvio.remitenteTelefono,
          email: nuevoEnvio.remitenteEmail,
        },
        destinatario: {
          nombre: dto.destinatario.nombre,
          telefono: dto.destinatario.telefono,
        },
        origen: {
          direccion: direccionOrigen.direccionTexto,
          ciudad: direccionOrigen.ciudad,
          provincia: direccionOrigen.provincia,
          pais: direccionOrigen.pais,
        },
        destino: {
          direccion: direccionDestino.direccionTexto,
          ciudad: direccionDestino.ciudad,
          provincia: direccionDestino.provincia,
          pais: direccionDestino.pais,
        },
        paquete: {
          peso: nuevoPaquete.pesoKg,
          dimensiones: dto.paquete.dimensiones,
          valor: nuevoPaquete.valorDeclarado,
          descripcion: nuevoPaquete.descripcion,
        },
        mensaje: 'Envío creado exitosamente',
      };
    } catch (error) {
      console.error('Error al crear envío completo:', error);
      throw new BadRequestException('Error al procesar el envío: ' + error.message);
    }
  }

  /**
   * Genera un código de rastreo único
   */
  private async generarTrackingCode(): Promise<string> {
    const timestamp = Date.now().toString().slice(-8);
    const random = Math.floor(Math.random() * 1000).toString().padStart(3, '0');
    const trackingCode = `ENV${timestamp}${random}`;
    
    // Verificar que no exista (muy improbable, pero por seguridad)
    const existe = await this.enviosRepository.findOne({
      where: { trackingCode },
    });
    
    if (existe) {
      // Si existe, intentar de nuevo recursivamente
      return this.generarTrackingCode();
    }
    
    return trackingCode;
  }

  /**
   * Calcula el costo del envío según peso y valor
   * TODO: Implementar lógica real de tarifas según zonas y tipo de envío
   */
  private calcularCostoEnvio(valorDeclarado: number, pesoStr: string): number {
    const peso = parseFloat(pesoStr) || 1;
    
    // Tarifa base + tarifa por peso + porcentaje del valor
    const tarifaBase = 25;
    const tarifaPorKg = 15;
    const porcentajeValor = 0.02; // 2% del valor declarado
    
    const costoTotal = tarifaBase + (peso * tarifaPorKg) + (valorDeclarado * porcentajeValor);
    
    return Math.round(costoTotal * 100) / 100; // Redondear a 2 decimales
  }
}
