  --view

--jep informacion per shtijet totale te cdo produkti

create view analize_shitjesh as
select p.emri,sum(l.qnt) as shitje_totale,sum(l.qnt*p.cmimi)as vlera_TOTALE_e_shitjes
from Lista_Produkteve l
join Produkt2 p on l.produkt_id=p.id
group by p.emri

select *
from analize_shitjesh
 

--jep informacion per shpenzimet totale te secilit bleres per cdo fature qe kane bere

create view analiza_shpenzime_belres as
select b.emer,b.mbiemer,sum(f.kosto_totale) as shuma_totale
from fature f
join bleres b on f.bleres_id=b.id
group by b.emer,b.mbiemer

select *
from analiza_shpenzime_belres

--jep informacion per disponueshmerine e produkteve ne dyqanet e ndryshme dhe mund te ndihmojme 
--ne analizen e stokut dhe menaxhimin e inventarit

create view analiza_disponueshme_e_produkteve as
    select d.name,p.emri,t.sasia_e_disponueshme
    from Dyqani d
    join Tregton1 t on d.id=t.dyqan_id
    join Produkt2 p on t.produkt_id=p.id
   
    select *
    from analiza_disponueshme_e_produkteve
   
   
  --analizo shitjet ne periudha te ndyshme kohore
 
 CREATE VIEW analiza_shitjeve_periodike AS
SELECT p.emri AS Produkti,YEAR(f.data_blerjes) AS Viti,MONTH(f.data_blerjes) AS Muaji,SUM(l.qnt) AS Sasia_Totale,SUM(l.qnt * p.cmimi) AS Shuma_Totale
FROM Fature f
JOIN Lista_Produkteve l ON f.id = l.fature_id
JOIN Produkt2 p ON l.produkt_id = p.id
GROUP BY p.emri, YEAR(f.data_blerjes), MONTH(f.data_blerjes);

    select *
    from analiza_shitjeve_periodike
   
  --trego sasine e produkteve te shitura dhe vleren totale te shitjeve per secilin dyqan
 
 CREATE VIEW analiza_produktivitet_dyqani AS
SELECT d.name AS Emri_Dyqanit,SUM(l.qnt) AS Sasia_Totale,SUM(l.qnt * p.cmimi) AS Shuma_Totale
FROM Dyqani d
JOIN Tregton1 t ON d.id = t.dyqan_id
JOIN Lista_Produkteve l ON t.produkt_id = l.produkt_id
JOIN  Produkt2 p ON l.produkt_id = p.id
GROUP BY  d.name;

   select *
   from analiza_produktivitet_dyqani
   
   

--jep informacion per shpenzimet e bleresve,duke i na=dare sipas grupeve te produkteve

CREATE VIEW Analiza_Shpenzimeve_Bleresve_Per_Kategori1 AS
SELECT b.emer, b.mbiemer, p.category, SUM(l.qnt * p.cmimi) AS shpenzime_totale
FROM Fature f
JOIN Lista_Produkteve l ON f.id = l.fature_id
JOIN Produkt3 p ON l.produkt_id = p.id
JOIN Bleres b ON f.bleres_id = b.id
GROUP BY b.emer, b.mbiemer, p.category



select *
from Analiza_Shpenzimeve_Bleresve_Per_Kategori1

--bej analize mujore te shpenzimeve te bleresve duke pare sjelljen e blerjeve mujore
create view Analiza_Shpenzimeve_Mujore_Bleresve as
select b.emer,b.mbiemer,year(f.data_blerjes),month(f.data_blerjes),sum(f.kosto_totale)
from Fature f
join Bleres b on f.bleres_id=b.id
group by b.emer,b.mbiemer,year(f.data_blerjes),month(f.data_blerjes);

select *
from Analiza_Shpenzimeve_Mujore_Bleresve


--analizo shpenzimet totale te bleresve sipas qytetit te tyre

create view Analiza_Shpenzimeve_Bleresve_Qyteti1 as
select
    b.city as qyteti,sum(f.kosto_totale) as total_shpenzime
    from fature f
    join Bleres b on f.bleres_id=b.id
    group by b.city
   
    select *
   from Analiza_Shpenzimeve_Bleresve_Qyteti1
   
   
   --analizo shitjet e produkteve ne nje periudhe te caktuar kohore
   
