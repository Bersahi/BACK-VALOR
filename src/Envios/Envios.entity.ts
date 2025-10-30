import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('envios')
export class Envios {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'cliente_id', type: 'int', nullable: true })
  clienteId?: number;

  @Column({ name: 'origen_id', type: 'int', nullable: false })
  origenId: number;

  @Column({ name: 'destino_id', type: 'int', nullable: false })
  destinoId: number;

  @Column({ name: 'remitente_nombre', type: 'varchar', length: 100, nullable: false })
  remitenteNombre: string;

  @Column({ name: 'remitente_telefono', type: 'varchar', length: 20, nullable: true })
  remitenteTelefono?: string;

  @Column({ name: 'remitente_documento', type: 'varchar', length: 20, nullable: true })
  remitenteDocumento?: string;

  @Column({ name: 'remitente_email', type: 'varchar', length: 100, nullable: true })
  remitenteEmail?: string;

  @Column({ name: 'tracking_code', type: 'varchar', length: 20, unique: true, nullable: false })
  trackingCode: string;

  @Column({ name: 'costo_total', type: 'decimal', precision: 10, scale: 2, nullable: false })
  costoTotal: number;

  @Column({ name: 'metodo_envio', type: 'varchar', length: 20, nullable: true })
  metodoEnvio?: string;

  @Column({ name: 'estado', type: 'varchar', length: 30, nullable: true })
  estado?: string;

  @Column({ name: 'fecha_creacion', type: 'datetime', nullable: true })
  fechaCreacion?: Date;
}
