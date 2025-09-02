--Përdor funksionet e grupimit si SUM, AVG, COUNT, MIN, dhe MAX për të agreguar të dhënat 
--e shitjeve bazuar në kritere të ndryshme 
--(p.sh., kategoria e produktit, vendndodhja e klientit, periudha kohore).		



--1. Analiza bazuar te produktet

--Cili është produkti më i shitur (bazuar në sasi)?
   
   SELECT TOP 1 p.emri AS Produkti, SUM(lp.qnt) AS Sasia_Total
   FROM Produkt2 p
   JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY p.id, p.emri
   ORDER BY Sasia_Total DESC;

--2. Cili është produkti më pak i shitur (bazuar në sasi)?
   
   SELECT TOP 1 p.emri AS Produkti, SUM(lp.qnt) AS Sasia_Total
   FROM Produkt2 p
   JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY p.id, p.emri
   ORDER BY Sasia_Total ASC;

--3. Sa është shuma totale e të ardhurave nga çdo produkt?
   
   SELECT p.emri AS Produkti, SUM(lp.qnt * p.cmimi) AS Te_Ardhurat
   FROM Produkt2 p
   JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY p.id, p.emri
   ORDER BY Te_Ardhurat DESC;


--4. Sa është çmimi mesatar i produkteve?
   
   SELECT AVG(cmimi) AS Cmimi_Mesatar
   FROM Produkt2;
   

-- Cili produkt ka çmimin maksimal dhe minimal?
   -- Maksimal:
     
     SELECT TOP 1 emri AS Produkti, max(cmimi)
     FROM Produkt2
     group by emri
    
     
   --Minimal:
     SELECT TOP 1 emri AS Produkti, min(cmimi)
     FROM Produkt2
     group by emri


 -- Mesatarja e sasisë së shitur për secilin produkt
   
   SELECT p.emri AS Produkti, AVG(lp.qnt) AS Mesatarja_Sasise
   FROM Produkt2 p
   JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY p.id, p.emri;



   --8. Cili është produkti me më shumë shitje (bazuar në të ardhura totale)?
   
   SELECT TOP 1 p.emri AS Produkti, SUM(lp.qnt * p.cmimi) AS Te_Ardhurat
   FROM Produkt2 p
   JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY p.id, p.emri
   ORDER BY Te_Ardhurat DESC;


--shtojme ne tabelen produkt nje kolone katrgotia
/*Shtimi i nje kolone te re ne tabelen prodkti*/
select *
from Produkt2
alter table Produkt2 add kategoria varchar(45)
 UPDATE Produkt2
SET kategoria = CASE 
    WHEN CAST(id AS VARCHAR) IN ('PR001', 'PR002', 'PR003', '3', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', 
                '16', '17', '18', '19', '24', '27', '50', '51', '52', '53', '54', '55', '56', '57', '58', '59', '61', 
                '62', '63', '64', '65', '66', '67', '68', '83', '85', '86', '87', '88', '89', '90', '91', '92', '93', 
                '94', '95', '96', '97', '98', '99', '100') 
        THEN 'Kompjuter'
    
    WHEN CAST(id AS VARCHAR) IN ('20', '28', '69', '81', '82', '84') 
        THEN 'Ipad'
   
    WHEN CAST(id AS VARCHAR) IN ('21', '25', '26', '29', '30', '31', '32', '33', '34', '35', '36', '37', '38', '39', '71') 
        THEN 'PC'
    
    WHEN CAST(id AS VARCHAR) = '22' 
        THEN 'Printer'
    
    WHEN CAST(id AS VARCHAR) IN ('23', '40', '41', '42', '43', '44', '45', '46', '47', '48', '49') 
        THEN 'Projektor'
   
    WHEN CAST(id AS VARCHAR) IN ('70', '72', '73', '74', '75', '76', '77', '78', '79') 
        THEN 'Laptop'
    else 'Tjeter'
END;

select *
from Produkt2

-- Gjeni numrin total të produkteve për secilën kategori dhe renditeni nga kategoria me më shumë produkte në mënyrë rënësese.
SELECT kategoria, COUNT(*) AS numri_i_produkteve
FROM Produkt2
GROUP BY kategoria
ORDER BY numri_i_produkteve DESC;

--Cilat janë kategoritë që përmbajnë më shumë se 10 produkte?
SELECT kategoria, COUNT(*) AS numri_i_produkteve
FROM Produkt2
GROUP BY kategoria
HAVING COUNT(*) > 10;

