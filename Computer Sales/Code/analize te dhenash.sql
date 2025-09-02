 --Cilat janë produktet që kanë pasur performancën më të mirë në shitje, duke u bazuar në sasinë totale të shitur dhe shitjet totale? 

 SELECT 
    p.emri AS produkt,
    SUM(lp.qnt) AS sasia_total,  
    SUM(lp.qnt * p.cmimi) AS shitje_totale,  
    COUNT(DISTINCT f.ID) AS numri_faturave,   
    AVG(lp.qnt) AS sasia_mesatare_fature   
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
JOIN Fature f ON f.ID = lp.fature_id
GROUP BY p.emri
ORDER BY shitje_totale DESC;  


 --Cilat janë klientët që kanë kontribuar më shumë në shitjet totale, bazuar në vlerën e produkteve të blera dhe numrin e faturave,
 -- dhe si mund të përdoren këto të dhëna për të krijuar strategji marketingu më të personalizuara për ata klientë?
 
 SELECT top 10 b.emer,b.mbiemer, COUNT(DISTINCT f.ID) AS numri_faturave, SUM(lp.qnt * p.cmimi) AS shitje_totale   
FROM bleres b
JOIN Fature f ON f.bleres_id = b.ID  
JOIN Lista_Produkteve lp ON lp.fature_id = f.ID  
JOIN Produkt2 p ON lp.produkt_id = p.id   
GROUP BY b.emer,b.mbiemer,f.ID
ORDER BY shitje_totale DESC   
 
 
 --Cilat janë trendet e shitjeve gjatë muajve dhe viteve të kaluara, dhe si mund të përdoren këto të dhëna për të identifikuar sezonët 
 --kulmorë dhe për të parashikuar kërkesën për periudha të ardhshme?

SELECT  YEAR(f.data_blerjes) AS viti,  
    MONTH(f.data_blerjes) AS muaji,   
    SUM(lp.qnt * p.cmimi) AS shitje_totale   
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id   
JOIN Produkt2 p ON p.id = lp.produkt_id   
GROUP BY YEAR(f.data_blerjes), MONTH(f.data_blerjes)   
ORDER BY viti, muaji;   



--Si mund të analizojmë performancën e dyqaneve të ndryshme dhe të identifikojmë ato që kanë shitur më shumë produkte, për të mundësuar menaxhimin më të mirë të shitjeve për secilin dyqan?

SELECT 
    d.name AS dyqan,   
    p.emri AS produkt,   
    SUM(lp.qnt * p.cmimi) AS shitje_totale  
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id  
JOIN Produkt2 p ON p.id = t.produkt_id  
JOIN Lista_Produkteve lp ON lp.produkt_id = p.id   
JOIN Fature f ON f.ID = lp.fature_id   
GROUP BY d.id, p.id,d.name,p.emri
ORDER BY shitje_totale DESC;   


 --Si mund të identifikojmë produktet që sjellin fitimin më të madh për çdo dyqan dhe si mund të menaxhojmë më mirë asortimentin e produkteve bazuar në këtë informacion?


 SELECT  d.name AS dyqan, p.emri AS produkt,  SUM(lp.qnt * p.cmimi) AS fitim_total  
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id   
JOIN Produkt2 p ON p.id = t.produkt_id   
JOIN Lista_Produkteve lp ON lp.produkt_id = p.id  
JOIN Fature f ON f.ID = lp.fature_id  
GROUP BY d.id, p.id ,d.name,p.emri 
ORDER BY fitim_total DESC;   

 
--Si ndikojnë ndryshimet në çmimin e produkteve në vëllimin e shitjeve dhe cilat kategori produktesh janë më të ndjeshme ndaj ndryshimeve të çmimeve?


SELECT 
    p.emri AS produkt,  
    AVG(p.cmimi) AS cmimi_mesatar,  
    SUM(lp.qnt) AS sasia_total, 
    SUM(lp.qnt * p.cmimi) AS shitje_totale  
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id  
JOIN Fature f ON f.ID = lp.fature_id  
GROUP BY p.id,p.emri,p.cmimi,lp.qnt  
ORDER BY shitje_totale DESC;   




