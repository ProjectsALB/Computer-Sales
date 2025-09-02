-- analizo Shitjet Totale për çdo Produkt në një Periudhë Kohore


SELECT 
    p.emri AS Produkti,
    SUM(lp.qnt) AS Sasia_Shitur,
    SUM(lp.qnt * p.cmimi) AS TeArdhuratTotale
FROM 
    Lista_Produkteve lp
JOIN 
    Produkt2 p ON lp.produkt_id = p.id
join Fature f on f.id=lp.fature_id
WHERE 
    f.data_blerjes BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    p.emri
ORDER BY 
    TeArdhuratTotale DESC;


--Klientët qe kane bere blerje te mdha ne vitin 2024


SELECT top 10
    b.emer AS Emri_Klienti,
    b.mbiemer AS Mbiemri_Klienti,
    SUM(f.kosto_totale) AS ShpenzimetTotale
FROM 
    Bleres b
JOIN 
    Fature f ON b.id = f.bleres_id
WHERE 
    f.data_blerjes BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    b.emer, b.mbiemer
ORDER BY 
    ShpenzimetTotale DESC;


--analizo performancen e shitjeve ne cdo dyqan


SELECT 
    d.name AS Dyqani,
    SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve,
    COUNT(DISTINCT f.id) AS Numri_Faturave,
    MAX(f.data_blerjes) AS Data_e_Fundit
FROM 
    Dyqani d
JOIN 
    Tregton1 t ON d.id = t.dyqan_id
JOIN 
    Produkt2 p ON t.produkt_id = p.id
JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN 
    Fature f ON lp.fature_id = f.id
GROUP BY 
    d.id,d.name,lp.qnt,p.cmimi,f.data_blerjes
ORDER BY 
    Totali_Shitjeve DESC;


--analizo trendet mujore te te ardhurave

SELECT 
    CONVERT(VARCHAR(7), f.data_blerjes, 120) AS Muaji,
    SUM(lp.qnt * p.cmimi) AS Totali_Ardhurave
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.id = lp.fature_id
JOIN 
    Produkt2 p ON lp.produkt_id = p.id
GROUP BY 
    CONVERT(VARCHAR(7), f.data_blerjes, 120)
ORDER BY 
    Muaji ASC;


--analiza demografike e klienteve sipas moshes


SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) < 18 THEN 'Nën 18'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 18 AND 35 THEN '18-35'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 36 AND 60 THEN '36-60'
        ELSE 'Mbi 60'
    END AS Grupi_Moshës,
    COUNT(*) AS Numri_Klientëve,
    SUM(f.kosto_totale) AS Totali_Shitjeve
FROM 
    Bleres b
JOIN 
    Fature f ON b.id = f.bleres_id
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) < 18 THEN 'Nën 18'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 18 AND 35 THEN '18-35'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 36 AND 60 THEN '36-60'
        ELSE 'Mbi 60'
    END
ORDER BY 
    Numri_Klientëve DESC;


--Produktet më të Shitura 


SELECT top 10
    p.emri AS Produkti,
    SUM(lp.qnt) AS Sasia_Shitjeve,
    SUM(lp.qnt * p.cmimi) AS Totali_Ardhurave
FROM 
    Produkt2 p
JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY 
    p.id,p.emri,lp.qnt,p.cmimi
ORDER BY 
    Sasia_Shitjeve DESC
 

--analizo shitjet sipas qytetetve

SELECT 
    d.city AS Qyteti,
    SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve,
    COUNT(DISTINCT f.id) AS Numri_Faturave
FROM 
    Dyqani d
JOIN 
    Tregton1 t ON d.id = t.dyqan_id
JOIN 
    Produkt2 p ON t.produkt_id = p.id
JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN 
    Fature f ON lp.fature_id = f.id
GROUP BY 
    d.city
ORDER BY 
    Totali_Shitjeve DESC;



--Shpenzimet Mesatare për Çdo Klient


SELECT 
    CONCAT(b.emer, ' ', b.mbiemer) AS Klienti,
    AVG(f.kosto_totale) AS Shpenzimet_Mesatare,
    SUM(f.kosto_totale) AS Totali_Shitjeve,
    COUNT(f.id) AS Numri_Faturave
FROM 
    Bleres b
JOIN 
    Fature f ON b.id = f.bleres_id
