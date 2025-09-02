--Shkruani kërkesa SQL për të marrë të dhëna nga baza e të dhënave, duke përfshirë deklaratat e thjeshta SELECT, INSERT, UPDATE, dhe DELETE.



--tabela lisat e produkteve 

-- analizuar totalin e sasisë së produkteve të blera për çdo fatura dhe blerës

SELECT F.ID AS fatura_id, B.emer, B.mbiemer, SUM(L.qnt) AS total_sasi
FROM Lista_Produkteve L
JOIN Fature F ON L.fature_id = F.ID
JOIN bleres B ON F.bleres_id = B.ID
GROUP BY F.ID, B.emer, B.mbiemer;


--analizuar produktet e shitura në 10 rreshta, duke filluar nga rreshti i 21-të:

SELECT * 
FROM Lista_Produkteve
ORDER BY fature_id
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;



-- selekto ato fatura që kanë më shumë se 3 produkte

SELECT fature_id, COUNT(*) AS numri_i_produkteve
FROM Lista_Produkteve
GROUP BY fature_id
HAVING COUNT(*) > 3;

 

--UPDATE me subquery për të përditësuar sasinë për një produkt specifik

UPDATE Lista_Produkteve
SET qnt = (SELECT MAX(qnt) FROM Lista_Produkteve WHERE fature_id = 1 AND produkt_id = 'P001')
WHERE fature_id = 1 AND produkt_id = 'P001';
 

 
 
 --SELECT për të marrë produktet që janë të disponueshme në të paktën dy fatura

 SELECT produkt_id, COUNT(DISTINCT fature_id) AS fatura_count
FROM Lista_Produkteve
GROUP BY produkt_id
HAVING COUNT(DISTINCT fature_id) >= 2;



--SELECT me COALESCE për të trajtuar vlerat NULL

SELECT fature_id, COALESCE(SUM(qnt), 0) AS total_sasi
FROM Lista_Produkteve
GROUP BY fature_id;


--SELECT me WINDOW function për të llogaritur totalin kumulativ të sasive për secilën fature

SELECT fature_id, produkt_id, qnt, 
       SUM(qnt) OVER (PARTITION BY fature_id ORDER BY produkt_id) AS total_kumulativ
FROM Lista_Produkteve;




    -- Tabela: bleres

-- SELECT për të marrë mesataren e moshës për çdo qytet

SELECT b.city, AVG(DATEDIFF(YEAR, b.datelindja, GETDATE())) AS mesatarja_e_moshes
FROM Bleres AS b
INNER JOIN Fature ON b.id = Fature.bleres_id
INNER JOIN Lista_Produkteve ON Lista_Produkteve.fature_id = Fature.ID
INNER JOIN Tregton1 ON Tregton1.produkt_id = Lista_Produkteve.produkt_id
GROUP BY b.city;

--NSERT me vlerë të ngjashme për shumë rreshta

INSERT INTO bleres (ID, emer, mbiemer, datelindja, num_telefoni, email)
SELECT 201, 'Mike', 'Jordan', '1991-04-15', '1231231234', 'mike.jordan@example.com';

select *
from bleres


-- UPDATE me një subquery për të ndryshuar të gjitha të dhënat për një blerës që ka blerë një produkt të caktuar


UPDATE bleres
SET email = 'new.email@example.com'
WHERE ID IN (SELECT bleres_id FROM Fature F JOIN Lista_Produkteve L ON F.ID = L.fature_id WHERE L.produkt_id = 'P001');


select *
from bleres



--DELETE me JOIN për të fshirë të dhënat e blerësve që nuk kanë bërë asnjë blerje

DELETE B
FROM bleres B
LEFT JOIN Fature F ON B.ID = F.bleres_id
WHERE F.ID IS NULL;

 
--SELECT për të marrë të dhëna për blerësit që kanë bërë blerje të mëdha (për shuma mbi një vlerë)


SELECT B.emer, B.mbiemer, SUM(F.kosto_totale) AS total_blerje
FROM bleres B
JOIN Fature F ON B.ID = F.bleres_id
GROUP BY B.ID, B.emer, B.mbiemer
HAVING SUM(F.kosto_totale) > 100;


 --SELECT me përllogaritjen e vlerës totale të blerjeve për secilin blerës


 SELECT B.emer, B.mbiemer, SUM(F.kosto_totale) AS total_blerje
FROM bleres B
JOIN Fature F ON B.ID = F.bleres_id
GROUP BY B.ID, B.emer, B.mbiemer



-- SELECT me COUNT për të marrë numrin e faturave për secilin blerës


SELECT bleres_id, COUNT(*) AS numri_faturave
FROM Fature
GROUP BY bleres_id;


-- SELECT për të marrë faturat me shumën më të madhe të kosto totale


SELECT * FROM Fature
WHERE kosto_totale = (SELECT MAX(kosto_totale) FROM Fature);



-- UPDATE për të ndryshuar koston totale për faturat që janë mbi një vlerë


UPDATE Fature
SET kosto_totale = kosto_totale * 1.1
WHERE kosto_totale > 100;

select *
from Fature



-- DELETE për të fshirë faturat që janë krijuar para një date të caktuar


DELETE FROM Fature
WHERE data_blerjes < '2024-01-01';

select *
from Fature



--SELECT për të marrë faturat dhe numrin e produkteve për çdo fature


SELECT F.ID, COUNT(L.produkt_id) AS numri_produkteve
FROM Fature F
JOIN Lista_Produkteve L ON F.ID = L.fature_id
GROUP BY F.ID;



--SELECT për të marrë faturat që përmbajnë produktet me çmim më të lartë se një vlerë të caktuar


SELECT F.ID, SUM(P.cmimi * L.qnt) AS kosto_totale
FROM Fature F
JOIN Lista_Produkteve L ON F.ID = L.fature_id
JOIN Produkt3 P ON L.produkt_id = P.id
GROUP BY F.ID
HAVING SUM(P.cmimi * L.qnt) > 100;



--SELECT me JOIN për të marrë faturat dhe blerësit që kanë bërë ato


SELECT F.ID, B.emer, B.mbiemer, F.kosto_totale
FROM Fature F
JOIN bleres B ON F.bleres_id = B.ID;


--SELECT me CASE për të kategorizuar faturat sipas shumës së kosto totale


SELECT ID, kosto_totale,
       CASE 
           WHEN kosto_totale < 50 THEN 'Low'
           WHEN kosto_totale BETWEEN 50 AND 100 THEN 'Medium'
           ELSE 'High'
       END AS kategoria
FROM Fature;


--SELECT për faturat që kanë bërë blerësit në një periudhë të caktuar

SELECT * FROM Fature
WHERE data_blerjes BETWEEN '2024-01-01' AND '2024-12-31';

 
