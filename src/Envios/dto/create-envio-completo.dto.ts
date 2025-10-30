/**
 * DTO para crear un envío completo desde el formulario del frontend
 * Este DTO maneja la creación de: direcciones (origen/destino) + envío + paquete
 */

export class DireccionDto {
  direccion: string;
  municipio: string;
  departamento: string;
  pais: string;
  ciudad?: string;
  codigoPostal?: string;
}

export class RemitenteDto {
  nombre: string;
  telefono: string;
  email?: string;
  documento?: string;
}

export class DestinatarioDto {
  nombre: string;
  telefono: string;
  email?: string;
}

export class PaqueteDto {
  peso: string;          // Viene como string del frontend
  dimensiones?: string;  // Formato: "largo x ancho x alto"
  valor: string;         // Viene como string del frontend
  moneda?: string;
  tipoServicio?: string;
  descripcion?: string;
  fragil?: boolean;
}

export class CreateEnvioCompletoDto {
  // Información del remitente
  remitente: RemitenteDto;
  
  // Dirección de origen
  direccionOrigen: DireccionDto;
  
  // Información del destinatario
  destinatario: DestinatarioDto;
  
  // Dirección de destino
  direccionDestino: DireccionDto;
  
  // Información del paquete
  paquete: PaqueteDto;
  
  // Cliente (opcional, si está logueado)
  clienteId?: number;
  
  // Método de envío (terrestre, aereo, maritimo)
  metodoEnvio?: string;
}

