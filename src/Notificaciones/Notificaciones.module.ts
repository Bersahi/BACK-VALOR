import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Notificaciones } from './Notificaciones.entity';
import { NotificacionesService } from './Notificaciones.service';
import { NotificacionesController } from './Notificaciones.controller';
import { NotificacionesGateway } from './Notificaciones.gateway';

@Module({
  imports: [
    TypeOrmModule.forFeature([Notificaciones]),
  ],
  providers: [NotificacionesService, NotificacionesGateway],
  controllers: [NotificacionesController],
  exports: [NotificacionesService, NotificacionesGateway], // Exportar para usar en otros módulos
})
export class NotificacionesModule {}

