import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Configurar CORS para permitir requests del frontend (Next.js)
  app.enableCors({
    origin: [
      'http://localhost:3000',  // Next.js corre por defecto en puerto 3000
      'http://127.0.0.1:3000',  // Algunos navegadores usan 127.0.0.1 en lugar de localhost
    ],
    credentials: true,
    methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
    allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
  });
  
  // Establecer prefijo global para todas las rutas
  app.setGlobalPrefix('api');
  
  // Puerto configurable o por defecto 3001 para coincidir con frontend
  const port = process.env.PORT ?? 3001;
  await app.listen(port);
  console.log(`🚀 Backend corriendo en http://localhost:${port}/api`);
}
bootstrap();
