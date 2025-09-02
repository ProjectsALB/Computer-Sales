--analiza duke perodorur dhe windows function


--Cila është shuma totale e produkteve të shitura (sipas sasisë dhe çmimit) për çdo dyqan dhe cilët produkte kontribuojnë në këto shitje?
SELECT d.name AS Dyqani, p.emri AS Produkti, 
       SUM(lp.qnt * p.cmimi) OVER (PARTITION BY d.name) AS Shuma_Totale
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id;

--Për secilin dyqan dhe secilin produkt, cilat janë shitjet e produktit dhe si krahasohen ato me mesataren e shitjeve të produktit për atë dyqan?
   SELECT d.name AS Dyqani, p.emri AS Produkti, 
          AVG(lp.qnt * p.cmimi) OVER (PARTITION BY d.name) AS Mesatarja_Shitjeve
   FROM Dyqani d
   INNER JOIN Tregton1 t ON d.id = t.dyqan_id
   INNER JOIN Produkt2 p ON t.produkt_id = p.id
   INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id;
 

--Cila është shuma totale e shitjeve për çdo produkt në secilin dyqan dhe si krahasohet kjo shumë me mesataren e shitjeve për të njëjtin dyqan?
 
 SELECT d.name AS Dyqani, 
       p.emri AS Produkti, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjesh,
       AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY d.name) AS Mesatarja_Shitjeve
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name, p.emri;



--Cili është renditja e dyqaneve bazuar në shumën totale të shitjeve?
 
   SELECT d.name AS Dyqani, SUM(lp.qnt * p.cmimi) AS Shuma_Totale,
          RANK() OVER (ORDER BY SUM(lp.qnt * p.cmimi) DESC) AS Ranku
   FROM Dyqani d
   INNER JOIN Tregton1 t ON d.id = t.dyqan_id
   INNER JOIN Produkt2 p ON t.produkt_id = p.id
   INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY d.name;


--Sa është shuma e shitjeve për çdo produkt në çdo dyqan dhe a janë ato mbi apo nën mesataren e shitjeve për secilin dyqan?
 
 SELECT d.name AS Dyqani, 
       p.emri AS Produkti, 
       ROUND(SUM(lp.qnt * p.cmimi), 2) AS Shuma_Shitjeve,
       ROUND(AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY d.name), 2) AS Mesatarja_Shitjeve,
       CASE
           WHEN SUM(lp.qnt * p.cmimi) > ROUND(AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY d.name), 2) THEN 'Mbi Mesataren'
           ELSE 'Nën Mesataren'
       END AS Krahasimi_Mesatares
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name, p.emri;


--Sa është sasia e shitjeve për çdo produkt dhe çfarë ndryshimi ka midis shitjeve të këtij produkti dhe shitjeve të produktit të mëparshëm?

SELECT p.emri AS Produkti, 
       SUM(lp.qnt) AS Sasia_Shitjesh,
       LAG(SUM(lp.qnt), 1) OVER (ORDER BY p.id) AS Sasia_E_Para,
       (SUM(lp.qnt) - LAG(SUM(lp.qnt), 1) OVER (ORDER BY p.id)) AS Ndryshimi
FROM Produkt2 p
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY p.emri, p.id;
 
 
--Sa është numri i produkteve në çdo faturë dhe cila është mesatarja e numrit të produkteve për faturë?
 
   SELECT f.id AS Fatura, 
          COUNT(lp.produkt_id) AS Numri_Produkteve,
          AVG(COUNT(lp.produkt_id)) OVER (PARTITION BY f.id) AS Mesatarja_Produkteve_Per_Fature
   FROM Fature f
   INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
   GROUP BY f.id;
 


