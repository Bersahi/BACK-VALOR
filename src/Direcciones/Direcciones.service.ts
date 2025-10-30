import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Direcciones } from './Direcciones.entity';

@Injectable()
export class DireccionesService {
  constructor(
    @InjectRepository(Direcciones)
    private readonly direccionesRepository: Repository<Direcciones>,
  ) {}

  /**
   * Crea una nueva dirección en la base de datos
   * @param data Datos de la dirección
   * @returns La dirección creada con su ID
   */
  async create(data: Partial<Direcciones>): Promise<Direcciones> {
    const nuevaDireccion = this.direccionesRepository.create(data);
    return this.direccionesRepository.save(nuevaDireccion);
  }

  /**
   * Busca una dirección existente por sus datos (para evitar duplicados)
   * @param direccionTexto Texto de la dirección
   * @param ciudad Ciudad
   * @param provincia Provincia/Departamento
   * @returns La dirección encontrada o null
   */
  async findByDatos(
    direccionTexto: string,
    ciudad: string,
    provincia: string,
  ): Promise<Direcciones | null> {
    return this.direccionesRepository.findOne({
      where: {
        direccionTexto,
        ciudad,
        provincia,
      },
    });
  }

  /**
   * Busca o crea una dirección
   * Si existe una dirección con los mismos datos, la retorna
   * Si no existe, crea una nueva
   */
  async findOrCreate(data: Partial<Direcciones>): Promise<Direcciones> {
    // Validar que los campos requeridos existan
    if (!data.direccionTexto || !data.ciudad || !data.provincia) {
      throw new Error('Datos de dirección incompletos');
    }

    // Buscar dirección existente
    const direccionExistente = await this.findByDatos(
      data.direccionTexto,
      data.ciudad,
      data.provincia,
    );

    if (direccionExistente) {
      return direccionExistente;
    }

    // Si no existe, crear nueva
    return this.create(data);
  }
}

