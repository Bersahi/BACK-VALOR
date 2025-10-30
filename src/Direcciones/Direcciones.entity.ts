import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('direcciones')
export class Direcciones {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'cliente_id', type: 'int', nullable: true })
  clienteId?: number;

  @Column({ name: 'microzona_id', type: 'int', nullable: false })
  microzonaId: number;

  @Column({ name: 'direccion_texto', type: 'text', nullable: false })
  direccionTexto: string;

  @Column({ name: 'ciudad', type: 'varchar', length: 50, nullable: false })
  ciudad: string;

  @Column({ name: 'provincia', type: 'varchar', length: 50, nullable: false })
  provincia: string;

  @Column({ name: 'pais', type: 'varchar', length: 50, nullable: false, default: 'Guatemala' })
  pais: string;

  @Column({ name: 'codigo_postal', type: 'varchar', length: 10, nullable: true })
  codigoPostal?: string;

  @Column({ name: 'referencia', type: 'varchar', length: 255, nullable: true })
  referencia?: string;

  @Column({ name: 'es_principal', type: 'tinyint', nullable: false, default: 0 })
  esPrincipal: number;

  @Column({ name: 'deleted_at', type: 'datetime', nullable: true })
  deletedAt?: Date;
}