--Sa është shpenzimi total i çdo blerësi për çdo kategori produkti dhe cila është mesatarja e shpenzimeve për kategori?
 
 SELECT b.emer, b.mbiemer, p.kategoria AS Kategoria, 
          SUM(lp.qnt * p.cmimi) AS Shpenzimi_Total,
          AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY p.kategoria) AS Mesatarja_Shpere_Kategoria
   FROM Bleres b
   INNER JOIN Fature f ON b.id = f.bleres_id
   INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
   INNER JOIN Produkt2 p ON lp.produkt_id = p.id
   GROUP BY b.emer, b.mbiemer, p.kategoria;


--Cila është shuma e shitjeve për secilin vit dhe si ka ndryshuar ajo në përqindje krahasuar me vitin e kaluar?

   SELECT YEAR(f.data_blerjes) AS Viti, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjeve,
       LAG(SUM(lp.qnt * p.cmimi), 1) OVER (ORDER BY YEAR(f.data_blerjes)) AS Shuma_Viti_Pare,
       ((SUM(lp.qnt * p.cmimi) - LAG(SUM(lp.qnt * p.cmimi), 1) OVER (ORDER BY YEAR(f.data_blerjes))) 
        / LAG(SUM(lp.qnt * p.cmimi), 1) OVER (ORDER BY YEAR(f.data_blerjes))) * 100 AS Rritja_Përqindje
FROM Fature f
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY YEAR(f.data_blerjes);


--Cili ka qenë shpenzimi total për çdo muaj dhe si krahasohet ai me shpenzimin e muajit të kaluar?
 
SELECT MONTH(f.data_blerjes) AS Muaji, 
       SUM(lp.qnt * p.cmimi) AS Shpenzimi_Total,
       LAG(SUM(lp.qnt * p.cmimi), 1) OVER (ORDER BY MONTH(f.data_blerjes)) AS Shpenzimi_Muajin_Parë
FROM Fature f
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY MONTH(f.data_blerjes);

 
--Cili është shpenzimi total për çdo blerës dhe cili është renditja e tyre bazuar në shpenzimin total?
 
   SELECT b.emer, b.mbiemer, SUM(lp.qnt * p.cmimi) AS Shpenzimi_Total,
          RANK() OVER (ORDER BY SUM(lp.qnt * p.cmimi) DESC) AS Ranku
   FROM Bleres b
   INNER JOIN Fature f ON b.id = f.bleres_id
   INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
   INNER JOIN Produkt2 p ON lp.produkt_id = p.id
   GROUP BY b.emer, b.mbiemer;


--Cila është shuma totale e shitjeve për çdo vit dhe si ka ndryshuar kjo shifër krahasuar me vitin e kaluar?

SELECT YEAR(f.data_blerjes) AS Viti, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Totale_Shitjeve,
       LAG(SUM(lp.qnt * p.cmimi), 1) OVER (ORDER BY YEAR(f.data_blerjes)) AS Shuma_Shitjeve_Viti_Pare
FROM Fature f
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY YEAR(f.data_blerjes);


--Cili është shpenzimi total për çdo blerës dhe si krahasohet ky shpenzim me mesataren e shpenzimeve të të gjithë blerësve?
SELECT b.id, b.emer, b.mbiemer, 
       SUM(lp.qnt * p.cmimi) AS Shpenzimi_Total,
       AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY b.id) AS Mesatarja_Shpenzimeve
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY b.id, b.emer, b.mbiemer;




--Sa është shuma e shitjeve për secilin produkt në çdo dyqan dhe cila është përqindja e kontribuimit të çdo produkti në totalin e shitjeve të dyqanit?
SELECT d.name AS Dyqani, 
       p.emri AS Produkti, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjesh,
       SUM(lp.qnt * p.cmimi) OVER (PARTITION BY d.name) AS Shuma_Totale_Dyqan,
       (SUM(lp.qnt * p.cmimi) / SUM(lp.qnt * p.cmimi) OVER (PARTITION BY d.name)) * 100 AS Pjesa_Prodhimit
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name, p.emri,lp.qnt,p.cmimi