--Cilët janë produktet që kanë një shitje të ulët dhe kërkojnë menaxhim më të mirë të stokut për të parandaluar humbjen e mundshme të stokut?

SELECT 
    p.emri AS produkt,   
    SUM(lp.qnt) AS sasia_total_shitur,   
    SUM(lp.qnt * p.cmimi) AS shitje_totale  
FROM Produkt2 p
JOIN Lista_Produkteve lp ON p.id = lp.produkt_id   
JOIN Fature f ON f.ID = lp.fature_id  
GROUP BY p.id,p.emri,lp.qnt  
HAVING SUM(lp.qnt) < 50   
ORDER BY sasia_total_shitur;   




--Si mund të parashikohet kërkesa për produkte të caktuara në periudhat e ardhshme dhe cilat janë produktet që pritet të kenë rritje të kërkesës në muajt e ardhshëm?


SELECT 
    MONTH(f.data_blerjes) AS muaji,
    p.emri AS produkt, 
    SUM(lp.qnt) AS sasia_total_shitur, 
    SUM(lp.qnt * p.cmimi) AS shitje_totale 
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id  
JOIN Produkt2 p ON p.id = lp.produkt_id  
GROUP BY p.id, MONTH(f.data_blerjes) ,p.emri
ORDER BY muaji, shitje_totale DESC;  





--Si mund të identifikohen sezonet më të suksesshme për shitjet dhe cilat janë produktet që shiten më shumë gjatë periudhave të caktuara të vitit?


SELECT 
    MONTH(f.data_blerjes) AS muaji,
    SUM(lp.qnt) AS sasia_shitur,
    SUM(lp.qnt * p.cmimi) AS shitje_totale
FROM Fature f
JOIN Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN Produkt2 p ON p.id = lp.produkt_id
GROUP BY MONTH(f.data_blerjes)
ORDER BY sasia_shitur DESC;




--Krijoni grupe të klientëve që janë regjistruar në periudha të ndryshme kohore (muaj, tremujor, vit) dhe 
--analizoni se sa klientë mbeten aktivë pas një periudhe të caktuar kohore.

SELECT 
    CONVERT(VARCHAR(7), f.data_blerjes, 120) AS muaji_regjistrimit,  
    COUNT(DISTINCT f.bleres_id) AS numri_klienteve_regjistruar
    
FROM 
    Fature f
GROUP BY 
    CONVERT(VARCHAR(7), f.data_blerjes, 120);  


--Matni numrin e klientëve që mbeten aktivë pas 30 ditësh nga regjistrimi i parë dhe përdorni këtë informacion për të analizuar mbajtjen e klientëve në periudha të ndryshme.

SELECT 
    CONVERT(VARCHAR(7), f.data_blerjes, 120) AS muaji_regjistrimit,  
    COUNT(DISTINCT CASE 
        WHEN f.data_blerjes <= DATEADD(DAY, 30, f.data_blerjes)  
        THEN f.bleres_id END) AS klientet_mbajtur_30_dite
FROM 
    Fature f
GROUP BY 
    CONVERT(VARCHAR(7), f.data_blerjes, 120)   
ORDER BY 
    muaji_regjistrimit;



   --Vlerësoni normën e mbajtjes së klientëve për periudhën 6 mujore dhe identifikoni kohorat më të qëndrueshme.


   SELECT 
    CONVERT(VARCHAR(7), f.data_blerjes, 120) AS muaji_regjistrimit,   
    COUNT(DISTINCT CASE 
        WHEN f.data_blerjes <= DATEADD(MONTH, 6, f.data_blerjes)   
        THEN f.bleres_id END) AS klientet_mbajtur_6_muaj
FROM 
    Fature f
GROUP BY 
    CONVERT(VARCHAR(7), f.data_blerjes, 120)  
ORDER BY 
    muaji_regjistrimit;

--llogarit e vleren mesatare të shitjeve për klient 

