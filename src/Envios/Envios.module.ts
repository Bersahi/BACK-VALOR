import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Envios } from './Envios.entity';
import { Direcciones } from '../Direcciones/Direcciones.entity';
import { Paquetes } from '../Paquetes/Paquetes.entity';
import { EnviosService } from './Envios.service';
import { EnviosController } from './Envios.controller';
import { DireccionesService } from '../Direcciones/Direcciones.service';
import { PaquetesService } from '../Paquetes/Paquetes.service';
import { NotificacionesModule } from '../Notificaciones/Notificaciones.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Envios, Direcciones, Paquetes]),
    NotificacionesModule, // Importar módulo de notificaciones
  ],
  providers: [EnviosService, DireccionesService, PaquetesService],
  controllers: [EnviosController],
  exports: [EnviosService],
})
export class EnviosModule {}