--Sa ka ndryshuar shuma e shitjeve të produkteve nga muaji i kaluar në muajin aktual për secilin produkt dhe cila është shuma totale e shitjeve për çdo muaj?
SELECT p.emri AS Produkti, 
       MONTH(f.data_blerjes) AS Muaji, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjeve,
       LAG(SUM(lp.qnt * p.cmimi), 1) OVER (PARTITION BY p.emri ORDER BY MONTH(f.data_blerjes)) AS Shuma_Muaj_Parë,
       (SUM(lp.qnt * p.cmimi) - LAG(SUM(lp.qnt * p.cmimi), 1) OVER (PARTITION BY p.emri ORDER BY MONTH(f.data_blerjes))) AS Ndryshimi
FROM Fature f
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY p.emri, MONTH(f.data_blerjes);


--Cila është sasia e shitjeve për secilin produkt në dyqan dhe cilët produkte janë renditur sipas sasive më të larta të shitjeve në çdo dyqan?
 
SELECT d.name AS Dyqani, p.emri AS Produkti, 
       SUM(lp.qnt) AS Sasia_Shitjesh,
       RANK() OVER (PARTITION BY d.name ORDER BY SUM(lp.qnt) DESC) AS Ranku
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name, p.emri;
 

--Cila është shuma e shitjeve për secilën kategori produkti për çdo vit dhe cili është trendi i shitjeve për çdo kategori gjatë viteve?
 SELECT p.kategoria AS Kategoria, 
       YEAR(f.data_blerjes) AS Viti,
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjesh,
       SUM(lp.qnt * p.cmimi) OVER (PARTITION BY p.kategoria ORDER BY YEAR(f.data_blerjes)) AS Trendi_Shitjesh
FROM Produkt2 p
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
INNER JOIN Fature f ON lp.fature_id = f.id
GROUP BY p.kategoria, YEAR(f.data_blerjes),lp.qnt,p.cmimi;


--Cilat janë shpenzimet totale të klientëve për çdo muaj dhe si krahasohen ato me mesataren e shpenzimeve 
--për të përcaktuar nëse klienti ka shpenzuar më shumë apo më pak se mesatarja e muajit?
 
SELECT b.emer AS Klienti, 
       MONTH(f.data_blerjes) AS Muaji, 
       SUM(lp.qnt * p.cmimi) AS Shpenzimi,
       AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY MONTH(f.data_blerjes)) AS Mesatarja_Shpimeve,
       CASE
           WHEN SUM(lp.qnt * p.cmimi) > AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY MONTH(f.data_blerjes)) THEN 'Mbi Mesataren'
           ELSE 'Poshtë Mesatares'
       END AS Statusi
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY b.emer, MONTH(f.data_blerjes);


 
--Cilat janë shpenzimet totale për secilin produkt gjatë viteve të ndryshme dhe si ka evoluar trenda i shitjeve për secilin produkt nga viti në vit?

 
SELECT p.emri AS Produkti, 
       YEAR(f.data_blerjes) AS Viti, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjesh,
       SUM(lp.qnt * p.cmimi) OVER (PARTITION BY p.emri ORDER BY YEAR(f.data_blerjes)) AS Trendi_Rritjes
FROM Produkt2 p
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
INNER JOIN Fature f ON lp.fature_id = f.id
GROUP BY p.emri, YEAR(f.data_blerjes),lp.qnt,p.cmimi;



--Sa klientë ka në çdo qytet dhe cilat janë mesatarët e shpenzimeve për çdo qytet, duke përfshirë numrin e klientëve dhe shpenzimet totale?
SELECT b.city, 
       COUNT(DISTINCT b.id) AS Numri_Klientëve,
       AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY b.city) AS Mesatarja_Blerjeve
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY b.city;



--Cili është produkti me të ardhurat më të larta në çdo dyqan?

