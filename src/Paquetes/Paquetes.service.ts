import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Paquetes } from './Paquetes.entity';

@Injectable()
export class PaquetesService {
  constructor(
    @InjectRepository(Paquetes)
    private readonly paquetesRepository: Repository<Paquetes>,
  ) {}

  /**
   * Crea un nuevo paquete asociado a un envío
   * @param data Datos del paquete
   * @returns El paquete creado
   */
  async create(data: Partial<Paquetes>): Promise<Paquetes> {
    const nuevoPaquete = this.paquetesRepository.create(data);
    return this.paquetesRepository.save(nuevoPaquete);
  }

  /**
   * Obtiene todos los paquetes de un envío
   * @param envioId ID del envío
   * @returns Array de paquetes
   */
  async findByEnvioId(envioId: number): Promise<Paquetes[]> {
    return this.paquetesRepository.find({
      where: { envioId },
    });
  }
}

