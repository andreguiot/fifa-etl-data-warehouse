
SELECT pos.description AS position,
       SUM(p.overall_rating) / NULLIF(SUM(p.wage_euro),0) AS overall_per_wage
FROM position_player pp
JOIN positions pos ON pp.code_position = pos.code_position
JOIN players p ON pp.code_player = p.id
GROUP BY pos.description
ORDER BY overall_per_wage DESC;
