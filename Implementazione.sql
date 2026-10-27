USE unidock;

-- =============================================================================
-- STRATEGIE DI OTTIMIZZAZIONE (INDICI) [cite: 161, 162, 163, 165]
-- =============================================================================
CREATE INDEX idx_cliente ON PROPRIETARIO(Cognome);
CREATE INDEX idx_nome_barca ON IMBARCAZIONE(Nome);
CREATE INDEX idx_periodo ON CONTRATTO(Data_Inizio, Data_Fine);

-- =============================================================================
-- VINCOLI DI INTEGRITÀ (TRIGGER)
-- =============================================================================
DELIMITER //
CREATE TRIGGER Check_Date_Contratto
BEFORE INSERT ON CONTRATTO
FOR EACH ROW
BEGIN
    IF NEW.Data_Fine < NEW.Data_Inizio THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Errore: La data di fine non può precedere quella di inizio';
    END IF;
END //
DELIMITER ;

-- =============================================================================
-- OPERAZIONE 8: CALCOLO TOTALE DOVUTO (VIEW) [cite: 71, 157]
-- Risolve la ridondanza calcolando il costo base dinamicamente
-- =============================================================================
CREATE OR REPLACE VIEW Report_Contabile AS
SELECT 
    C.Num_Cont AS 'ID_Contratto',
    I.Nome AS 'Imbarcazione',
    PR.Cognome AS 'Cliente',
    -- Calcolo dinamico: Giorni * Tariffa fissa (50€) [cite: 138]
    (DATEDIFF(C.Data_Fine, C.Data_Inizio) * 50) AS 'Costo_Sosta',
    -- Calcolo Servizi Extra
    COALESCE((SELECT SUM(S.Costo) 
              FROM EROGAZIONE_SERVIZIO E 
              JOIN SERVIZIO_EXTRA S ON E.ID_Servizio = S.ID_Servizio 
              WHERE E.Num_Cont = C.Num_Cont), 0) AS 'Costo_Extra',
    -- Calcolo Penali
    COALESCE((SELECT SUM(P.Importo) 
              FROM PENALE P 
              WHERE P.Num_Cont = C.Num_Cont), 0) AS 'Costo_Penali',
    -- Totale Finale [cite: 150]
    ((DATEDIFF(C.Data_Fine, C.Data_Inizio) * 50) + 
     COALESCE((SELECT SUM(S.Costo) FROM EROGAZIONE_SERVIZIO E JOIN SERVIZIO_EXTRA S ON E.ID_Servizio = S.ID_Servizio WHERE E.Num_Cont = C.Num_Cont), 0) + 
     COALESCE((SELECT SUM(P.Importo) FROM PENALE P WHERE P.Num_Cont = C.Num_Cont), 0)) AS 'TOTALE_DOVUTO'
FROM CONTRATTO C
JOIN IMBARCAZIONE I ON C.ID_Barca = I.ID_Barca -- Join su ID numerico [cite: 98]
JOIN PROPRIETARIO PR ON I.CF_Proprietario = PR.CF;

-- Query di verifica per il professore
SELECT * FROM Report_Contabile;