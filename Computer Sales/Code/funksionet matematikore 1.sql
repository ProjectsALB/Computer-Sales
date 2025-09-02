--1-Gjej Emrin e Plotë të të Gjithë Blerësve në Tabelën bleres

SELECT 
    CONCAT(emer, ' ', mbiemer) AS emri_i_plote
FROM bleres;


--2-Shfaq Listën e Blerësve me ID, Emër, Mbiemër dhe Vitin e Lindjes
SELECT 
    ID,
    emer,
    mbiemer,
    YEAR(datelindja) AS viti_lindjes
FROM bleres;



--3-Kombino Fushat kodi dhe emri për Çdo Produkt në një Përshkrim të Plotë

SELECT 
    CONCAT(kodi, ' - ', emri) AS pershkrimi_produkti
FROM Produkt2;


--4-Pastroni Fushën email në Tabelën bleres Duke Hequr Hapësirat e Zbrazëta

SELECT 
    ID,
    TRIM(email) AS email_i_pastruar
FROM bleres;

 --5-Gjej Produktet e Përfshira në Fatura me Emër, Sasi dhe Kombinim të Kodit dhe Emrit të Produktit

 SELECT 
    LP.fature_id AS ID_fature,
    P.emri AS Emri_Produkti,
    LP.qnt AS Sasia,
    CONCAT(P.kodi, '-', P.emri) AS Kodi_Emri_Produkti
FROM 
    Lista_Produkteve LP
INNER JOIN 
    Produkt2 P ON LP.produkt_id = P.id;



--6-Shfaq Listën e Faturave me Emrin e Plotë të Blerësit dhe Datën e Blerjes
 
    SELECT 
    F.ID AS ID_Fature,
    CONCAT(B.emer, ' ', B.mbiemer) AS Bleres,
    CONVERT(VARCHAR, F.data_blerjes, 105) AS Data_Blerjes, 
    F.kosto_totale AS Totali
FROM 
    Fature F
INNER JOIN 
    bleres B ON F.bleres_id = B.ID;



--7-Gjej Dyqanet që Tregtojnë Produkte me Emër Dyqani, Qytet, Emër Produkti dhe Sasi Disponueshme

SELECT 
    D.name AS Emri_Dyqanit,
    D.city AS Qyteti,
    P.emri AS Produkti,
    T.sasia_e_disponueshme AS Sasia_Disponueshme,
    CONCAT('Dyqani ', D.name, ' në ', D.city) AS Informacion_Dyqani
FROM 
    Tregton1 T
INNER JOIN 
    Produkt2 P ON T.produkt_id = P.id
INNER JOIN 
    Dyqani D ON T.dyqan_id = D.id;



--8-Shfaq Faturat Duke Përfshirë Emrin e Blerësit, Produktet e Blera dhe Sasitë e Tyre

SELECT 
    F.ID AS ID_Fature,
    CONCAT(B.emer, ' ', B.mbiemer) AS Bleres
   from Fature F inner join bleres B on F.bleres_id=B.ID



--9-Gjej emrin e plotë të të gjithë blerësve duke bashkuar emrin dhe mbiemrin

SELECT 
    CONCAT(emer, ' ', mbiemer) AS emri_i_plote
FROM bleres;



--10-Shfaq listën e blerësve duke përfshirë ID-në, emrin, mbiemrin dhe vitin e lindjes

SELECT 
    ID,
    emer,
    mbiemer,
    YEAR(datelindja) AS viti_lindjes
FROM bleres;


-- 11-Kombino të dhënat nga fushat kodi dhe emri për çdo produkt në një përshkrim të plotë të produktit
SELECT 
    CONCAT(kodi, ' - ', emri) AS pershkrimi_produkti
FROM Produkt2;


--12-Pastroni të dhënat në fushën email duke hequr hapësirat e zbrazëta
SELECT 
    ID,
    TRIM(email) AS email_i_pastruar
FROM bleres;

 
 --13-Llogarit çmimin pas zbritjes 10%
 SELECT 
    cmimi AS cmimi_i_pakesuar,
    ROUND(cmimi * 0.10, 2) AS vlera_zbritjes,
    ROUND(cmimi - (cmimi * 0.10), 2) AS cmimi_final
