
--. INNER JOIN 

--Gjej emrat e produkteve dhe shumën totale të sasisë për secilën faturë.

SELECT P.emri, SUM(LP.qnt) AS Sasia_Totale, F.id AS Fatura_ID
FROM Produkt2 P
INNER JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
INNER JOIN Fature F ON LP.fature_id = F.id
GROUP BY P.emri, F.id;


-- Gjej blerësit që kanë bërë më shumë se një blerje dhe sa janë faturat e tyre totale.

SELECT B.emer, B.mbiemer, COUNT(F.id) AS Numri_Faturave, SUM(F.kosto_totale) AS Shuma_Totale
FROM Bleres B
INNER JOIN Fature F ON B.id = F.bleres_id
GROUP BY B.emer, B.mbiemer
HAVING COUNT(F.id) > 1;


-- Gjej produktet dhe mesataren e sasisë që janë shitur për secilën.

SELECT P.emri, AVG(LP.qnt) AS Mesatarja_e_Sasise
FROM Produkt2 P
INNER JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
GROUP BY P.emri;


-- Gjej numrin e produkteve që janë në disponim për secilin dyqan.

SELECT D.name, COUNT(T.produkt_id) AS Numri_i_Produkteve
FROM Dyqani D
INNER JOIN Tregton1 T ON D.id = T.dyqan_id
GROUP BY D.name;


--: Gjej faturat dhe shumën totale të blerjes për secilën faturë.

SELECT F.id AS Fatura_ID, SUM(LP.qnt * P.cmimi) AS Shuma_Totale
FROM Fature F
INNER JOIN Lista_Produkteve LP ON F.id = LP.fature_id
INNER JOIN Produkt2 P ON LP.produkt_id = P.id
GROUP BY F.id;


--Shfaq të gjithë blerësit dhe totalin e faturave që ata kanë bërë, edhe nëse nuk kanë asnjë faturë.

SELECT B.emer, B.mbiemer, SUM(F.kosto_totale) AS Shuma_Totale
FROM Bleres B
LEFT JOIN Fature F ON B.id = F.bleres_id
GROUP BY B.emer, B.mbiemer;

-- Shfaq të gjithë produktet dhe mesataren e sasisë që janë shitur, edhe nëse nuk janë shitur kurrë.

SELECT P.emri, AVG(LP.qnt) AS Mesatarja_e_Sasise
FROM Produkt2 P
LEFT JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
GROUP BY P.emri;

--Shfaq të gjithë dyqanet dhe totalin e produkteve që kanë, edhe nëse ndonjë dyqan nuk ka asnjë produkt.

SELECT D.name, SUM(T.sasia_e_disponueshme) AS Sasia_Totale
FROM Dyqani D
LEFT JOIN Tregton1 T ON D.id = T.dyqan_id
GROUP BY D.name;

--: Gjej blerësit dhe totalin e shumës që kanë shpenzuar, edhe nëse ata nuk kanë bërë asnjë blerje.

SELECT B.emer, B.mbiemer, COALESCE(SUM(F.kosto_totale), 0) AS Shuma_Totale
FROM Bleres B
LEFT JOIN Fature F ON B.id = F.bleres_id
GROUP BY B.emer, B.mbiemer;


-- Gjej produktet dhe numrin e dyqaneve që i shesin ato.

SELECT P.emri, COUNT(DISTINCT D.name) AS Numri_i_Dyqaneve
FROM Produkt2 P
LEFT JOIN Tregton1 T ON P.id = T.produkt_id
LEFT JOIN Dyqani D ON T.dyqan_id = D.id
GROUP BY P.emri;



-- Gjej produktet që janë shitur dhe numrin e faturave që i kanë blerë.

SELECT P.emri, COUNT(F.id) AS Numri_Faturave
FROM Produkt2 P
RIGHT JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
RIGHT JOIN Fature F ON LP.fature_id = F.id
GROUP BY P.emri;


-- Gjej të gjitha faturat dhe shumën totale të produkteve të blera.
 
SELECT F.id AS Fatura_ID, SUM(LP.qnt * P.cmimi) AS Shuma_Totale
FROM Fature F
RIGHT JOIN Lista_Produkteve LP ON F.id = LP.fature_id
RIGHT JOIN Produkt2 P ON LP.produkt_id = P.id
GROUP BY F.id;


-- Gjej numrin e dyqaneve dhe shumën e sasisë të produkteve që ata shesin.

SELECT D.name, SUM(T.sasia_e_disponueshme) AS Sasia_Totale
FROM Dyqani D
RIGHT JOIN Tregton1 T ON D.id = T.dyqan_id
GROUP BY D.name;


-- Shfaq produktet dhe totalin e sasive të shitura për çdo fature.

SELECT P.emri, SUM(LP.qnt) AS Sasia_Totale
FROM Produkt2 P
RIGHT JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
RIGHT JOIN Fature F ON LP.fature_id = F.id
GROUP BY P.emri;


-- Gjej të gjithë blerësit dhe shumën totale të faturave të tyre, edhe nëse nuk kanë bërë asnjë blerje.

SELECT B.emer, B.mbiemer, SUM(F.kosto_totale) AS Shuma_Totale
FROM Bleres B
RIGHT JOIN Fature F ON B.id = F.bleres_id
GROUP BY B.emer, B.mbiemer;
 

