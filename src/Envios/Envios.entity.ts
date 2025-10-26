import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('ENVIOS', { schema: 'ADMIN' })
export class Envios {
  @PrimaryGeneratedColumn({ name: 'ID' })
  id: number;

  @Column({ name: 'CLIENTE_ID', type: 'number', nullable: true })
  clienteId: number;

  @Column({ name: 'ORIGEN_ID', type: 'number', nullable: false })
  origenId: number;

  @Column({ name: 'DESTINO_ID', type: 'number', nullable: false })
  destinoId: number;

  @Column({ name: 'REMITENTE_NOMBRE', type: 'varchar2', length: 100, nullable: false })
  remitenteNombre: string;

  @Column({ name: 'REMITENTE_TELEFONO', type: 'varchar2', length: 20, nullable: true })
  remitenteTelefono: string;

  @Column({ name: 'REMITENTE_DOCUMENTO', type: 'varchar2', length: 20, nullable: true })
  remitenteDocumento: string;

  @Column({ name: 'REMITENTE_EMAIL', type: 'varchar2', length: 100, nullable: true })
  remitenteEmail: string;

  @Column({ name: 'TRACKING_CODE', type: 'varchar2', length: 20, unique: true, nullable: false })
  trackingCode: string;

  @Column({ name: 'COSTO_TOTAL', type: 'number', precision: 10, scale: 2, nullable: false })
  costoTotal: number;

  @Column({ name: 'METODO_ENVIO', type: 'varchar2', length: 20, nullable: true })
  metodoEnvio: string;

  @Column({ name: 'ESTADO', type: 'varchar2', length: 30, nullable: true })
  estado: string;

  @Column({ name: 'FECHA_CREACION', type: 'timestamp', nullable: true })
  fechaCreacion: Date;
}
