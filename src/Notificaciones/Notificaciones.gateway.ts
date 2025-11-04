import {
  WebSocketGateway,
  WebSocketServer,
  SubscribeMessage,
  OnGatewayConnection,
  OnGatewayDisconnect,
  ConnectedSocket,
  MessageBody,
} from '@nestjs/websockets';
import { Server, Socket } from 'socket.io';
import { Logger } from '@nestjs/common';

interface ClienteSocket extends Socket {
  clienteId?: number;
  userId?: number;
}

@WebSocketGateway({
  cors: {
    origin: ['http://localhost:3000', 'http://127.0.0.1:3000'],
    credentials: true,
  },
  namespace: '/notificaciones', // Namespace específico para notificaciones
})
export class NotificacionesGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  private readonly logger = new Logger(NotificacionesGateway.name);
  
  // Map para rastrear clientes conectados
  private clientesConectados = new Map<number, Set<string>>();

  /**
   * Cuando un cliente se conecta al WebSocket
   */
  handleConnection(@ConnectedSocket() client: ClienteSocket) {
    this.logger.log(`🔌 Cliente conectado: ${client.id}`);
  }

  /**
   * Cuando un cliente se desconecta
   */
  handleDisconnect(@ConnectedSocket() client: ClienteSocket) {
    this.logger.log(`🔌 Cliente desconectado: ${client.id}`);
    
    // Remover de la lista de conectados
    if (client.clienteId) {
      const sockets = this.clientesConectados.get(client.clienteId);
      if (sockets) {
        sockets.delete(client.id);
        if (sockets.size === 0) {
          this.clientesConectados.delete(client.clienteId);
        }
      }
    }
  }

  /**
   * Cliente se registra con su clienteId
   * Esto permite enviar notificaciones solo a ese cliente
   */
  @SubscribeMessage('registrar-cliente')
  handleRegistrarCliente(
    @ConnectedSocket() client: ClienteSocket,
    @MessageBody() data: { clienteId: number },
  ) {
    const { clienteId } = data;
    client.clienteId = clienteId;
    
    // Agregar a la sala del cliente
    client.join(`cliente-${clienteId}`);
    
    // Registrar en el map
    if (!this.clientesConectados.has(clienteId)) {
      this.clientesConectados.set(clienteId, new Set());
    }
    this.clientesConectados.get(clienteId)!.add(client.id);

    this.logger.log(`✅ Cliente ${clienteId} registrado (socket: ${client.id})`);
    
    // Confirmar registro
    client.emit('registro-exitoso', { 
      clienteId, 
      mensaje: 'Conectado al sistema de notificaciones' 
    });
  }

  /**
   * Enviar notificación a un cliente específico
   */
  notificarCliente(clienteId: number, notificacion: any) {
    const room = `cliente-${clienteId}`;
    this.logger.log(`📢 Enviando notificación a cliente ${clienteId}:`, notificacion);
    
    this.server.to(room).emit('nueva-notificacion', {
      ...notificacion,
      timestamp: new Date(),
    });
  }

  /**
   * Enviar notificación a todos los clientes conectados
   */
  notificarATodos(notificacion: any) {
    this.logger.log('📢 Enviando notificación a TODOS los clientes:', notificacion);
    
    this.server.emit('nueva-notificacion', {
      ...notificacion,
      timestamp: new Date(),
    });
  }

  /**
   * Enviar notificación específica de cambio de estado de envío
   */
  notificarCambioEstadoEnvio(clienteId: number, envioData: any) {
    this.notificarCliente(clienteId, {
      tipo: 'info',
      titulo: 'Estado de envío actualizado',
      mensaje: `Tu envío ${envioData.trackingCode} cambió a: ${envioData.estado}`,
      envioId: envioData.id,
      trackingCode: envioData.trackingCode,
      estado: envioData.estado,
    });
  }

  /**
   * Obtener número de clientes conectados
   */
  getClientesConectados(): number {
    return this.clientesConectados.size;
  }

  /**
   * Verificar si un cliente está conectado
   */
  isClienteConectado(clienteId: number): boolean {
    return this.clientesConectados.has(clienteId);
  }
}

