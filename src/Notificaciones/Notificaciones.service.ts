import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notificaciones } from './Notificaciones.entity';

export interface CreateNotificacionDto {
  envioId?: number;
  clienteId?: number;
  tipo: 'info' | 'success' | 'warning' | 'error';
  titulo?: string;
  mensaje: string;
  destinatario: string;
  metadata?: any;
  enviadaTiempoReal?: boolean;
}

@Injectable()
export class NotificacionesService {
  constructor(
    @InjectRepository(Notificaciones)
    private readonly notificacionesRepository: Repository<Notificaciones>,
  ) {}

  /**
   * Crear una nueva notificación en la BD
   */
  async create(data: CreateNotificacionDto): Promise<Notificaciones> {
    console.log('📝 Creando notificación en BD:', data);
    const notificacion = this.notificacionesRepository.create(data);
    const saved = await this.notificacionesRepository.save(notificacion);
    console.log('✅ Notificación guardada con ID:', saved.id);
    return saved;
  }

  /**
   * Obtener todas las notificaciones de un cliente
   */
  async findByCliente(clienteId: number): Promise<Notificaciones[]> {
    return this.notificacionesRepository.find({
      where: { clienteId },
      order: { id: 'DESC' },
    });
  }

  /**
   * Obtener todas las notificaciones de un envío
   */
  async findByEnvio(envioId: number): Promise<Notificaciones[]> {
    return this.notificacionesRepository.find({
      where: { envioId },
      order: { id: 'DESC' },
    });
  }

  /**
   * Obtener todas las notificaciones (para admin/soporte)
   */
  async findAll(): Promise<Notificaciones[]> {
    return this.notificacionesRepository.find({
      order: { id: 'DESC' },
      take: 100, // Limitar a las últimas 100
    });
  }

  /**
   * Marcar notificación como leída
   */
  async markAsRead(id: number): Promise<void> {
    await this.notificacionesRepository.update(id, {
      leida: true,
      fechaLectura: new Date(),
    });
  }

  /**
   * Marcar todas las notificaciones de un cliente como leídas
   */
  async markAllAsReadByCliente(clienteId: number): Promise<void> {
    await this.notificacionesRepository.update(
      { clienteId, leida: false },
      { leida: true, fechaLectura: new Date() }
    );
  }

  /**
   * Obtener solo notificaciones no leídas de un cliente
   */
  async findUnreadByCliente(clienteId: number): Promise<Notificaciones[]> {
    return this.notificacionesRepository.find({
      where: { clienteId, leida: false },
      order: { id: 'DESC' },
    });
  }

  /**
   * Contar notificaciones no leídas de un cliente
   */
  async countUnreadByCliente(clienteId: number): Promise<number> {
    return this.notificacionesRepository.count({
      where: { clienteId, leida: false },
    });
  }

  /**
   * Eliminar notificaciones antiguas (limpieza)
   */
  async deleteOlderThan(days: number): Promise<void> {
    const date = new Date();
    date.setDate(date.getDate() - days);
    
    const result = await this.notificacionesRepository
      .createQueryBuilder()
      .delete()
      .where('fecha_creacion < :date', { date })
      .execute();

    console.log(`🗑️ Eliminadas ${result.affected} notificaciones anteriores a ${date.toISOString()}`);
  }
}