SELECT 
    f.bleres_id, 
    SUM(p.cmimi * lp.qnt) AS shuma_total_shitje,   
    COUNT(DISTINCT f.data_blerjes) AS periudhat_aktivitetit,   
    (SUM(p.cmimi * lp.qnt) / COUNT(DISTINCT f.data_blerjes)) * 0.2 AS CLV   
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id  
JOIN 
    Produkt2 p ON lp.produkt_id = p.id   
GROUP BY 
    f.bleres_id;




    --Vlerësoni vlerën totale të shitjeve për çdo grup të klientëve bazuar në periudhën e regjistrimit të tyre.
SELECT 
    CAST(YEAR(f.data_blerjes) AS VARCHAR(4)) + '-' + 
    RIGHT('00' + CAST(MONTH(f.data_blerjes) AS VARCHAR(2)), 2) AS muaji_regjistrimit,   
    SUM(p.cmimi * lp.qnt) AS shuma_total_shitje   
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id   
JOIN 
    Produkt2 p ON lp.produkt_id = p.id 
GROUP BY 
    YEAR(f.data_blerjes), MONTH(f.data_blerjes)  
ORDER BY 
    muaji_regjistrimit;   



--nxirr për çdo muaj të vitit numrin e klientëve që nuk kanë bërë asnjë blerje pas regjistrimit të parë

WITH KlientetRegjistruar AS (
    SELECT 
        f.bleres_id,
        CAST(YEAR(f.data_blerjes) AS VARCHAR(4)) + '-' + 
        RIGHT('00' + CAST(MONTH(f.data_blerjes) AS VARCHAR(2)), 2) AS muaji_regjistrimit,
        f.data_blerjes
    FROM Fature f
),
KlientetBlerje AS (
    SELECT DISTINCT 
        f.bleres_id
    FROM Fature f
    WHERE f.data_blerjes >= DATEADD(MONTH, 1, f.data_blerjes)
)
SELECT 
    kr.muaji_regjistrimit,
    COUNT(DISTINCT kr.bleres_id) AS klientet_pabere
FROM KlientetRegjistruar kr
LEFT JOIN KlientetBlerje kb ON kr.bleres_id = kb.bleres_id
WHERE kb.bleres_id IS NULL  -- Filtron klientët që nuk kanë bërë blerje pas 1 muaji
GROUP BY 
    kr.muaji_regjistrimit
ORDER BY 
    kr.muaji_regjistrimit;




--Kryeni analizën e normave të mbajtjes për periudha sezonale (dimër, pranverë, verë, vjeshtë) dhe analizoni ndryshimet.
SELECT 
    CASE
        WHEN MONTH(f.data_blerjes) IN (12, 1, 2) THEN 'Dimër'
        WHEN MONTH(f.data_blerjes) IN (3, 4, 5) THEN 'Pranverë'
        WHEN MONTH(f.data_blerjes) IN (6, 7, 8) THEN 'Verë'
        WHEN MONTH(f.data_blerjes) IN (9, 10, 11) THEN 'Vjeshtë'
    END AS sezoni,
    COUNT(DISTINCT f.bleres_id) AS klientet_mbajtur_sezon
FROM 
    Fature f
GROUP BY 
    CASE
        WHEN MONTH(f.data_blerjes) IN (12, 1, 2) THEN 'Dimër'
        WHEN MONTH(f.data_blerjes) IN (3, 4, 5) THEN 'Pranverë'
        WHEN MONTH(f.data_blerjes) IN (6, 7, 8) THEN 'Verë'
        WHEN MONTH(f.data_blerjes) IN (9, 10, 11) THEN 'Vjeshtë'
    END;




--Analizoni përqindjen e klientëve që kanë bërë blerje të tjera brenda një periudhe të caktuar (p.sh. 30 ditë pas blerjes së parë).

WITH KlientetKthyer AS (
    SELECT 
        f.bleres_id,
        
        CASE 
            WHEN EXISTS (
                SELECT 1
                FROM Fature f2
                WHERE f2.bleres_id = f.bleres_id
                AND f2.data_blerjes > f.data_blerjes
                AND DATEDIFF(DAY, f.data_blerjes, f2.data_blerjes) <= 30
            ) THEN 1 
            ELSE 0 
        END AS klienti_kthyer
    FROM 
        Fature f
)
SELECT 
    COUNT(DISTINCT CASE WHEN klienti_kthyer = 1 THEN bleres_id END) AS klientet_te_kthyer,
    COUNT(DISTINCT bleres_id) AS total_klientet,
     
    (COUNT(DISTINCT CASE WHEN klienti_kthyer = 1 THEN bleres_id END) * 100.0 / COUNT(DISTINCT bleres_id)) AS perqindja_e_klienteve_te_kthyer
