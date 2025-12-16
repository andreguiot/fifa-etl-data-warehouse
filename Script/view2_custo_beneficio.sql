CREATE OR REPLACE VIEW vw_custo_beneficio AS
SELECT
    p.id,
    p.name,
    p.full_name,
    p.overall_rating,
    p.wage_euro,
    
    CASE 
        WHEN p.wage_euro = 0 THEN NULL
        ELSE ROUND(p.overall_rating / p.wage_euro, 6)
    END AS custo_beneficio,

    c.description AS club,
    n.description AS nationality
FROM players p
LEFT JOIN clubs c ON p.code_club_team = c.code_club_team
LEFT JOIN nationality n ON p.code_nationality = n.code_nationality
WHERE p.wage_euro IS NOT NULL
ORDER BY custo_beneficio DESC;
