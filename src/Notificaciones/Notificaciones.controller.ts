import { Controller, Get, Post, Put, Body, Param, Patch } from '@nestjs/common';
import { NotificacionesService } from './Notificaciones.service';
import { NotificacionesGateway } from './Notificaciones.gateway';
import { Notificaciones } from './Notificaciones.entity';

@Controller('notificaciones')
export class NotificacionesController {
  constructor(
    private readonly notificacionesService: NotificacionesService,
    private readonly notificacionesGateway: NotificacionesGateway,
  ) {}

  /**
   * Obtener todas las notificaciones (admin/soporte)
   */
  @Get()
  async getAllNotificaciones(): Promise<Notificaciones[]> {
    return this.notificacionesService.findAll();
  }

  /**
   * Obtener notificaciones de un cliente específico
   */
  @Get('cliente/:clienteId')
  async getNotificacionesByCliente(
    @Param('clienteId') clienteId: number,
  ): Promise<Notificaciones[]> {
    return this.notificacionesService.findByCliente(clienteId);
  }

  /**
   * Obtener notificaciones NO LEÍDAS de un cliente
   */
  @Get('cliente/:clienteId/unread')
  async getUnreadNotificaciones(
    @Param('clienteId') clienteId: number,
  ): Promise<Notificaciones[]> {
    return this.notificacionesService.findUnreadByCliente(clienteId);
  }

  /**
   * Contar notificaciones NO LEÍDAS de un cliente
   */
  @Get('cliente/:clienteId/unread/count')
  async getUnreadCount(
    @Param('clienteId') clienteId: number,
  ): Promise<{ count: number }> {
    const count = await this.notificacionesService.countUnreadByCliente(clienteId);
    return { count };
  }

  /**
   * Obtener notificaciones de un envío específico
   */
  @Get('envio/:envioId')
  async getNotificacionesByEnvio(
    @Param('envioId') envioId: number,
  ): Promise<Notificaciones[]> {
    return this.notificacionesService.findByEnvio(envioId);
  }

  /**
   * Marcar una notificación como leída
   */
  @Patch(':id/read')
  async markAsRead(@Param('id') id: number): Promise<{ success: boolean }> {
    await this.notificacionesService.markAsRead(id);
    return { success: true };
  }

  /**
   * Marcar todas las notificaciones de un cliente como leídas
   */
  @Patch('cliente/:clienteId/read-all')
  async markAllAsRead(
    @Param('clienteId') clienteId: number,
  ): Promise<{ success: boolean }> {
    await this.notificacionesService.markAllAsReadByCliente(clienteId);
    return { success: true };
  }

  /**
   * Crear notificación manualmente (para pruebas)
   */
  @Post('test')
  async testNotificacion(@Body() body: any): Promise<any> {
    const { clienteId, tipo, mensaje, destinatario } = body;

    // 1. Guardar en BD
    const notificacion = await this.notificacionesService.create({
      clienteId,
      tipo: tipo || 'info',
      mensaje,
      destinatario,
    });

    // 2. Enviar por WebSocket en tiempo real
    this.notificacionesGateway.notificarCliente(clienteId, {
      id: notificacion.id,
      tipo: notificacion.tipo,
      mensaje: notificacion.mensaje,
      destinatario: notificacion.destinatario,
    });

    return {
      success: true,
      message: 'Notificación enviada',
      notificacion,
    };
  }

  /**
   * Obtener estado de conexiones WebSocket
   */
  @Get('status')
  getStatus(): any {
    return {
      clientesConectados: this.notificacionesGateway.getClientesConectados(),
      timestamp: new Date(),
    };
  }
}