CREATE VIEW Analzia_E_shitjeve_per_periudhe AS
SELECT p.emri, SUM(l.qnt) AS sasija_total, SUM(l.qnt * p.cmimi) AS shpenzimet_totale
FROM Fature f
JOIN Lista_Produkteve l ON f.id = l.fature_id
JOIN Produkt2 p ON l.produkt_id = p.id
WHERE f.data_blerjes BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY p.emri;

    select *
    from Analzia_E_shitjeve_per_periudhe
   
 
                 --indekse
                 
                 
                 
  --kkrijimi i indeksit per analizen e shpenzimeve mujore per bleresit
 
 CREATE INDEX idx_fature_bleres_data
ON Fature(bleres_id, data_blerjes);

SELECT
    B.emer AS bleres_emer,
    B.mbiemer AS bleres_mbiemer,
    YEAR(F.data_blerjes) AS viti,
    MONTH(F.data_blerjes) AS muaji,
    SUM(F.kosto_totale) AS total_shpenzime
FROM Fature F
JOIN Bleres B ON F.bleres_id = B.ID
WHERE F.data_blerjes BETWEEN '2024-01-01' AND '2024-12-31'
GROUP BY B.emer, B.mbiemer, YEAR(F.data_blerjes), MONTH(F.data_blerjes)
ORDER BY viti, muaji;


--kriji i indeksit i cili te permbaje detajet per produkte dhe disponueshmerine ne dyqan

create index  idx_tregton1_produkt_sasia
on tregton1(produkt_id,sasia_e_disponueshme);

select t.produkt_id,p.emri,t.sasia_e_disponueshme
from Tregton1 t
join Produkt2 p on t.produkt_id=p.id
where t.sasia_e_disponueshme>50;




--krijimi i indeksit per produkte me sasi te siponueshme

create index idx_tregton1_produkt_sasia2
on Tregton1(Produkt_id,Sasia_e_disponueshme);
select t.produkt_id,p.emri,t.sasia_e_disponueshme
from Tregton1 t
join Produkt2 p on t.produkt_id=p.id
where t.sasia_e_disponueshme>100


--krijimi i indeksit per dyqant me nje adrese te caktuar(FIER)

create index dyqani_adresa1
on Dyqani(id,adresa);

select d.id,d.name,d.city,d.adresa
from Dyqani d
where d.city like '%Fiew%';



                  --CREATED PROCEDURE
                 
--SHFAQ dyqanin me shitjet me te larta dhe shumen totale te shitjeve

create procedure DyqnaiMeShitjeMax as
begin
   select top 1 d.name,sum(lp.qnt*p.cmimi)
   from Dyqani d
   inner join Tregton1 t on d.id=t.dyqan_id
   inner join Produkt2 p on t.produkt_id=p.id
   inner join Lista_Produkteve lp on p.id=lp.produkt_id
   group by d.name
   order by sum(lp.qnt*p.cmimi) desc
   end;
                 
exec DyqaniMeShitjetMax


--shfaq 5 bleresit mem te mire (qe kane shpenzuar me shume)

create procedure top5bleresit
as
begin
   select top 5 b.emer,b.mbiemer,sum(f.kosto_totale)
   from Bleres b
   inner join Fature f on b.id=f.bleres_id
   group by b.emer,b.mbiemer
   order by sum(f.kosto_totale) desc
 end;
 
 exec top5bleresit
 
 
 --shafq dyqanet qe kane shitur te pakten nje produkt mbi nje shume te caktuar 5000
 
CREATE PROCEDURE DyqanetMeShitjeMinimale
   @ShumaMin DECIMAL(18, 2)
AS
BEGIN
   SELECT d.name, SUM(lp.qnt * p.cmimi) AS ShumaTotale
   FROM Dyqani d
   INNER JOIN Tregton1 t ON d.id = t.dyqan_id
   INNER JOIN Produkt2 p ON t.produkt_id = p.id
   INNER JOIN Lista_Produkteve lp ON p.id = lp.produkt_id
   GROUP BY d.name
   HAVING SUM(lp.qnt * p.cmimi) >= @ShumaMin;
END;

