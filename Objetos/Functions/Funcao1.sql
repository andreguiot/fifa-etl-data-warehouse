/*Função: Overall Personalizado por Clube
Objetivo: Calcular um Overall calculado (usando uma média ponderada de atributos relevantes) para cada clube e compará-lo com o overall oficial do clube armazenado na tabela clubs.

Fórmula usada

Overall_custom =
(0.20 * finishing) +
(0.20 * short_passing) +
(0.20 * dribbling) +
(0.20 * reactions) +
(0.20 * stamina) */

CREATE OR REPLACE FUNCTION fn_overall_custom_clube(p_club_id INT)
RETURNS TABLE(
    club_name VARCHAR,
    overall_oficial NUMERIC,
    overall_custom NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.description AS club_name,
        c.club_rating AS overall_oficial,
        ROUND(AVG(
              (0.20 * p.finishing)
            + (0.20 * p.short_passing)
            + (0.20 * p.dribbling)
            + (0.20 * p.reactions)
            + (0.20 * p.stamina)
        ), 2) AS overall_custom
    FROM players p
    JOIN clubs c ON c.code_club_team = p.code_club_team
    WHERE p.code_club_team = p_club_id
    GROUP BY c.description, c.club_rating;
END;
$$ LANGUAGE plpgsql;

/// Chamada da função SELECT * FROM fn_overall_custom_clube(123);