--cilat janë produktet që i përkasin kategorisë "Kompjuter"?
SELECT id, emri
FROM Produkt2
WHERE kategoria = 'Kompjuter';


--Cilat janë kategoritë që përmbajnë më pak se 5 produkte?

SELECT kategoria, COUNT(*) AS numri_i_produkteve
FROM Produkt2
GROUP BY kategoria
HAVING COUNT(*) < 5;

--Gjeni kategoritë dhe produktet që janë më të shtrenjta, duke i grupuar sipas kategorisë (për të marrë vlerën maksimale për çdo kategori).
SELECT kategoria, MAX(cmimi) AS cmimi_ma_i_larte
FROM Produkt2
GROUP BY kategoria;


-- Shuma e shitjeve për secilën kategori të produktit

SELECT kategoria, SUM(f.kosto_totale) AS Shuma_Shitjeve
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN Fature f ON lp.fature_id = f.id
GROUP BY kategoria
ORDER BY Shuma_Shitjeve DESC;


--Mesatarja e shitjeve për secilën kategori të produktit

SELECT kategoria, AVG(f.kosto_totale) AS Mesatarja_Shitjeve
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN Fature f ON lp.fature_id = f.id
GROUP BY kategoria
ORDER BY Mesatarja_Shitjeve DESC;


--Shuma e të ardhurave nga shitjet për çdo periudhë kohore (vit ose muaj)

SELECT YEAR(f.data_blerjes) AS Viti, ROUND(SUM(f.kosto_totale), 2) AS Shuma_Totale
FROM Fature f
GROUP BY YEAR(f.data_blerjes)
ORDER BY Viti;


-- Cilat janë dyqanet me shitjet më të larta në secilin qytet?

SELECT d.city, d.name AS Dyqani, SUM(f.kosto_totale) AS Shuma_Shitjeve
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id
JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
JOIN Fature f ON lp.fature_id = f.id
GROUP BY d.city, d.name
ORDER BY Shuma_Shitjeve DESC;

--Shuma totale e shitjeve për secilën periudhë kohore (p.sh., muaj):
 SELECT MONTH(f.data_blerjes) AS Muaji, ROUND(SUM(f.kosto_totale), 2) AS Shuma_Totale
FROM Fature f
GROUP BY MONTH(f.data_blerjes)
ORDER BY Muaji;



-- Analiza bazuar te klientë

-- Sa është shpenzimi total i çdo klienti?
   
   SELECT b.emer AS Klienti, b.mbiemer, SUM(f.kosto_totale) AS Shpenzimi_Total
   FROM bleres b
   JOIN Fature f ON b.id = f.bleres_id
   GROUP BY b.id, b.emer, b.mbiemer
   ORDER BY Shpenzimi_Total DESC;


--10. Sa është shpenzimi mesatar i klientëve?
    
    SELECT AVG(f.kosto_totale) AS Shpenzimi_Mesatar
    FROM Fature f;
    


    --11. Cili është klienti me shpenzimin maksimal dhe minimal?
 --Maksimal:
     
      SELECT TOP 1 b.emer AS Klienti, b.mbiemer, MAX(kosto_totale) AS Shpenzimi_Total
      FROM Bleres b
      JOIN Fature f ON b.id = f.bleres_id
      GROUP BY b.id, b.emer, b.mbiemer
      order by MAX(kosto_totale) DESC
       
      
-- Minimal:
     
      SELECT TOP 1 b.emer AS Klienti, b.mbiemer, Min(kosto_totale) AS Shpenzimi_Total
      FROM Bleres b
      JOIN Fature f ON b.id = f.bleres_id
      GROUP BY b.id, b.emer, b.mbiemer
      order by Min(kosto_totale) asc


--12. Numri total i blerjeve për secilin klient.
    
    SELECT b.emer AS Klienti, b.mbiemer, COUNT(f.id) AS Numri_Blerjeve
    FROM Bleres b
    JOIN Fature f ON b.id = f.bleres_id
    GROUP BY b.id, b.emer, b.mbiemer
    ORDER BY Numri_Blerjeve DESC;
    

-- Sa është shuma totale e të ardhurave nga klientët në çdo qytet?
--me update insert do te shtojme kolonen city (pastaj)
    
    alter table bleres add city varchar(10);

  UPDATE bleres