EXEC DyqanetMeShitjeMinimale @ShumaMin = 5000;

 
 
 --shfaq produktet me fititmprures sipas nje periudhe kohore
 
 create procedure ProdukteFitimprurese(@StartDate DATE, @EndDate DATE)
 AS
 begin
     select p.emri,sum(lp.qnt*P.cmimi)
     from Produkt2 p
     inner join Lista_Produkteve lp on p.id=lp.produkt_id
     inner join Fature f on lp.fature_id=f.id
     where f.data_blerjes between  @StartDate AND @EndDate
     group by p.emri
     order by sum(lp.qnt*p.cmimi) desc;
  end;
 
 
  exec ProdukteFitimprurese '2024-01-01','2024-12-31';
 
 
--gjej dyqanet me mungese produktesh te shitura krahasuar me totalin ne stok

create procedure DyqanetMEMungesa2
as
begin
  select d.name,p.emri,t.sasia_e_disponueshme,coalesce(sum(lp.qnt),0),
  (t.sasia_e_disponueshme-coalesce(sum(lp.qnt),0)) as mbetje
  from Dyqani d
  inner join Tregton1 on d.id=t.dyqan_id
  inner join Produkt2 p on t.produkt_id=p.id
  left join Lista_Produkteve lp on p.id=lp.produkt_id
  group by d.name,p.emri,t.sasia_E_dispoueshme
  having(t.sasia_e_disponueshme-coalesce(sum(lp.qnt),0))>10
 end;
 
 exec DyqanetMEMungesa2
 
--gjej faturat me zbritje totale pertej nje vlere te caktuar

create procedure FaturaMeZbritje(@ZbritjeMin DECIMAL(10, 2))
as
begin
    select f.id,b.emer,b.mbiemer,sum(lp.qnt,p.cmimi*(p.cmimi/100)) as zbritje_totale
    from Fature f
    inner join Lista_produkteve lp on f.id=lp.fature_id
    inner join Produkt2 p on lp.prodult_id=p.id
    inner join Bleres b on f.bleres_id=b.id
    group by f.id,b.emer,b.mbiemer
    having sum(lp.qnt*p.cmimi*(p.cmimi/100))> @ZbritjeMin;
 end;
 
exec  FaturaMeZbritje @ZbritjeMin=10
                     
 
 
--shfaq 3 produkte me rritjen me te madhe te shitjeve muaj pas muaj
                     
create proxedure ProduktetRritjeShitjesh
as
begin
   with shitjeMujore as
                      (
                        select p.emri,month(f.data_blerjes),year(f.data_blerjes),sum(lp.qnt)
                        from Produkt2 p
                        inner join Lista_Produkteve lp on p.id=lp.produkt_id
                        inner join Fature f on lp.fature_id=f.id
                        group by p.emri,month(f.data_blerjes),year(f.data_blerjes)
                        )
                      select top 3 a.emri,a.sasia_total,b.sasia_total,(A.sasia_total-b.sasia_total) from shitjeMujore A
                      inner join shitjeMujore B
                      on A.emri=b.emri and A.viti=B.viti and A.muaji=b.Muaji+1
                     
                 order by Rritja desc
               end;
           
                     
       exec ProduktetRritjeShitjesh
     


--shfaq raportin e shitjeve per secilin dyqan per periudha mujore
                     
 create procedure raportiMujorDyqane
 as
 begin
       select d.name,concat(year(f.data_blerjes),'-',month(f.data_blerjes)),sum(lp.qnt*p.cmimi)
 from Dyqani d
 inner join tregton1 t on d.id=t.dyqan_id
 inner join produkt2 p on t.produkt_id=p.id
 inner join Lista_Produkteve lp on p.id=lp.produkt_id
 inner join Fature f on lp.fature_id=f.id
 group by d.name,year(f.data_blerjes),month(f.data_blerjes)
 order by d.name,concat(year(f.data_blerjes),'-',month(f.data_blerjes))
end;
                     
                     
exec raportiMujorDyqane
                     
                     
                     
                     
                     
