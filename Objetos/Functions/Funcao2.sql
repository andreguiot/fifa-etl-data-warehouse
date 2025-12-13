/*Função: Time Ideal para Enfrentar um Clube
Objetivo: Analisar o perfil do clube adversário (ex.: rápido, forte no passe, fraco na defesa) e selecionar jogadores do banco de dados que contrapõem diretamente as forças e exploram as fraquezas desse clube.
Critérios
Se o clube adversário tiver:
Alta velocidade média → selecionar defensores com alto standing_tackle + bom balance
Bom jogo aéreo (heading_accuracy + jumping alto) → selecionar zagueiros com strength e jumping alto
Ataque forte → selecionar volantes com interceptation e agression alto

Função SQL
A função retorna um time ideal com 11 jogadores.*/

CREATE OR REPLACE FUNCTION fn_time_ideal_vs_clube(p_club_id INT)
RETURNS TABLE(
    player_name VARCHAR,
    position VARCHAR,
    reason VARCHAR
) AS $$
DECLARE
    v_speed NUMERIC;
    v_aerial NUMERIC;
    v_attack NUMERIC;
BEGIN
    -- Média do clube adversário
    SELECT 
        AVG(acceleration + sprint_speed)/2,
        AVG(heading_accuracy + jumping)/2,
        AVG(finishing + positioning)/2
    INTO v_speed, v_aerial, v_attack
    FROM players
    WHERE code_club_team = p_club_id;

    -- Seleciona jogadores ideais
    RETURN QUERY
    WITH base AS (
        SELECT 
            p.name,
            pos.description AS position,
            p.standing_tackle,
            p.strength,
            p.jumping,
            p.interceptation,
            p.agression,
            p.acceleration,
            p.sprint_speed
        FROM players p
        JOIN position_player pp ON pp.code_player = p.id
        JOIN positions pos ON pos.code_position = pp.code_position
    )
    SELECT 
        name,
        position,
        CASE
            WHEN v_speed > 70 THEN 'Adversário rápido -> selecionado pela força de marcação'
            WHEN v_aerial > 70 THEN 'Adversário forte no jogo aéreo -> selecionado pela força e impulsão'
            WHEN v_attack > 75 THEN 'Ataque forte -> selecionado pela interceptação e agressividade'
            ELSE 'Jogador equilibrado para compor a estratégia'
        END AS reason
    FROM base
    ORDER BY
        (CASE WHEN v_speed > 70 THEN standing_tackle + balance END) DESC NULLS LAST,
        (CASE WHEN v_aerial > 70 THEN strength + jumping END) DESC NULLS LAST,
        (CASE WHEN v_attack > 75 THEN interceptation + agression END) DESC NULLS LAST
    LIMIT 11; 
END;
$$ LANGUAGE plpgsql;