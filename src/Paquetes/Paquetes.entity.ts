import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('paquetes')
export class Paquetes {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'envio_id', type: 'int', nullable: false })
  envioId: number;

  @Column({ name: 'tipo_paquete_id', type: 'int', nullable: false })
  tipoPaqueteId: number;

  @Column({ name: 'codigo_barras', type: 'varchar', length: 50, nullable: true })
  codigoBarras?: string;

  @Column({ name: 'descripcion', type: 'text', nullable: true })
  descripcion?: string;

  @Column({ name: 'peso_kg', type: 'decimal', precision: 6, scale: 2, nullable: false })
  pesoKg: number;

  @Column({ name: 'largo_cm', type: 'decimal', precision: 6, scale: 2, nullable: true })
  largoCm?: number;

  @Column({ name: 'ancho_cm', type: 'decimal', precision: 6, scale: 2, nullable: true })
  anchoCm?: number;

  @Column({ name: 'alto_cm', type: 'decimal', precision: 6, scale: 2, nullable: true })
  altoCm?: number;

  @Column({ name: 'valor_declarado', type: 'decimal', precision: 10, scale: 2, nullable: true })
  valorDeclarado?: number;

  @Column({ name: 'fragil', type: 'tinyint', nullable: false, default: 0 })
  fragil: number;

  @Column({ name: 'estado_actual', type: 'varchar', length: 50, nullable: true })
  estadoActual?: string;
}

