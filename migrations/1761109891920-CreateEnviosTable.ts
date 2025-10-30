import { MigrationInterface, QueryRunner } from "typeorm";

export class CreateEnviosTable1761109891920 implements MigrationInterface {
    name = 'CreateEnviosTable1761109891920'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE \`envios\` (\`id\` int NOT NULL AUTO_INCREMENT, \`cliente_id\` int NULL, \`origen_id\` int NOT NULL, \`destino_id\` int NOT NULL, \`remitente_nombre\` varchar(100) NOT NULL, \`remitente_telefono\` varchar(20) NULL, \`remitente_documento\` varchar(20) NULL, \`remitente_email\` varchar(100) NULL, \`tracking_code\` varchar(20) NOT NULL, \`costo_total\` decimal(10,2) NOT NULL, \`metodo_envio\` varchar(20) NOT NULL DEFAULT 'terrestre', \`estado\` varchar(30) NOT NULL DEFAULT 'registrado', \`fecha_creacion\` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP, UNIQUE INDEX \`UQ_9574170c3715989c16c886563d1\` (\`tracking_code\`), PRIMARY KEY (\`id\`)) ENGINE=InnoDB`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`DROP TABLE \`envios\``);
    }

}
