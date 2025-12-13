CREATE OR REPLACE VIEW vw_complete_players AS
SELECT
    p.id AS player_id,
    p.name AS player_name,
    p.overall_rating AS overall_rating,
    n.description AS nationality,
    c.description AS club_name,
    STRING_AGG(pos.description, ', ') AS player_positions
FROM 
    players p
LEFT JOIN 
    clubs c ON p.code_club_team = c.code_club_team
LEFT JOIN 
    nationality n ON p.code_nationality = n.code_nationality
LEFT JOIN 
    position_player pp ON p.id = pp.code_player
LEFT JOIN 
    positions pos ON pp.code_position = pos.code_position
GROUP BY 
    p.id,
    p.name,
    p.overall_rating,
    n.description,
    c.description;

SELECT * FROM vw_complete_players