FROM 
    KlientetKthyer;


--Vlerësoni vlerën mesatare të shitjeve për klientët nga qyetet te ndryshme


SELECT 
    c.city,
    AVG(p.cmimi * lp.qnt) AS CLV_mesatar
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN 
    Produkt3 p ON lp.produkt_id = p.id
JOIN 
   bleres c ON f.bleres_id = c.ID
GROUP BY 
    c.city;





 --Matni mesataren e blerjeve për klientët gjatë periudhave të ndryshme kohore për të analizuar qëndrueshmërinë e aktiviteteve të blerjes.


SELECT 
    f.bleres_id,
    COUNT(f.ID) / COUNT(DISTINCT YEAR(f.data_blerjes) * 100 + MONTH(f.data_blerjes)) AS mesatarja_blerjeve_per_klient
FROM 
    Fature f
GROUP BY 
    f.bleres_id;



--Kryej një analizë për të krahasuar shitjet nga klientët që janë të rinj me ato të klientëve që janë aktivizuar më parë.

SELECT 
    CASE 
        WHEN MIN(f.data_blerjes) >= '2024-01-01' THEN 'Klient i ri'
        ELSE 'Klient i vjetër'
    END AS tipi_klientit,
    SUM(p.cmimi * lp.qnt) AS shuma_total_shitje
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN 
    Produkt2 p ON lp.produkt_id = p.id
GROUP BY 
    f.bleres_id;  



 
--Analizoni tendencën e shitjeve në periudha të ndryshme të vitit për të identifikuar se kur janë sezonet më ë nxehta të shitjeve.

SELECT 
    CASE
        WHEN MONTH(f.data_blerjes) IN (12, 1, 2) THEN 'Dimër'
        WHEN MONTH(f.data_blerjes) IN (3, 4, 5) THEN 'Pranverë'
        WHEN MONTH(f.data_blerjes) IN (6, 7, 8) THEN 'Verë'
        WHEN MONTH(f.data_blerjes) IN (9, 10, 11) THEN 'Vjeshtë'
    END AS sezoni,
    SUM(p.cmimi * lp.qnt) AS shuma_total_shitje
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN 
    Produkt2 p ON lp.produkt_id = p.id
GROUP BY 
    CASE
        WHEN MONTH(f.data_blerjes) IN (12, 1, 2) THEN 'Dimër'
        WHEN MONTH(f.data_blerjes) IN (3, 4, 5) THEN 'Pranverë'
        WHEN MONTH(f.data_blerjes) IN (6, 7, 8) THEN 'Verë'
        WHEN MONTH(f.data_blerjes) IN (9, 10, 11) THEN 'Vjeshtë'
    END;



--Kryeni krahasime të shitjeve mes kategorive të ndryshme të produkteve dhe klientëve të rinj dhe të vjetër për të parë se si sjelljet ndryshojnë.

SELECT 
    CASE 
        WHEN f.data_blerjes >= '2024-01-01' THEN 'Klient i ri'
        ELSE 'Klient i vjetër'
    END AS tipi_klientit,
    p.category,
    SUM(p.cmimi * lp.qnt) AS shuma_total_shitje
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN 
     Produkt3 p ON lp.produkt_id = p.id
GROUP BY 
    CASE 
        WHEN f.data_blerjes >= '2024-01-01' THEN 'Klient i ri'
        ELSE 'Klient i vjetër'
    END, 
    p.category;

select *
from Produkt3


 --Analizoni klientët që kanë bërë blerje të mëdha dhe vlerësoni se si mbajtja ndryshon për këto grupe.


