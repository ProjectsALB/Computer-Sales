SELECT 
    d.name AS Dyqani,
    SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve
FROM 
    Dyqani d
JOIN 
    Tregton1 t ON d.id = t.dyqan_id
JOIN 
    Produkt2 p ON t.produkt_id = p.id
JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY 
    d.name
ORDER BY 
    Totali_Shitjeve DESC;


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




SELECT 
    d.city AS Lokacioni,
    SUM(lp.qnt * p.cmimi) AS Totali_Shitjeve
FROM 
    Lokacioni l
from Dyqani
    Dyqani d ON l.id = d.lokacion_id
JOIN 
    Tregton1 t ON d.id = t.dyqan_id
JOIN 
    Produkt2 p ON t.produkt_id = p.id
JOIN 
    Lista_Produkteve lp ON p.id = lp.produkt_id
GROUP BY 
    l.city
ORDER BY 
    Totali_Shitjeve DESC;
