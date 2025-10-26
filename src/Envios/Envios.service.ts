import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Envios } from './Envios.entity';

@Injectable()
export class EnviosService {
  constructor(
    @InjectRepository(Envios)
    private readonly enviosRepository: Repository<Envios>,
  ) {}

  async findAll(): Promise<Envios[]> {
    return this.enviosRepository.find();
  }

  async findOne(id: number): Promise<Envios> {
    const envio = await this.enviosRepository.findOne({ where: { id } });
    if (!envio) {
      throw new NotFoundException(`El envío con ID ${id} no existe`);
    }
    return envio;
  }

  async create(data: Partial<Envios>): Promise<Envios> {
    const nuevoEnvio = this.enviosRepository.create(data);
    return this.enviosRepository.save(nuevoEnvio);
  }

  async update(id: number, data: Partial<Envios>): Promise<Envios> {
    const envio = await this.findOne(id);
    Object.assign(envio, data);
    return this.enviosRepository.save(envio);
  }

  async remove(id: number): Promise<void> {
    const envio = await this.findOne(id);
    await this.enviosRepository.remove(envio);
  }
}