SELECT 
    f.bleres_id,
    COUNT(DISTINCT CASE WHEN suma_blerjeve > 500 THEN f.bleres_id END) AS norma_mbajtjes_blerje_te_mdha
FROM 
    Fature f
JOIN 
    Lista_Produkteve lp ON f.ID = lp.fature_id
JOIN 
    Produkt2 p ON lp.produkt_id = p.id
JOIN 
    (
        SELECT 
            f2.bleres_id, 
            SUM(p2.cmimi * lp2.qnt) AS suma_blerjeve
        FROM 
            Fature f2
        JOIN 
            Lista_Produkteve lp2 ON f2.ID = lp2.fature_id
        JOIN 
            Produkt2 p2 ON lp2.produkt_id = p2.id
        GROUP BY 
            f2.bleres_id
    ) AS subquery ON f.bleres_id = subquery.bleres_id
GROUP BY 
    f.bleres_id;








 --Identifikimi i produkteve që shpesh blihen së bashku për të krijuar mundësi për paketat e shitjes.
SELECT 
    p1.id AS produkt_1,   
    p2.id AS produkt_2,  
    COUNT(*) AS ndodhi
FROM Lista_Produkteve lp1
JOIN Lista_Produkteve lp2 ON lp1.fature_id = lp2.fature_id
JOIN Produkt2 p1 ON lp1.produkt_id = p1.id   
JOIN Produkt2 p2 ON lp2.produkt_id = p2.id  
WHERE lp1.produkt_id != lp2.produkt_id
GROUP BY p1.id, p2.id  
ORDER BY ndodhi DESC;



 

 --dentifikimi i klientëve që blenë shumë produkte të njëjtit lloj dhe sugjerimi i ofertave të ngjashme.

SELECT 
        fATURE.bleres_id,
    Lista_Produkteve.produkt_id,
    COUNT(*) AS nr_blerjesh
FROM Lista_Produkteve,Fature
GROUP BY bleres_id, produkt_id
HAVING COUNT(*) > 1
ORDER BY nr_blerjesh DESC;


 
--Identifikimi i klientëve të rinj dhe sugjerimi i produkteve që mund të jenë tërheqëse për ta.

SELECT 
    b.emer, 
    b.mbiemer, 
    COUNT(lp.produkt_id) AS nr_blerjesh,
    f.data_blerjes
FROM Lista_Produkteve lp
JOIN Fature f ON lp.fature_id = f.ID
JOIN bleres b ON f.bleres_id = b.ID
GROUP BY b.emer, b.mbiemer, f.data_blerjes
ORDER BY nr_blerjesh DESC;




--Identifikimi i periudhave të kulmit të shitjeve dhe krijimi i paketave për këto periudha.

SELECT MONTH(data_blerjes) AS muaji, COUNT(*) AS nr_faturash, SUM(kosto_totale) AS total_shitjesh
FROM Fature
GROUP BY MONTH(data_blerjes)
ORDER BY total_shitjesh DESC;


--Identifikimi i klientëve me shpenzime të larta për t’i përfshirë ata në fushata marketingu dhe oferte speciale.

SELECT top 10
    bleres_id, 
    SUM(kosto_totale) AS total_shpenzime
FROM Fature
GROUP BY bleres_id
ORDER BY total_shpenzime DESC
 

--Analizimi i performancës së kategorive të produkteve për të krijuar mundësi të reja shitjeje.
 
 
SELECT 
    p.category, 
    SUM(lp.qnt) AS shite,
    SUM(lp.qnt * p.cmimi) AS vlera_totale
FROM Lista_Produkteve lp
JOIN Produkt3 p ON lp.produkt_id = p.id
GROUP BY p.category
ORDER BY vlera_totale DESC;




--kategorizo produktet dhe llogarit shpenzimin total për secilën kategori:

SELECT 
   CASE 
      WHEN kodi LIKE 'L%' THEN 'Laptop'
      WHEN kodi LIKE 'MO%' THEN 'Monitor'
      WHEN kodi LIKE 'T%' THEN 'Tastiera'
      WHEN kodi LIKE 'HD%' THEN 'Hard Disk'
      WHEN kodi LIKE 'M%' THEN 'Mouse'
      ELSE 'Other'
   END AS Product_Type,
   SUM(cmimi) AS Total_Cost
