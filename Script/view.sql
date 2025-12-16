CREATE OR REPLACE VIEW vw_best_players_by_position AS
SELECT
    pos.description AS position,
    p.id,
    p.name,
    p.full_name,
    p.overall_rating,
    p.potential,
    (p.acceleration + p.sprint_speed + p.dribbling + p.ball_control + p.short_passing) / 5.0 
        AS avg_key_attributes
FROM position_player pp
JOIN positions pos ON pp.code_position = pos.code_position
JOIN players p ON pp.code_player = p.id
ORDER BY pos.description, overall_rating DESC;