GROUP BY 
    b.id,b.emer,b.mbiemer,f.kosto_totale,f.ID
ORDER BY 
    Totali_Shitjeve DESC;



--analizo Produktet që Nuk Shiten Shpesh

 SELECT 
    p.emri AS Produkti,
    COALESCE(SUM(lp.qnt), 0) AS Sasia_Shitjeve
FROM 
    Produkt2 p
LEFT JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY 
    p.id,p.emri,lp.qnt
HAVING 
    COALESCE(SUM(lp.qnt), 0)  = 0
    OR  COALESCE(SUM(lp.qnt), 0)  < 10
ORDER BY 
    Sasia_Shitjeve ASC;



--analizo shitjet sipas diteve te javes


SELECT 
   day(f.data_blerjes) AS Dita_Javës,
    COUNT(f.id) AS Numri_Faturave,
    SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve
FROM  Fature f
JOIN Lista_Produkteve lp ON f.id = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY day(f.data_blerjes) 
ORDER BY day(f.data_blerjes) ASC



--analizo  Disponueshmërinë e Produkteve në Çdo Dyqan


SELECT d.name AS Dyqani,p.emri AS Produkti,t.sasia_e_disponueshme AS Disponueshmëria
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id
JOIN Produkt2 p ON t.produkt_id = p.id
ORDER BY  d.name, Disponueshmëria ASC;


 --analizo Shitjet Maksimale dhe Minimale për Çdo Dyqan


 SELECT 
    d.name AS Dyqani,
    MAX(lp.qnt * p.cmimi) AS Shitja_Maksimale,
    MAX(lp.qnt * p.cmimi) AS Shitja_Minimale
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id
JOIN Produkt2 p ON t.produkt_id = p.id
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN  Fature f ON lp.fature_id = f.id
GROUP BY  d.id,d.name,lp.qnt,p.cmimi
ORDER BY  Shitja_Maksimale DESC;



--analizo klientet qe bejne me shume blerje

SELECT 
    CONCAT(b.emer, ' ', b.mbiemer) AS Klienti,
    COUNT(f.id) AS Numri_Faturave,
    SUM(f.kosto_totale) AS Totali_Shitjeve
FROM Bleres b
JOIN Fature f ON b.id = f.bleres_id
GROUP BY b.id,b.emer,b.mbiemer
HAVING SUM(f.kosto_totale)  <5000
ORDER BY Totali_Shitjeve DESC;


--analizo produkete qe shiten me shume ne cdo qytet

SELECT d.city AS Qyteti,p.emri AS Produkti,SUM(lp.qnt) AS Sasia_Shitjeve
FROM  Dyqani d
JOIN  Tregton1 t ON d.id = t.dyqan_id
JOIN  Produkt2 p ON t.produkt_id = p.id
JOIN  Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY  d.city, p.id,d.city,p.emri
ORDER BY d.city, Sasia_Shitjeve DESC;



--analizo Klientët që Kanë Blerë Më Shumë Produkte të Njëjta

SELECT CONCAT(b.emer, ' ', b.mbiemer) AS Klienti,p.emri AS Produkti,SUM(lp.qnt) AS Sasia_e_Blerë
FROM Bleres b
JOIN  Fature f ON b.id = f.bleres_id
JOIN  Lista_Produkteve lp ON f.id = lp.fature_id
JOIN  Produkt2 p ON lp.produkt_id = p.id
GROUP BY  b.id, p.id,b.emer,b.mbiemer,lp.qnt,p.emri
HAVING sUM(lp.qnt) > 10
ORDER BY Sasia_e_Blerë DESC;


--vlereso produktet që Kanë Gjeneruar më Shumë të Ardhura


SELECT  top 10 p.emri AS Produkti,SUM(lp.qnt * p.cmimi) AS Totali_Ardhurave
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY p.id,p.emri,lp.qnt,p.cmimi
ORDER BY  Totali_Ardhurave DESC
 


--nxirr Shitjet Maksimale të Çdo Klienti


SELECT CONCAT(b.emer, ' ', b.mbiemer) AS Klienti, MAX(f.kosto_totale) AS Shitja_Maksimale,SUM(f.kosto_totale) AS Totali_Shitjeve,
    COUNT(f.id) AS Numri_Faturave
