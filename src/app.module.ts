import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { NotificacionesModule } from './Notificaciones/Notificaciones.module';
import { EnviosModule } from './Envios/Envios.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: `.env.${process.env.NODE_ENV || 'development'}`,
    }),
    
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

    // Módulos de la aplicación
    NotificacionesModule,
    EnviosModule,
  ],
  controllers: [],
  providers: [],
})
export class AppModule {}