FROM Produkt2;


 --13-Vlerësoni ndikimin e zbritjeve në shitje dhe fitim

 SELECT 
    p.id AS produkt_id,
    p.cmimi AS cmimi_i_shitjes,
    ROUND(p.cmimi * 0.10, 2) AS zbritje,
    ROUND(p.cmimi - (p.cmimi * 0.10), 2) AS cmimi_final_me_zbritje,
    lp.qnt AS sasia_shitur,
    ROUND(lp.qnt * (p.cmimi - (p.cmimi * 0.10)), 2) AS vlera_shitjes_me_zbritje,
    ROUND(lp.qnt * (p.cmimi - p.cmimi), 2) AS fitimi_total
FROM Lista_Produkteve lp
JOIN Produkt2 p ON lp.produkt_id = p.id;


 -- 14-Shihni shitjet për çdo ditë për të analizuar kërkesën ditore

 SELECT 
    f.data_blerjes AS data,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY f.data_blerjes
ORDER BY f.data_blerjes;



--15-Analizoni shitjet për secilin çerekvjetor të vitit
SELECT 
    CASE 
        WHEN MONTH(f.data_blerjes) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(f.data_blerjes) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(f.data_blerjes) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(f.data_blerjes) BETWEEN 10 AND 12 THEN 4
    END AS çerekvjetori,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
WHERE YEAR(f.data_blerjes) = 2024
GROUP BY 
    CASE 
        WHEN MONTH(f.data_blerjes) BETWEEN 1 AND 3 THEN 1
        WHEN MONTH(f.data_blerjes) BETWEEN 4 AND 6 THEN 2
        WHEN MONTH(f.data_blerjes) BETWEEN 7 AND 9 THEN 3
        WHEN MONTH(f.data_blerjes) BETWEEN 10 AND 12 THEN 4
    END;




--16-Analizoni shitjet për çdo javë të vitit

SELECT 
    DATEPART(WEEK, f.data_blerjes) AS jave,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
WHERE YEAR(f.data_blerjes) = 2024
GROUP BY DATEPART(WEEK, f.data_blerjes);




--17-Ndajmë shitjet për ditët e fundjavës dhe ditët e tjera të javës

SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, f.data_blerjes) IN (1, 7) THEN 'Fundjave'
        ELSE 'Jave'
    END AS dite_e_javes,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY 
    CASE 
        WHEN DATEPART(WEEKDAY, f.data_blerjes) IN (1, 7) THEN 'Fundjave'
        ELSE 'Jave'
    END;





--18-Shihni shitjet totale për vitet e ndryshme për të krahasuar performancën

SELECT 
    YEAR(f.data_blerjes) AS viti,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY YEAR(f.data_blerjes) ;



--19- Analizoni shitjet për muajt pas një datë 2024-03-01


SELECT 
    MONTH(f.data_blerjes) AS muaji,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
WHERE f.data_blerjes > '2024-03-01'
GROUP BY MONTH(f.data_blerjes);




--20-Shihni diferencën në shitje mes fundjavës dhe ditëve të javës

SELECT 
    CASE 
        WHEN DATEPART(WEEKDAY, f.data_blerjes) IN (1, 7) THEN 'Fundjave'
        ELSE 'Jave'
    END AS dite_e_javes,
    COUNT(f.ID) AS numri_i_faturave,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY 
    CASE 
        WHEN DATEPART(WEEKDAY, f.data_blerjes) IN (1, 7) THEN 'Fundjave'
        ELSE 'Jave'
    END;


--21-Gjej të gjitha produktet e përfshira në fatura

SELECT 
    LP.fature_id AS ID_fature,
    P.emri AS Emri_Produkti,
    LP.qnt AS Sasia,
    CONCAT(P.kodi, '-', P.emri) AS Kodi_Emri_Produkti
FROM 
    Lista_Produkteve LP
INNER JOIN 
    Produkt2 P ON LP.produkt_id = P.id;