FROM Produkt2
GROUP BY 
   CASE 
      WHEN kodi LIKE 'L%' THEN 'Laptop'
      WHEN kodi LIKE 'MO%' THEN 'Monitor'
      WHEN kodi LIKE 'T%' THEN 'Tastiera'
      WHEN kodi LIKE 'HD%' THEN 'Hard Disk'
      WHEN kodi LIKE 'M%' THEN 'Mouse'
      ELSE 'Other'
   END;


 --identifikimi i çmimeve optimale për produkte për të rritur shitjet.

SELECT 
    p.cmimi, 
    SUM(lp.qnt) AS shite
FROM Lista_Produkteve lp
JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY p.cmimi
ORDER BY shite DESC;


 
--Të analizohen shitjet ditore për të përcaktuar periudhat me performancën më të mirë.

SELECT 
    CAST(data_blerjes AS DATE) AS data,  
    SUM(kosto_totale) AS shite_totale
FROM Fature
GROUP BY CAST(data_blerjes AS DATE)  
ORDER BY data DESC;



--Identifikimi i produkteve që kanë kërkesën më të lartë për periudha të caktuara.
SELECT TOP 10
    Produkt3.id, 
    Produkt3.emri,
    SUM(Lista_Produkteve.qnt) AS shite_totale
FROM 
    Lista_Produkteve
JOIN 
    Fature ON Lista_Produkteve.fature_id = Fature.ID
JOIN 
    Produkt3 ON Lista_Produkteve.produkt_id = Produkt3.id
WHERE 
    Fature.data_blerjes BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY 
    Produkt3.id, Produkt3.emri
ORDER BY 
    shite_totale DESC;



 
 
 --Përcaktimi i performancës së produkteve të reja dhe mundësive për paketimin e tyre.


SELECT 
    produkt_id,
    COUNT(*) AS nr_blerjesh
FROM Lista_Produkteve,Fature 
where Lista_Produkteve.fature_id=Fature.ID
and data_blerjes > '2024-01-01'
GROUP BY produkt_id
ORDER BY nr_blerjesh DESC;


 
--Klasifikimi i klientëve në grupe moshe për të krijuar oferta specifike për secilin segment.

SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) < 25 THEN '18-24'
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END AS grup_moshe,
    SUM(kosto_totale) AS shpenzime_totale
FROM bleres
JOIN Fature f ON bleres.ID = f.bleres_id
GROUP BY 
    CASE 
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) < 25 THEN '18-24'
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) BETWEEN 25 AND 34 THEN '25-34'
        WHEN DATEDIFF(YEAR, datelindja, GETDATE()) BETWEEN 35 AND 44 THEN '35-44'
        ELSE '45+'
    END
ORDER BY shpenzime_totale DESC;

 

 --Përcaktimi i produkteve që nuk janë shitur për një periudhë të gjatë dhe mund të ofrohen me zbritje.

SELECT 
    produkt_id,
    MAX(datelindja) AS data_e_fundit
FROM Lista_Produkteve,Fature,bleres
where Lista_Produkteve.fature_id=Fature.ID and Fature.bleres_id=bleres.ID
GROUP BY produkt_id
HAVING MAX(datelindja) < DATEADD(MONTH, -6, GETDATE())
ORDER BY data_e_fundit;



--Përcaktimi i shitësve më produktivë për të shpërndarë bonuset dhe mundësitë e shitjes.


SELECT 
    p.emer,
    SUM(kosto_totale) AS shite_totale
FROM Fature
JOIN bleres p ON Fature.bleres_id = p.ID
GROUP BY p.emer
ORDER BY shite_totale DESC;


--Analiza e shitjeve për të parë cilat janë produktet më të njohura nga llojet e ndryshme të produkteve.


SELECT 
    category, 
    SUM(qnt) AS shite_totale
FROM Produkt3
JOIN Lista_Produkteve lp ON Produkt3.id = lp.produkt_id
GROUP BY category
ORDER BY shite_totale DESC;






 


 