SELECT Dyqani, Produkti, Te_Ardhurat, Ranku
FROM (
    SELECT d.name AS Dyqani, 
           p.emri AS Produkti, 
           SUM(lp.qnt * p.cmimi) AS Te_Ardhurat,
           RANK() OVER (PARTITION BY d.name ORDER BY SUM(lp.qnt * p.cmimi) DESC) AS Ranku
    FROM Dyqani d
    INNER JOIN Tregton1 t ON d.id = t.dyqan_id
    INNER JOIN Produkt2 p ON t.produkt_id = p.id
    INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
    GROUP BY d.name, p.emri
) AS RankedData
WHERE Ranku = 1;



--Sa transaksione ka kryer çdo klient dhe si krahasohet numri i transaksioneve me mesataren për të gjithë klientët?

SELECT b.emer AS Klienti, 
       COUNT(f.id) AS Numri_Transaksioneve,
       AVG(COUNT(f.id)) OVER () AS Mesatarja_Transaksioneve
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
GROUP BY b.emer;



--Sa është shuma e shitjeve për çdo dyqan dhe kategori, dhe si krahasohet ajo me mesataren e shitjeve për secilën kategori në dyqan?
SELECT d.name AS Dyqani, 
       p.kategoria AS Kategoria, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjeve,
       AVG(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY d.name, p.kategoria) AS Mesatarja_Shitjeve
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name, p.kategoria;

--Sa janë të ardhurat nga shitjet për çdo produkt dhe kategori, dhe sa përqind e shitjeve ka secili produkt në kategorinë e tij?
SELECT p.emri AS Produkti, 
       p.kategoria AS Kategoria, 
       SUM(lp.qnt * p.cmimi) AS Te_Ardhurat_Produktit,
       SUM(lp.qnt * p.cmimi) * 100.0 / SUM(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY p.kategoria) AS Pjesa_Percent
FROM Produkt2 p
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY p.kategoria, p.emri;


-- Shuma e përgjithshme e shitjeve për çdo dyqan krahasuar me mesataren kombëtare.

SELECT d.name AS Dyqani, 
       SUM(lp.qnt * p.cmimi) AS Shuma_Shitjeve,
       AVG(SUM(lp.qnt * p.cmimi)) OVER () AS Mesatarja_Kombetare
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY d.name;


-- Mesatarja e shitjeve mujore për secilin produkt në një dyqan specifik.
SELECT d.name AS Dyqani, 
       p.emri AS Produkti, 
       MONTH(f.data_blerjes) AS Muaji, 
       AVG(lp.qnt * p.cmimi) AS Mesatarja_Mujore
FROM Dyqani d
INNER JOIN Tregton1 t ON d.id = t.dyqan_id
INNER JOIN Produkt2 p ON t.produkt_id = p.id
INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
INNER JOIN Fature f ON lp.fature_id = f.id
GROUP BY d.name, p.emri, MONTH(f.data_blerjes);


-- Cili qytet kontribuon më shumë në të ardhurat e përgjithshme për secilin produkt?
SELECT b.city AS Qyteti, 
       p.emri AS Produkti, 
       SUM(lp.qnt * p.cmimi) AS Te_Ardhurat,
       RANK() OVER (PARTITION BY p.emri ORDER BY SUM(lp.qnt * p.cmimi) DESC) AS Ranku
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY b.city, p.emri;

--Cila është rritja e të ardhurave mujore për secilin qytet?
SELECT b.city AS Qyteti, 
       MONTH(f.data_blerjes) AS Muaji, 
       SUM(lp.qnt * p.cmimi) AS Te_Ardhurat,
       SUM(SUM(lp.qnt * p.cmimi)) OVER (PARTITION BY b.city ORDER BY MONTH(f.data_blerjes)) AS Rritja
FROM Bleres b
INNER JOIN Fature f ON b.id = f.bleres_id
INNER JOIN Lista_Produkteve lp ON f.id = lp.fature_id
INNER JOIN Produkt2 p ON lp.produkt_id = p.id
GROUP BY b.city, MONTH(f.data_blerjes);