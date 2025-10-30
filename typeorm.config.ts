import { DataSource } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { config } from 'dotenv';
import { Envios } from './src/Envios/Envios.entity';

config();

const configService = new ConfigService();

export default new DataSource({
  type: 'mysql',
  host: configService.get('DB_HOST', 'localhost'),
  port: configService.get('DB_PORT', 3308),
  username: configService.get('DB_USERNAME', 'admin'),
  password: configService.get('DB_PASSWORD', 'admin123'),
  database: configService.get('DB_NAME', 'valorexpress'),
  entities: [Envios],
  migrations: ['migrations/*.ts'],
  charset: 'utf8mb4',
  timezone: '+00:00',
});