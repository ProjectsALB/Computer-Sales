--Hiqni duplikatët, gabimet, ose të dhënat jashtë vlerave të pranueshme nga të dhënat e paraqitura në formë brut.

--heqja e perseritjeve

select *
from ComputerShop
 

WITH CTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY age, gender, laptop_model, laptop_price, laptop_ram, 
                         laptop_processor, laptop_screen_size, laptop_battery_life, laptop_color, country
            ORDER BY (SELECT NULL)  -- Ose një kolonë specifike për prioritizim
        ) AS rn
    FROM ComputerShop
)
DELETE FROM CTE
WHERE rn > 1;


    --heqja e rreshtave jashte intervalit

-- hejqa e vlerave kur nmosha eshte poshte 18 dhe siper 100
DELETE FROM ComputerShop
WHERE age < 18 OR age > 100;

select *
from ComputerShop

-- Heqja e rreshtave me çmime të pavlefshme 

DELETE FROM ComputerShop
WHERE laptop_price < 100 OR laptop_price > 10000;

-- vlera e pranueshme: '4GB', '8GB', '16GB', '32GB', '64GB' ram

DELETE FROM ComputerShop
WHERE laptop_ram NOT IN ('4GB', '8GB', '16GB', '32GB', '64GB', '128GB');

-- permase e ekranit jo me pak se 13 dhe jo me shume se 20

DELETE FROM ComputerShop
WHERE laptop_screen_size < 13 OR laptop_screen_size > 20;

select *
from ComputerShop

-- jetegjatesia e baterise jo me pak se 2 dhe jo me shume se 24 ore

DELETE FROM ComputerShop
WHERE laptop_battery_life < 2 OR laptop_battery_life > 24;

--heqaj e rasteve per gjinine

DELETE FROM ComputerShop
WHERE gender NOT IN ('Male', 'Female');

-- Heqja e rreshtave me vend bosh ose të pavlefshëm
DELETE FROM ComputerShop
WHERE country IS NULL OR TRIM(country) = '';

--hiq procesoret te cilet nuk jane intel

DELETE FROM ComputerShop
WHERE laptop_processor NOT LIKE '%Intel%' AND laptop_processor NOT LIKE '%AMD%';

select *
from ComputerShop

-- Heqja e rreshtave me bateri bosh ose të pavlefshme
 
DELETE FROM ComputerShop
WHERE laptop_battery_life IS NULL;

-- Heqja e rreshtave me RAM ose madhësi ekrani bosh

DELETE FROM ComputerShop
WHERE laptop_ram IS NULL OR laptop_screen_size IS NULL;


select *
from ComputerShop