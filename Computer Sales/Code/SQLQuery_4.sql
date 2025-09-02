


SELECT 
    CASE 
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) < 18 THEN 'Nën 18'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 18 AND 35 THEN '18-35'
        WHEN DATEDIFF(YEAR, b.datelindja, GETDATE()) BETWEEN 36 AND 60 THEN '36-60'
        ELSE 'Mbi 60'
    END AS Grupi_Moshës,
    COUNT(*) AS Numri_Klientëve,
    SUM(f.kosto_totale) AS ShpenzimetTotale
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
    Grupi_Moshës;