--shfaq raportin e shitjeve per secilin dyqan per periudha mujore
                     
 create procedure RaportiMujorDyqane
 as
 begin
        select d.name,concat(year(f.data_blerjes),'-',month(f.data_blerjes)),
              sum(lp.qnt*p.cmimi)
         from Dyqani d
         inner join Tregton1 t on d.id=t.dyqan_id
         inner join Produkt2 p on t.produkt_id=p.id
         inner join Lista_Produkteve lp on p.id=lp.produkt_id
         inner join fature f on lp.fature_id=f.id
         group by d.name,year(f.data_blerjes),month(f.data_blerjes)
         order by d.name,concat(year(f.data_blerjes),'-',month(f.data_blerjes))
   end;
                     
   exec  RaportiMujorDyqane
                     
                   
                     
                     
  --shfaq faturat qe kane perfshire produktet me te shtrenjta
               
                     
  create procedure FaturatMeProdukteMëTeShtrenjta
  AS
   begin  
       select distinct f.id,p.emri
       from fature f
       inner join lista_produkteve lp on f.id=lp.fature_id
       inner join produkt2 p on lp.produkt_id=p.id
       where p.cmimi=(select max(cmimi) from produkt2);
     end;
 
   exec FaturatMeProdukteMëTeShtrenjta;
                     
     
--analizo te ardhurat dhe shitjet e produkteve per cdo kategori ne nje periudhe kohore
   
create procedure ShitjetPerKategorite1(@StartDate DATE, @EndDate DATE)
as
   begin
      select p.category, sum(lp.qnt * p.cmimi), sum(lp.qnt)
      from Produkt3 p  
      inner join Lista_Produkteve lp on p.id = lp.produkt_id
      inner join Fature f on lp.fature_id = f.id
      where f.data_blerjes between @StartDate and @EndDate
      group by p.category
      order by sum(lp.qnt * p.cmimi) desc;
   end;

                     
  exec ShitjetPerKategorite1  @StartDate = '2024-01-01', @EndDate = '2024-12-31';      
                     

--Përcakto trigjerat për të zbatuar rregullat e biznesit, automatizuar validimin e te dhënave, dhe mbajtur konsistencën e të dhënave.

               
 --krijo nje trigger i cili te logoje produktet e reja
 
create trigger trg_insert_Produkt2
on Produkt3
for insert
as
begin
    insert into log (event, description, timestamp)
    values ('insert', concat('produkti i ri u shtua: ', (select emri from inserted)), GETDATE());
end;

--PROVA 

--KRIJOJME TABELEN LOG
CREATE TABLE log (
    event VARCHAR(50),
    description VARCHAR(255),
    timestamp DATETIME
);


--SHTOJME TE DHENAT E REJA NE TABELEN PRODUKT3
INSERT INTO Produkt3 (id, kodi, emri, cmimi, category)
VALUES ('PR600', 'P01', 'Produkt Test', 100, 'Kategoria 1');

--SELECTOJME KETE TABELE QE DO TE RUAJE TE DHENAT E REJA QE PLOTESOJNE KUSHTIN E TRIGGER
SELECT * FROM log;

 

   
--krijo nje trigger i cili te pershkruaj procesin e ndryshimit te cmimit te produktit

CREATE TRIGGER trg_update_cmimi
ON Produkt3
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted i INNER JOIN deleted d ON i.id = d.id WHERE i.cmimi <> d.cmimi)
    BEGIN
        INSERT INTO log (event, description, timestamp)
        SELECT 'update', 
               CONCAT('cmimi ndryshoi nga ', d.cmimi, ' ne ', i.cmimi),
               GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE i.cmimi <> d.cmimi;
    END
END;

--prova

INSERT INTO Produkt3 (id, kodi, emri, cmimi, category)
VALUES ('PR800', 'P08', 'Produkt Test 2', 50, 'Kategoria 2');

UPDATE Produkt3
SET cmimi = 75
WHERE id = 'PR800';

SELECT * FROM log;


--trigger per fshirjen e produktit

CREATE TRIGGER treg_delete_produkt
ON Produkt3
FOR DELETE
AS BEGIN INSERT INTO log (event, description, timestamp)
SELECT 'delete', CONCAT('Produkti u fshi: ', d.emri), GETDATE()
    FROM deleted d;
END;

--prova

DELETE FROM Produkt3 WHERE id = 'PR600';

SELECT * FROM log;


--trigger per kontrollin e dates se fatures

CREATE TRIGGER trg_insert_fature_date
ON Fature
FOR INSERT
As BEGIN UPDATE Fature
    SET data_blerjes = GETDATE()
    WHERE id IN (SELECT id FROM inserted WHERE data_blerjes IS NULL);