SET city = CASE 
    WHEN id BETWEEN 1 AND 9 THEN 'Tirane'
    WHEN id = 10 THEN 'Velipoje'
    WHEN id = 11 THEN 'Tirane'
    WHEN id = 12 THEN 'Durres'
    WHEN id = 13 THEN 'Korce'
    WHEN id = 14 THEN 'Fier'
    WHEN id = 15 THEN 'Sarande'
    WHEN id = 16 THEN 'Burrel'
    WHEN id BETWEEN 17 AND 19 THEN 'Tirane'
    WHEN id = 20 THEN 'Shkoder'
    WHEN id = 21 THEN 'Tirane'
    WHEN id = 22 THEN 'Tirane'
    WHEN id = 23 THEN 'Tirane'
    WHEN id = 24 THEN 'Tirane'
    WHEN id = 25 THEN 'Tirane'
    WHEN id = 26 THEN 'Tirane'
    WHEN id = 27 THEN 'Tirane'
    WHEN id = 28 THEN 'Tirane'
    WHEN id = 29 THEN 'Tirane'
    WHEN id = 30 THEN 'Velipoje'
    WHEN id = 31 THEN 'Tirane'
    WHEN id = 32 THEN 'Durres'
    WHEN id = 33 THEN 'Korce'
    WHEN id = 34 THEN 'Fier'
    WHEN id = 35 THEN 'Sarande'
    WHEN id = 36 THEN 'Burrel'
    WHEN id BETWEEN 37 AND 39 THEN 'Tirane'
    WHEN id = 40 THEN 'Shkoder'
    WHEN id = 41 THEN 'Peshkopi'
    WHEN id = 42 THEN 'Kamez'
    WHEN id = 43 THEN 'Skrapar'
    WHEN id BETWEEN 44 AND 49 THEN 'Tirane'
    WHEN id = 50 THEN 'Velipoje'
    WHEN id = 51 THEN 'Tirane'
    WHEN id = 52 THEN 'Durres'
    WHEN id = 53 THEN 'Korce'
    WHEN id = 54 THEN 'Fier'
    WHEN id = 55 THEN 'Sarande'
    WHEN id = 56 THEN 'Burrel'
    WHEN id BETWEEN 57 AND 59 THEN 'Tirane'
    WHEN id = 60 THEN 'Vore'
    WHEN id = 61 THEN 'Tirane'
    WHEN id = 62 THEN 'Himare'
    WHEN id = 63 THEN 'Fier'
    WHEN id BETWEEN 64 AND 69 THEN 'Tirane'
    WHEN id = 70 THEN 'Velipoje'
    WHEN id = 71 THEN 'Tirane'
    WHEN id = 72 THEN 'Durres'
    WHEN id = 73 THEN 'Korce'
    WHEN id = 74 THEN 'Fier'
    WHEN id = 75 THEN 'Sarande'
    WHEN id = 76 THEN 'Burrel'
    WHEN id BETWEEN 77 AND 79 THEN 'Tirane'
    WHEN id = 80 THEN 'Kelcyre'
    WHEN id = 81 THEN 'Maliq'
    WHEN id = 82 THEN 'Orikum'
    WHEN id = 83 THEN 'Durres'
    WHEN id = 84 THEN 'Perrenjas'
    WHEN id = 85 THEN 'Vore'
    WHEN id = 86 THEN 'Linohove'
    WHEN id BETWEEN 87 AND 89 THEN 'Tirane'
    WHEN id = 90 THEN 'Velipoje'
    WHEN id = 91 THEN 'Tirane'
    WHEN id = 92 THEN 'Durres'
    WHEN id = 93 THEN 'Korce'
    WHEN id = 94 THEN 'Fier'
    WHEN id = 95 THEN 'Sarande'
    WHEN id = 96 THEN 'Burrel'
    WHEN id BETWEEN 97 AND 99 THEN 'Tirane'
    WHEN id = 100 THEN 'Shkoder'
END;

select *
from bleres

--Sa eshte shuma totale e te ardhurave nga secili klient ne cdo qytwt?

SELECT bleres.city, SUM(Fature.kosto_totale) AS te_ardhurat
FROM bleres
JOIN Fature ON Fature.bleres_id = bleres.id
GROUP BY bleres.city
ORDER BY te_ardhurat DESC;


--Gjej numrin e klienteve ne secilin qytet


select bleres.city,count(distinct bleres.id)
from bleres
group by bleres.city
order by count(distinct bleres.id)

