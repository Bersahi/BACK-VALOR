import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('notificaciones')
export class Notificaciones {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'envio_id', type: 'int', nullable: true })
  envioId?: number;

  @Column({ name: 'cliente_id', type: 'int', nullable: true })
  clienteId?: number;

  @Column({ name: 'tipo', type: 'varchar', length: 10, nullable: false })
  tipo: string; // info, success, warning, error

  @Column({ name: 'titulo', type: 'varchar', length: 100, nullable: true })
  titulo?: string;

  @Column({ name: 'mensaje', type: 'text', nullable: false })
  mensaje: string;

  @Column({ name: 'leida', type: 'boolean', default: false })
  leida?: boolean;

  @Column({ name: 'enviada_tiempo_real', type: 'boolean', default: false })
  enviadaTiempoReal?: boolean;

  @Column({ name: 'metadata', type: 'json', nullable: true })
  metadata?: any;

  @Column({ name: 'fecha_creacion', type: 'datetime', default: () => 'CURRENT_TIMESTAMP' })
  fechaCreacion?: Date;

  @Column({ name: 'fecha_lectura', type: 'datetime', nullable: true })
  fechaLectura?: Date;

  @Column({ name: 'destinatario', type: 'varchar', length: 100, nullable: false })
  destinatario: string;
}

