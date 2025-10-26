import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { EnviosService } from './Envios.service';
import { Envios } from './Envios.entity';

@Controller('envios')
export class EnviosController {
  constructor(private readonly enviosService: EnviosService) {}

  @Get('todos')
  async getAll(): Promise<Envios[]> {
    return this.enviosService.findAll();
  }

  @Get(':id')
  async getById(@Param('id') id: number): Promise<Envios> {
    return this.enviosService.findOne(id);
  }


  @Post('crear')
  async create(@Body() data: Partial<Envios>): Promise<Envios> {
    return this.enviosService.create(data);
  }

  @Put(':id')
  async update(@Param('id') id: number, @Body() data: Partial<Envios>): Promise<Envios> {
    return this.enviosService.update(id, data);
  }

  @Delete(':id')
  async delete(@Param('id') id: number): Promise<void> {
    return this.enviosService.remove(id);
  }

  
}
