import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { EnviosController } from './Envios/Envios.controller';
import { EnviosService } from './Envios/Envios.service';
import { Envios } from './Envios/Envios.entity';
import { Direcciones } from './Direcciones/Direcciones.entity';
import { Paquetes } from './Paquetes/Paquetes.entity';
import { DireccionesService } from './Direcciones/Direcciones.service';
import { PaquetesService } from './Paquetes/Paquetes.service';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: `.env.${process.env.NODE_ENV || 'development'}`,
    }),
    TypeOrmModule.forFeature([Envios, Direcciones, Paquetes]),

    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      inject: [ConfigService],
      useFactory: (configService: ConfigService) => ({
        type: 'mysql',
        host: '127.0.0.1',
        port: 3308,
        username: 'admin',
        password: 'admin123',
        database: 'valorexpress',
        entities: [__dirname + '/**/*.entity{.ts,.js}'],
        synchronize: false,
        logging: true,
        charset: 'utf8mb4',
        timezone: '+00:00',
      }),
    }),
  ],
  controllers: [EnviosController],
  providers: [EnviosService, DireccionesService, PaquetesService],
})
export class AppModule {}