END;

--prova

INSERT INTO Fature (id, data_blerjes)
VALUES (1001, NULL);  -- Lë `data_blerjes` si NULL për të aktivizuar trigger-in


 SELECT * FROM Fature WHERE id = 1001;


--trigger per te kontrolluar sasine e produktit te tregetuar

CREATE TRIGGER trg_check_status_tregton
ON tregton1
FOR INSERT
AS BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE sasia_e_disponueshme < 0)
    BEGIN
        RAISERROR('Sasia nuk mund te jete negative', 16, 1);
        ROLLBACK TRANSACTION;   
    END
END;


--prova
--primtohet mesazhi qe s'mund te jete sasia negative

INSERT INTO tregton1 (dyqan_id, sasia_e_disponueshme)
VALUES (1, -5);

--e rregulloje me nje sasi pozitive
 
INSERT INTO tregton1 (dyqan_id, sasia_e_disponueshme)
VALUES (2, 10);

 

--trigger per ndryshimin e sasise se produkteve

CREATE TRIGGER trg_update_sasia
ON Tregton1
AFTER UPDATE AS BEGIN
    INSERT INTO log (event, description, timestamp)
    SELECT 'update', 
           CONCAT('Sasia ndryshoi per produkt id: ', i.produkt_id),
           GETDATE()
    FROM inserted i
    INNER JOIN deleted d ON i.produkt_id = d.produkt_id
    WHERE i.produkt_id <> d.produkt_id;
END;

--prova

UPDATE Tregton1
SET produkt_id = '2'
WHERE produkt_id = '1';

SELECT * FROM log;


--trigger per parandalimin e fshirjes se produkteve

CREATE TRIGGER trg_prevent_delete
ON Lista_Produkteve
FOR DELETE AS BEGIN
    RAISERROR('Nuk mund te fshihet produkti nga fatura', 16, 1);
    ROLLBACK TRANSACTION;
END;


--prova
DELETE FROM Lista_Produkteve
WHERE produkt_id = '1';



--triggger per ndryshimin e adreses se dyqanit

CREATE TRIGGER trg_update_adresa_dyqan
ON dyqani
AFTER UPDATE AS
BEGIN IF EXISTS (SELECT 1 FROM inserted i
               INNER JOIN deleted d ON i.id = d.id
               WHERE i.adresa <> d.adresa)
    BEGIN
        INSERT INTO log (event, description, timestamp)
        SELECT 'update',
               CONCAT('Adresa ndryshoi per dyqanin id:', i.id),
               GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE i.adresa <> d.adresa;
    END
END;


--prova

UPDATE dyqani
SET adresa = 'Adresa e Re'
WHERE id = 1;

SELECT * FROM log;

--trigger per kontrollin e cmimit minimal

