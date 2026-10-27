-- =============================================================================
-- UNIDOCK - TEST MASSIVO (GRANDE RESULT GRID)
-- =============================================================================
USE unidock;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE EROGAZIONE_SERVIZIO; TRUNCATE TABLE PENALE; TRUNCATE TABLE CONSUMO;
TRUNCATE TABLE CONTRATTO; TRUNCATE TABLE POSTO_BARCA; TRUNCATE TABLE IMBARCAZIONE;
TRUNCATE TABLE PROPRIETARIO; TRUNCATE TABLE STAFF; TRUNCATE TABLE SERVIZIO_EXTRA;
SET FOREIGN_KEY_CHECKS = 1;

-- POPOLAMENTO MASSIVO [cite: 126]
INSERT INTO MOLO VALUES ('M-A','Molo Nord'),('M-B','Molo Sud'),('M-C','Area VIP');

INSERT INTO STAFF VALUES 
(1,'Mario','Ormeggiatore','Staff'),(2,'Elena','Tecnico','Staff'),(3,'Luca','Logistica','Staff');

INSERT INTO SERVIZIO_EXTRA VALUES 
(1,'Lavaggio Carena',120.00),(2,'Tagliando Motore',250.00),(3,'Rifornimento',80.00);

-- 12 PROPRIETARI E BARCHE
INSERT INTO PROPRIETARIO VALUES 
('CF01','Marco','Rossi','33301'),('CF02','Anna','Bianchi','33302'),('CF03','Sandro','Verdi','33303'),
('CF04','Paola','Neri','33304'),('CF05','Luigi','Gialli','33305'),('CF06','Carla','Bruni','33306'),
('CF07','Enzo','Viola','33307'),('CF08','Marta','Grigi','33308'),('CF09','Ugo','Rosa','33309'),
('CF10','Lia','Azzurri','33310'),('CF11','Sara','Arancio','33311'),('CF12','Leo','Oro','33312');

INSERT INTO IMBARCAZIONE (Targa, Nome, Lunghezza, Pescaggio, CF_Proprietario) VALUES 
('T01','Alba',11.5,2.0,'CF01'),('T02','Onda',9.0,1.5,'CF01'),('T03','Sirena',14.2,2.5,'CF02'),
('T04','Rex',20.5,4.0,'CF03'),('T05','Zefiro',10.8,1.9,'CF04'),('T06','Perla',13.0,2.1,'CF05'),
('T07','Fulmine',18.0,3.5,'CF06'),('T08','Nina',8.5,1.1,'CF07'),('T09','Vittoria',15.5,2.9,'CF08'),
('T10','Esperia',13.8,2.3,'CF09'),('T11','Dardo',19.0,3.8,'CF10'),('T12','Luna',12.2,2.0,'CF11');

INSERT INTO POSTO_BARCA VALUES 
(101,'A1',12,2.5,'M-A'),(102,'A2',12,2.5,'M-A'),(103,'A3',15,3.0,'M-A'),
(201,'B1',18,3.5,'M-B'),(202,'B2',18,3.5,'M-B'),(203,'B3',20,4.0,'M-B'),
(301,'V1',25,5.0,'M-C'),(302,'V2',30,6.0,'M-C');

-- GENERAZIONE DI 15 CONTRATTI CON VARIABILI DIVERSE
INSERT INTO CONTRATTO VALUES 
(1,'2025-01-01','2025-01-10','Transito','Saldato',1,101),(2,'2025-01-05','2025-01-15','Transito','Saldato',2,102),
(3,'2025-01-10','2025-02-10','Mensile','Saldato',3,201),(4,'2025-02-01','2025-02-28','Mensile','In Attesa',4,301),
(5,'2025-02-05','2025-02-15','Transito','Saldato',5,103),(6,'2025-03-01','2025-03-10','Transito','Saldato',6,202),
(7,'2025-03-15','2025-03-25','Transito','Saldato',7,203),(8,'2025-04-01','2025-05-01','Mensile','In Attesa',8,101),
(9,'2025-04-10','2025-04-20','Transito','Saldato',9,102),(10,'2025-05-01','2025-05-15','Transito','Saldato',10,103);

-- AGGIUNTA DI EXTRA E PENALI MASSIVE [cite: 146]
INSERT INTO EROGAZIONE_SERVIZIO (Num_Cont, ID_Servizio, Matricola_Staff) VALUES 
(1,1,1),(3,2,2),(3,3,1),(4,1,1),(4,2,2),(10,1,1),(10,2,2),(10,3,1);

INSERT INTO PENALE (Motivo, Importo, Data, Num_Cont) VALUES 
('Ritardo riconsegna',50.00,'2025-01-11',1),('Scarico illecito',500.00,'2025-02-15',4),
('Rumore molesto',100.00,'2025-03-20',6),('Danni banchina',250.00,'2025-05-16',10);

-- MOSTRA LA GRANDE RESULT GRID
SELECT * FROM Report_Contabile ORDER BY TOTALE_DOVUTO DESC;