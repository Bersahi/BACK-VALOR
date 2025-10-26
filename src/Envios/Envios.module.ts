import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Envios } from './Envios.entity';
import { EnviosService } from './Envios.service';
import { EnviosController } from './Envios.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Envios])],
  providers: [EnviosService],
  controllers: [EnviosController],
})
export class EnviosModule {}

