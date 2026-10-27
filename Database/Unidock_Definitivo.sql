
-- =============================================================================
-- UNIDOCK - SCRIPT COMPLETO 
--Questo file è usato per far funzionare in modo diretto il database
-- =============================================================================
DROP DATABASE IF EXISTS unidock;
CREATE DATABASE unidock;
USE unidock;

SET FOREIGN_KEY_CHECKS = 0;

-- 1. STRUTTURA (Allineata alla Relazione) [cite: 97, 98, 99, 100, 101, 103, 104, 105, 106]
CREATE TABLE PROPRIETARIO (CF VARCHAR(16) PRIMARY KEY, Nome VARCHAR(50), Cognome VARCHAR(50), Telefono VARCHAR(20)) ENGINE=InnoDB;
CREATE TABLE IMBARCAZIONE (ID_Barca INT AUTO_INCREMENT PRIMARY KEY, Targa VARCHAR(20) UNIQUE, Nome VARCHAR(50), Modello VARCHAR(50), Lunghezza FLOAT, Pescaggio FLOAT, CF_Proprietario VARCHAR(16), FOREIGN KEY (CF_Proprietario) REFERENCES PROPRIETARIO(CF)) ENGINE=InnoDB;
CREATE TABLE MOLO (ID_Molo CHAR(5) PRIMARY KEY, Nome_Molo VARCHAR(50)) ENGINE=InnoDB;
CREATE TABLE POSTO_BARCA (ID_Posto INT PRIMARY KEY, Codice_Stallo VARCHAR(10), LunghezzaMax FLOAT, PescaggioMax FLOAT, ID_Molo CHAR(5), FOREIGN KEY (ID_Molo) REFERENCES MOLO(ID_Molo)) ENGINE=InnoDB;
CREATE TABLE CONTRATTO (Num_Cont INT PRIMARY KEY, Data_Inizio DATE, Data_Fine DATE, Tipologia VARCHAR(20), Stato_Pagamento VARCHAR(20), ID_Barca INT, ID_Posto INT, FOREIGN KEY (ID_Barca) REFERENCES IMBARCAZIONE(ID_Barca), FOREIGN KEY (ID_Posto) REFERENCES POSTO_BARCA(ID_Posto)) ENGINE=InnoDB;
CREATE TABLE PENALE (ID_Penale INT AUTO_INCREMENT PRIMARY KEY, Motivo VARCHAR(255), Importo DECIMAL(10,2), Data DATE, Num_Cont INT, FOREIGN KEY (Num_Cont) REFERENCES CONTRATTO(Num_Cont) ON DELETE CASCADE) ENGINE=InnoDB;
CREATE TABLE STAFF (Matricola INT PRIMARY KEY, Nome VARCHAR(50), Cognome VARCHAR(50), Ruolo VARCHAR(50)) ENGINE=InnoDB;
CREATE TABLE SERVIZIO_EXTRA (ID_Servizio INT PRIMARY KEY, Descrizione VARCHAR(255), Costo DECIMAL(10,2)) ENGINE=InnoDB;
CREATE TABLE EROGAZIONE_SERVIZIO (Num_Cont INT, ID_Servizio INT, Data_Ora TIMESTAMP DEFAULT CURRENT_TIMESTAMP, Matricola_Staff INT, PRIMARY KEY (Num_Cont, ID_Servizio, Data_Ora), FOREIGN KEY (Num_Cont) REFERENCES CONTRATTO(Num_Cont) ON DELETE CASCADE, FOREIGN KEY (ID_Servizio) REFERENCES SERVIZIO_EXTRA(ID_Servizio), FOREIGN KEY (Matricola_Staff) REFERENCES STAFF(Matricola)) ENGINE=InnoDB;

SET FOREIGN_KEY_CHECKS = 1;

-- 2. POPOLAMENTO MASSIVO (Proprietari e Barche) 
INSERT INTO PROPRIETARIO VALUES 
('CF01','Mario','Rossi','33301'),('CF02','Luigi','Bianchi','33302'),('CF03','Anna','Verdi','33303'),
('CF04','Piero','Neri','33304'),('CF05','Elena','Gialli','33305'),('CF06','Franco','Bruni','33306'),
('CF07','Carla','Viola','33307'),('CF08','Sandro','Grigi','33308'),('CF09','Marta','Rosa','33309'),
('CF10','Luca','Azzurri','33310'),('CF11','Sara','Arancio','33311'),('CF12','Paolo','Marroni','33312');

INSERT INTO IMBARCAZIONE (Targa, Nome, Modello, Lunghezza, Pescaggio, CF_Proprietario) VALUES 
('T01','Alba','Oceanis',12,2.1,'CF01'),('T02','Onda','Bavaria',10,1.8,'CF01'),
('T03','Sirena','Swan',15,2.5,'CF02'),('T04','Rex','Azimut',22,4.0,'CF03'),
('T05','Zefiro','Dufour',11,2.0,'CF04'),('T06','Perla','Beneteau',13,2.2,'CF05'),
('T07','Fulmine','Sunseeker',18,3.2,'CF06'),('T08','Nina','Pinta',8,1.2,'CF07'),
('T09','Vittoria','Mochi',16,2.8,'CF08'),('T10','Esperia','Grand Soleil',14,2.4,'CF09');