-- Gjej të gjitha produktet dhe shumën totale të sasive të shitura për secilën fature.

SELECT P.emri, SUM(LP.qnt) AS Sasia_Totale
FROM Produkt2 P
FULL OUTER JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
FULL OUTER JOIN Fature F ON LP.fature_id = F.id
GROUP BY P.emri;


-- Shfaq të gjithë blerësit dhe totalin e shumës që kanë shpenzuar, edhe nëse nuk kanë bërë asnjë blerje.

SELECT B.emer, B.mbiemer, SUM(F.kosto_totale) AS Shuma_Totale
FROM Bleres B
FULL OUTER JOIN Fature F ON B.id = F.bleres_id
GROUP BY B.emer, B.mbiemer;


--Gjej të gjithë dyqanet dhe produktet që janë ose nuk janë të disponueshme.

SELECT D.name, P.emri, SUM(T.sasia_e_disponueshme) AS Sasia_Totale
FROM Dyqani D
FULL OUTER JOIN Tregton1 T ON D.id = T.dyqan_id
FULL OUTER JOIN Produkt2 P ON T.produkt_id = P.id
GROUP BY D.name, P.emri;


--Gjej të gjitha faturat dhe produktet që janë ose nuk janë të blera.

SELECT F.id AS Fatura_ID, P.emri
FROM Fature F
FULL OUTER JOIN Lista_Produkteve LP ON F.id = LP.fature_id
FULL OUTER JOIN Produkt2 P ON LP.produkt_id = P.id;


-- Gjej të gjithë produktet dhe dyqanet ku ato janë ose nuk janë të disponueshme.

SELECT P.emri, D.name
FROM Produkt2 P
FULL OUTER JOIN Tregton1 T ON P.id = T.produkt_id
FULL OUTER JOIN Dyqani D ON T.dyqan_id = D.id;


-- Shfaq të gjitha faturat me emrin e blerësit, totalin e shumës së faturës, dhe produktet që janë blerë, edhe nëse nuk janë të disponueshme në dyqan.


SELECT 
    F.id AS Fatura_ID, 
    B.emer, 
    B.mbiemer, 
    F.kosto_totale,
    P.emri AS Produkt,
    D.name AS Dyqan
FROM Fature F
INNER JOIN Bleres B ON F.bleres_id = B.id
LEFT JOIN Lista_Produkteve LP ON F.id = LP.fature_id
LEFT JOIN Produkt2 P ON LP.produkt_id = P.id
RIGHT JOIN Tregton1 T ON P.id = T.produkt_id
RIGHT JOIN Dyqani D ON T.dyqan_id = D.id;



--Shfaq të gjithë blerësit dhe faturat që ata kanë bërë, përfshirë blerësit që nuk kanë bërë asnjë faturë, dhe gjithashtu shfaq produktet që ata kanë blerë.

SELECT 
    B.emer, 
    B.mbiemer, 
    F.id AS Fatura_ID, 
    P.emri AS Produkt
FROM Bleres B
LEFT JOIN Fature F ON B.id = F.bleres_id
INNER JOIN Lista_Produkteve LP ON F.id = LP.fature_id
INNER JOIN Produkt2 P ON LP.produkt_id = P.id;


--Gjej të gjithë dyqanet dhe produktet që ata shesin, përfshirë dyqanet që nuk kanë asnjë produkt të disponueshëm, dhe gjithashtu shfaq faturat për produktet që janë shitur.

SELECT 
    D.name AS Dyqan, 
    P.emri AS Produkt, 
    F.id AS Fatura_ID
FROM Dyqani D
RIGHT JOIN Tregton1 T ON D.id = T.dyqan_id
LEFT JOIN Produkt2 P ON T.produkt_id = P.id
INNER JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
INNER JOIN Fature F ON LP.fature_id = F.id;


-- Shfaq të gjithë produktet dhe dyqanet që i shesin ato, edhe nëse ndonjë produkt nuk ka asnjë dyqan, dhe gjithashtu shfaq shumën totale të produkteve që janë shitur.


SELECT 
    P.emri AS Produkt, 
    D.name AS Dyqan, 
    SUM(LP.qnt) AS Sasia_Totale
FROM Produkt2 P
FULL OUTER JOIN Tregton1 T ON P.id = T.produkt_id
LEFT JOIN Dyqani D ON T.dyqan_id = D.id
INNER JOIN Lista_Produkteve LP ON P.id = LP.produkt_id
GROUP BY P.emri, D.name;



-- Shfaq të gjithë blerësit dhe faturat që ata kanë bërë, edhe nëse ata nuk kanë asnjë faturë, dhe gjithashtu shfaq produktet dhe sasinë e blerë për secilën fature.

SELECT 
    B.emer, 
    B.mbiemer, 
    F.id AS Fatura_ID, 
    P.emri AS Produkt, 
    LP.qnt AS Sasia
FROM Bleres B
LEFT JOIN Fature F ON B.id = F.bleres_id
RIGHT JOIN Lista_Produkteve LP ON F.id = LP.fature_id
RIGHT JOIN Produkt2 P ON LP.produkt_id = P.id;



