const mysql = require('mysql2/promise');

async function testConnection() {
  try {
    console.log('Intentando conectar a MySQL...');
    console.log('Host: 127.0.0.1');
    console.log('Port: 3308');
    console.log('User: admin');
    console.log('Database: valorexpress');
    
    const connection = await mysql.createConnection({
      host: '127.0.0.1',
      port: 3308,
      user: 'admin',
      password: 'admin123',
      database: 'valorexpress'
    });
    
    console.log('\n✅ CONEXIÓN EXITOSA!');
    
    const [rows] = await connection.execute('SELECT COUNT(*) as total FROM envios');
    console.log(`Total de envíos: ${rows[0].total}`);
    
    await connection.end();
    process.exit(0);
  } catch (error) {
    console.error('\n❌ ERROR DE CONEXIÓN:');
    console.error(error.message);
    console.error(error.code);
    process.exit(1);
  }
}

testConnection();