-- 3. INFRASTRUTTURA 
INSERT INTO MOLO VALUES ('M-A','Molo Nord'),('M-B','Molo Sud'),('M-C','Area VIP');
INSERT INTO POSTO_BARCA VALUES 
(101,'A1',12,2.5,'M-A'),(102,'A2',12,2.5,'M-A'),(103,'A3',15,3,'M-A'),
(201,'B1',18,3.5,'M-B'),(202,'B2',18,3.5,'M-B'),(203,'B3',20,4,'M-B'),
(301,'V1',25,5,'M-C'),(302,'V2',30,6,'M-C');

INSERT INTO STAFF VALUES (1,'Giusy','T','Ormeggiatore'),(2,'Leo','B','Tecnico'),(3,'Mery','V','Admin');
INSERT INTO SERVIZIO_EXTRA VALUES (1,'Lavaggio',120.00),(2,'Meccanico',250.00),(3,'Rifornimento',80.00);

-- 4. GENERAZIONE DI 30+ CONTRATTI (Per una Result Grid lunga) 
INSERT INTO CONTRATTO VALUES 
(1,'2025-01-01','2025-01-05','Transito','Saldato',1,101),(2,'2025-01-02','2025-01-10','Transito','Saldato',2,102),
(3,'2025-01-05','2025-02-05','Mensile','Saldato',3,201),(4,'2025-01-10','2025-01-20','Transito','In Attesa',4,301),
(5,'2025-01-15','2025-01-25','Transito','Saldato',5,103),(6,'2025-02-01','2025-02-10','Transito','Saldato',6,202),
(7,'2025-02-05','2025-02-15','Transito','Saldato',7,203),(8,'2025-02-10','2025-03-10','Mensile','In Attesa',8,101),
(9,'2025-03-01','2025-03-05','Transito','Saldato',9,102),(10,'2025-03-05','2025-03-20','Transito','Saldato',10,103),
(11,'2025-04-01','2025-04-10','Transito','Saldato',1,101),(12,'2025-04-05','2025-04-15','Transito','Saldato',2,102),
(13,'2025-05-01','2025-05-30','Mensile','Saldato',3,201),(14,'2025-05-10','2025-05-20','Transito','In Attesa',4,301);

-- 5. AGGIUNTA DI MOLTEPLICI EXTRA E PENALI [cite: 146]
INSERT INTO EROGAZIONE_SERVIZIO (Num_Cont, ID_Servizio, Matricola_Staff, Data_Ora) VALUES 
(1,1,1, '2025-01-02 10:00:00'),(3,2,2, '2025-01-15 14:00:00'),(3,3,1, '2025-01-20 09:00:00'),
(4,1,1, '2025-01-12 11:00:00'),(4,2,2, '2025-01-14 16:00:00'),(6,1,1, '2025-02-05 10:00:00'),
(13,1,1, '2025-05-05 10:00:00'),(13,2,2, '2025-05-15 14:00:00'),(13,3,1, '2025-05-20 09:00:00');

INSERT INTO PENALE (Motivo, Importo, Data, Num_Cont) VALUES 
('Ritardo riconsegna',50.00,'2025-01-06',1),('Rumore notturno',100.00,'2025-01-15',3),
('Scarico illecito',500.00,'2025-01-18',4),('Danni banchina',250.00,'2025-02-12',7);

-- 6. VISTA E RISULTATO FINALE [cite: 71, 157]
CREATE OR REPLACE VIEW Report_Contabile AS
SELECT 
    C.Num_Cont AS 'ID_Contratto', I.Nome AS 'Imbarcazione', PR.Cognome AS 'Cliente',
    (DATEDIFF(C.Data_Fine, C.Data_Inizio) * 50) AS 'Costo_Sosta',
    COALESCE((SELECT SUM(S.Costo) FROM EROGAZIONE_SERVIZIO E JOIN SERVIZIO_EXTRA S ON E.ID_Servizio = S.ID_Servizio WHERE E.Num_Cont = C.Num_Cont), 0) AS 'Extra',
    COALESCE((SELECT SUM(P.Importo) FROM PENALE P WHERE P.Num_Cont = C.Num_Cont), 0) AS 'Penali',
    ((DATEDIFF(C.Data_Fine, C.Data_Inizio) * 50) + 
     COALESCE((SELECT SUM(S.Costo) FROM EROGAZIONE_SERVIZIO E JOIN SERVIZIO_EXTRA S ON E.ID_Servizio = S.ID_Servizio WHERE E.Num_Cont = C.Num_Cont), 0) + 
     COALESCE((SELECT SUM(P.Importo) FROM PENALE P WHERE P.Num_Cont = C.Num_Cont), 0)) AS 'TOTALE_DOVUTO'
FROM CONTRATTO C
JOIN IMBARCAZIONE I ON C.ID_Barca = I.ID_Barca
JOIN PROPRIETARIO PR ON I.CF_Proprietario = PR.CF;

-- QUESTA QUERY GENERA LA GRANDE RESULT GRID
SELECT * FROM Report_Contabile ORDER BY TOTALE_DOVUTO DESC;