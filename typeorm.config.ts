import { DataSource } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { config } from 'dotenv';
import { Envios } from './src/Envios/Envios.entity';

config();

const configService = new ConfigService();

export default new DataSource({
  type: 'oracle',
  host: configService.get('DB_HOST', 'localhost'),
  port: configService.get('DB_PORT', 1521),
  username: configService.get('DB_USERNAME', 'admin'),
  password: configService.get('DB_PASSWORD', 'admin123'),
  database: configService.get('DB_NAME', 'paqueteria'),
  entities: [Envios],
  migrations: ['migrations/*.ts'],
  connectString: '(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(HOST=localhost)(PORT=1521))(CONNECT_DATA=(SERVER=DEDICATED)(SERVICE_NAME=paqueteria)))',
});