FROM Bleres b
JOIN Fature f ON b.id = f.bleres_id
GROUP BY b.id,b.emer,b.mbiemer,f.kosto_totale,f.id
ORDER BY Shitja_Maksimale DESC;



--Numri i Produkteve të Disponueshme në Çdo Dyqan


SELECT  d.name AS Dyqani,COUNT(DISTINCT t.produkt_id) AS Numri_Produkteve,SUM(t.sasia_e_disponueshme) AS Totali_Produkteve
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id
GROUP BY d.id,d.name,t.produkt_id,t.sasia_e_disponueshme
ORDER BY Totali_Produkteve DESC;


--analizo Numrin e Produkteve të Disponueshme në Çdo Dyqan

SELECT  d.name AS Dyqani,COUNT(DISTINCT t.produkt_id) AS Numri_Produkteve,SUM(t.sasia_e_disponueshme) AS Totali_Produkteve
FROM  Dyqani d
JOIN  Tregton1 t ON d.id = t.dyqan_id
GROUP BY  d.id,d.name,t.produkt_id,t.sasia_e_disponueshme
ORDER BY  Totali_Produkteve DESC;



--bej nje  Raport mbi Shitjet dhe Disponueshmërinë


SELECT  p.emri AS Produkti, SUM(lp.qnt) AS Sasia_e_Shitjeve, SUM(t.sasia_e_disponueshme) AS Sasia_e_Mbetur
FROM  Produkt2 p
LEFT JOIN  Tregton1 t ON p.id = t.produkt_id
LEFT JOIN  Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY  p.id,p.emri,lp.qnt,t.sasia_e_disponueshme
ORDER BY Sasia_e_Shitjeve DESC;


--krijo nje Raport për Shitjet mujore të Çdo Produkti


SELECT p.emri AS Produkti,CONVERT(VARCHAR(7), f.data_blerjes, 120) AS Muaji,SUM(lp.qnt) AS Sasia_e_Shitjeve, SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve
FROM  Produkt2 p
JOIN  Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN  Fature f ON lp.fature_id = f.id
GROUP BY  p.id, CONVERT(VARCHAR(7), f.data_blerjes, 120), p.emri
ORDER BY  Produkti, Muaji;


--nxirr Klientët që Kanë Blerë më Shumë Brenda një Muaji


SELECT CONCAT(b.emer, ' ', b.mbiemer) AS Klienti,CONVERT(VARCHAR(7), f.data_blerjes, 120) AS Muaji,COUNT(f.id) AS Numri_Faturave,
    SUM(f.kosto_totale) AS Totali_Shitjeve
FROM Bleres b
JOIN  Fature f ON b.id = f.bleres_id
GROUP BY  b.id, CONVERT(VARCHAR(7), f.data_blerjes, 120), b.emer, b.mbiemer
ORDER BY  Totali_Shitjeve DESC;

--analizo Shitjet sipas Numrit të Produkteve në një Faturë


SELECT f.id AS Fatura,COUNT(lp.produkt_id) AS Numri_Produkteve, SUM(lp.qnt * p.cmimi) AS Totali_Fatures
FROM  Fature f
JOIN  Lista_Produkteve lp ON f.id = lp.fature_id
JOIN  Produkt2 p ON lp.produkt_id = p.id
GROUP BY  f.id
ORDER BY  Numri_Produkteve DESC, Totali_Fatures DESC;



-- Identifiko produktet me Rritje në Shitje Mujore

WITH MonthlySales AS (
    SELECT  p.id AS Produkti_ID, p.emri AS Produkti, CONVERT(VARCHAR(7), f.data_blerjes, 120) AS Muaji,
        SUM(lp.qnt) AS Sasia_e_Shitjeve, SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve
    FROM  Produkt2 p
    JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
    JOIN Fature f ON lp.fature_id = f.id
    GROUP BY p.id, p.emri, CONVERT(VARCHAR(7), f.data_blerjes, 120)
)
SELECT  Produkti,Muaji, Sasia_e_Shitjeve, Totali_Shitjeve,
    LAG(Sasia_e_Shitjeve) OVER (PARTITION BY Produkti_ID ORDER BY Muaji) AS Sasia_Muajit_Parë,
    Sasia_e_Shitjeve - LAG(Sasia_e_Shitjeve) OVER (PARTITION BY Produkti_ID ORDER BY Muaji) AS Rritja
FROM MonthlySales
ORDER BY Produkti, Muaji ASC;