--Nga cili qytet eshte klienti me shpenzimin me te madh

 SELECT TOP 1 bleres.city, bleres.emer, bleres.mbiemer, SUM(Fature.kosto_totale) AS totali
FROM bleres
JOIN Fature ON Fature.bleres_id = bleres.id
GROUP BY bleres.city, bleres.emer, bleres.mbiemer
ORDER BY totali DESC;
    

--Sa është mosha mesatare e klientëve (duke llogaritur bazuar në datëlindje)?
    
    SELECT AVG(YEAR(GETDATE()) - YEAR(datelindja)) AS Mosha_Mesatare
    FROM Bleres;


-- Numri total i klientëve për secilën periudhë kohore (p.sh., vit ose muaj).


    SELECT YEAR(f.data_blerjes) AS Viti, COUNT(DISTINCT f.bleres_id) AS Kliente_Unike
    FROM Fature f
    GROUP BY YEAR(f.data_blerjes)
    ORDER BY Viti;
    


-- Analiza bazuar te dyqanet 

 --Cila është shitja totale e çdo dyqani?  
   SELECT d.name AS Dyqani, SUM(f.kosto_totale) AS Shitja_Totale
   FROM Dyqani d
   JOIN Tregton1 t ON d.id = t.dyqan_id
   JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
   JOIN Fature f ON lp.fature_id = f.id
   GROUP BY d.id, d.name
   ORDER BY Shitja_Totale DESC;


-- Sa është mesatarja e shitjeve për secilin dyqan?

   SELECT d.name AS Dyqani, AVG(f.kosto_totale) AS Mesatarja_Shitjeve
   FROM Dyqani d
   JOIN Tregton1 t ON d.id = t.dyqan_id
   JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
   JOIN Fature f ON lp.fature_id = f.id
   GROUP BY d.id, d.name
   ORDER BY Mesatarja_Shitjeve DESC;



--20. Cili është dyqani me shitjen më të madhe dhe më të vogël?

   -- Shitja më e madhe:
   
     SELECT TOP 1 d.name AS Dyqani, SUM(f.kosto_totale) AS Shitja_Totale
     FROM Dyqani d
     JOIN Tregton1 t ON d.id = t.dyqan_id
     JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
     JOIN Fature f ON lp.fature_id = f.id
     GROUP BY d.id, d.name
     ORDER BY Shitja_Totale DESC;
     

   -- Shitja më e vogël:
   
     SELECT TOP 1 d.name AS Dyqani, SUM(f.kosto_totale) AS Shitja_Totale
     FROM Dyqani d
     JOIN Tregton1 t ON d.id = t.dyqan_id
     JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
     JOIN Fature f ON lp.fature_id = f.id
     GROUP BY d.id, d.name
     ORDER BY Shitja_Totale ASC;
     


--Numri total i produkteve të shitur nga secili dyqan.

   
   SELECT d.name AS Dyqani, SUM(lp.qnt) AS Sasia_Produkteve
   FROM Dyqani d
   JOIN Tregton1 t ON d.id = t.dyqan_id
   JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
   GROUP BY d.id, d.name
   ORDER BY Sasia_Produkteve DESC;
   

-- Numri total i klientëve që kanë blerë nga secili dyqan.

   SELECT d.name AS Dyqani, COUNT(DISTINCT f.bleres_id) AS Kliente
   FROM Dyqani d
   JOIN Tregton1 t ON d.id = t.dyqan_id
   JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
   JOIN Fature f ON lp.fature_id = f.id
   GROUP BY d.id, d.name
   ORDER BY Kliente DESC;


-- Cilat qytete kanë dyqanet me më shumë të ardhura?

  SELECT d.city AS Qyteti, SUM(f.kosto_totale) AS Te_Ardhurat
   FROM Dyqani d
   JOIN Tregton1 t ON d.id = t.dyqan_id
   JOIN Lista_Produkteve lp ON t.produkt_id = lp.produkt_id
   JOIN Fature f ON lp.fature_id = f.id
   GROUP BY d.city
   ORDER BY Te_Ardhurat DESC;





-- Cila është sasia e përgjithshme e produkteve të disponueshme 
--në çdo dyqan?
 
   SELECT d.name AS Dyqani, 
   SUM(t.sasia_e_disponueshme) AS Sasia_Disponueshme
   from Tregton1 as t,Dyqani as d
   where t.dyqan_id=D.id
   group by d.name




















    


       