CREATE TRIGGER trg_CHECK_cmimi_produkt
ON produkt3
AFTER INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE cmimi <= 0)
    BEGIN
        RAISERROR('Cmimi duhet te jete pozitiv', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--testimi

INSERT INTO produkt3 (id, kodi, emri, cmimi, category)
VALUES ('P001', 'K001', 'Produkt Test', -5, 'Kategoria 1');

--rasti 2 
INSERT INTO produkt3 (id, kodi, emri, cmimi, category)
VALUES ('P001', 'K001', 'Produkt Test', 5, 'Kategoria 1');


--trigger per log fshirjen e bleresit

CREATE TRIGGER trg_delete_bleres
ON bleres
AFTER DELETE AS BEGIN
    INSERT INTO log (event, description, timestamp)
    SELECT 'delete', 
           CONCAT('Bleresi u fshi: ', d.emer), 
           GETDATE()
    FROM deleted d;
END;

 --orova
 
DELETE FROM bleres WHERE id = 1;



--trigger per ndryshim te emailit te bleresit

CREATE TRIGGER trg_update_email_bleres
ON bleres
AFTER UPDATE AS BEGIN
    IF EXISTS (SELECT 1 FROM inserted i 
               INNER JOIN deleted d ON i.id = d.id
               WHERE i.email <> d.email)
    BEGIN
        INSERT INTO log (event, description, timestamp)
        SELECT 'update', 
               CONCAT('Email ndryshoi per bleres id: ', i.id),
               GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE i.email <> d.email;
    END
END;

--prova
UPDATE bleres
SET email = 'newemail@example.com'
WHERE id = 1;

select email
from Bleres
where id=1



--trigger per parandalimin e fshirjes se produkteve nga punonjesi

CREATE TRIGGER trg_prevent_delete1
ON Dyqani
INSTEAD OF DELETE
AS
BEGIN
    RAISERROR('Nuk mund te shihet dyqani', 16, 1);
    
END;


--prova
DELETE FROM Dyqani WHERE id = 1;

--trigger per shtimin te log ne fature

CREATE TRIGGER trg_insert_fature_log
ON fature
AFTER INSERT
AS
BEGIN
    INSERT INTO log (event, description, timestamp)
    SELECT 'insert', 
           CONCAT('Fature e re u krijua id:', i.id),
           GETDATE()
    FROM INSERTED i;
END;

--prova


INSERT INTO fature (id, status, data_blerjes) 
VALUES (901, 'aktiv', GETDATE());

 SELECT * FROM log;


--trigger per ndryshimin e qytetit ne dyqan
CREATE TRIGGER trg_update_CITY_dyqan ON dyqani
AFTER UPDATE AS BEGIN
    IF EXISTS (SELECT 1 
               FROM inserted i
               INNER JOIN deleted d ON i.id = d.id 
               WHERE i.city <> d.city)
    BEGIN
        INSERT INTO log(event, description, timestamp)
        SELECT 'Update', 
               CONCAT('Qyteti ndryshoi per dyqanin id:', i.id),
               GETDATE()
        FROM inserted i
        INNER JOIN deleted d ON i.id = d.id
        WHERE i.city <> d.city;
    END
END;

--prova

INSERT INTO dyqani (id, name, city) 
VALUES (802, 'Dyqani Test', 'Tiranë');

 UPDATE dyqani 
SET city = 'Shkodër' 
WHERE id = 802;


SELECT * FROM log WHERE event = 'Update';


--trigger per ndryshimin e emrit te produktit

CREATE TRIGGER trg_update_emri_produktit
ON produkt3
AFTER UPDATE
AS
BEGIN
    -- Kontrollojmë nëse emri ka ndryshuar nga i vjetri në të ri
    IF EXISTS (SELECT 1 
               FROM inserted i
               INNER JOIN deleted d ON i.id = d.id
               WHERE i.emri <> d.emri)
    BEGIN
        -- Regjistrojmë ndryshimin në log
        INSERT INTO log (event, description, timestamp)
        VALUES ('update', CONCAT('Emri ndryshoi per produkt id:', (SELECT i.id FROM inserted i WHERE i.emri <> (SELECT d.emri FROM deleted d WHERE d.id = i.id))), GETDATE());
    END
END;



INSERT INTO produkt3 (id, emri)
VALUES (1, 'Produkt A');



UPDATE produkt3
SET emri = 'Produkt B'
WHERE id = '102';

SELECT * FROM log;


--Trigger për fshirjen e produkteve dhe regjistrimin në tabelën

CREATE TRIGGER trg_delete_product
ON Produkt3
AFTER DELETE
AS
BEGIN
    INSERT INTO log (event, description, timestamp)
    SELECT 'DELETE', CONCAT('Produkt i fshirë: ', d.id, ' - ', d.emri), GETDATE()
    FROM deleted d;
END;


--prova

INSERT INTO Produkt3 (id, emri)
VALUES (103, 'Produkt i ri');

DELETE FROM Produkt3 WHERE id = '103';

SELECT * FROM log;


--Trigger për të siguruar që kodi i produktit të jetë unik


CREATE TRIGGER trg_check_unique_kodi ON Produkt2
AFTER INSERT AS BEGIN
    IF EXISTS (SELECT 1 FROM Produkt2 WHERE kodi IN (SELECT kodi FROM inserted))
    BEGIN
        RAISERROR('Kodi i produktit duhet të jetë unik', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;

--prova

INSERT INTO Produkt2 (id, kodi, emri, cmimi)
VALUES ('P01', 'KODI001', 'Produkt 1', 100);


INSERT INTO Produkt2 (id, kodi, emri, cmimi)
VALUES ('P02', 'KODI001', 'Produkt 2', 200);

