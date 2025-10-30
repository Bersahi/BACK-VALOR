import { Controller, Get, Post, Put, Delete, Param, Body } from '@nestjs/common';
import { EnviosService } from './Envios.service';
import { Envios } from './Envios.entity';
import { CreateEnvioCompletoDto } from './dto/create-envio-completo.dto';

@Controller('envios')
export class EnviosController {
  constructor(private readonly enviosService: EnviosService) {}

  // GET /api/envios/todos - Endpoint específico (DEBE ir ANTES de :id)
  @Get('todos')
  async getAllTodos(): Promise<Envios[]> {
    return this.enviosService.findAll();
  }

  // GET /api/envios - Obtener todos los envíos
  @Get()
  async getAll(): Promise<Envios[]> {
    return this.enviosService.findAll();
  }

  // GET /api/envios/:id - Obtener envío por ID (DEBE ir al final)
  @Get(':id')
  async getById(@Param('id') id: number): Promise<Envios> {
    return this.enviosService.findOne(id);
  }

  // POST /api/envios/crear-completo - Crear envío completo desde formulario
  @Post('crear-completo')
  async createEnvioCompleto(@Body() dto: CreateEnvioCompletoDto): Promise<any> {
    console.log('📥 Recibido DTO para crear envío completo:', dto);
    return this.enviosService.crearEnvioCompleto(dto);
  }

  // POST /api/envios - Crear nuevo envío (método simple)
  @Post()
  async create(@Body() data: Partial<Envios>): Promise<Envios> {
    return this.enviosService.create(data);
  }

  // POST /api/envios/crear - Endpoint alternativo
  @Post('crear')
  async createEnvio(@Body() data: Partial<Envios>): Promise<Envios> {
    return this.enviosService.create(data);
  }

  // PUT /api/envios/:id - Actualizar envío
  @Put(':id')
  async update(@Param('id') id: number, @Body() data: Partial<Envios>): Promise<Envios> {
    return this.enviosService.update(id, data);
  }

  // DELETE /api/envios/:id - Eliminar envío
  @Delete(':id')
  async delete(@Param('id') id: number): Promise<void> {
    return this.enviosService.remove(id);
  }
}
