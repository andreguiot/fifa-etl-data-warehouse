
SELECT c.description AS club, 
       AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.club_join_date))) AS avg_tenure_years
FROM players p
JOIN clubs c ON p.code_club_team = c.code_club_team
WHERE p.club_join_date IS NOT NULL
GROUP BY c.description
ORDER BY avg_tenure_years DESC;