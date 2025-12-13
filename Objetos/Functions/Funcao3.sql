/*Função: Análise Estratégica por Nação
Objetivo: Identificar, para cada país a nação forte no jogo aéreo, Nação mais veloz, Nação forte fisicamente, Nações com múltiplas vantagens.

Gerar estratégias para enfrentar cada tipo de perfil
Perfis
Perfil		Cálculo
Jogo Aéreo	(heading_accuracy + jumping) / 2
Velocidade	(acceleration + sprint_speed) / 2
Força Física	strength

Estratégias sugeridas:
Contra nações aéreas: “Explorar jogadas rápidas pelo chão e evitar escanteios.”
Contra velozes: “Linha defensiva mais recuada e compactação.”
Contra fortes fisicamente: “Evitar contato direto, usar troca rápida de passes.”
Se tem 2 ou 3 atributos altos: “Jogo equilibrado e marcação híbrida.”

Função SQL */

CREATE OR REPLACE FUNCTION fn_analise_nacoes()
RETURNS TABLE(
    nationality VARCHAR,
    aerial_score NUMERIC,
    speed_score NUMERIC,
    strength_score NUMERIC,
    perfil VARCHAR,
    estrategia VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        n.description AS nationality,

        ROUND(AVG((p.heading_accuracy + p.jumping) / 2.0), 2) AS aerial_score,
        ROUND(AVG((p.acceleration + p.sprint_speed) / 2.0), 2) AS speed_score,
        ROUND(AVG(p.strength), 2) AS strength_score,

        CASE 
            WHEN AVG((p.heading_accuracy + p.jumping)/2) > 70
              AND AVG((p.acceleration + p.sprint_speed)/2) > 70 THEN 'Aérea e veloz'
            WHEN AVG((p.heading_accuracy + p.jumping)/2) > 70
              AND AVG(p.strength) > 70 THEN 'Aérea e forte'
            WHEN AVG((p.acceleration + p.sprint_speed)/2) > 70
              AND AVG(p.strength) > 70 THEN 'Veloz e forte'
            WHEN AVG((p.heading_accuracy + p.jumping)/2) > 70 THEN 'Forte no jogo aéreo'
            WHEN AVG((p.acceleration + p.sprint_speed)/2) > 70 THEN 'Muito veloz'
            WHEN AVG(p.strength) > 70 THEN 'Forte fisicamente'
            ELSE 'Equilibrada'
        END AS perfil,

        CASE
            WHEN AVG((p.heading_accuracy + p.jumping)/2) > 70 THEN 
                'Evitar bolas aéreas, explorar passes curtos.'
            WHEN AVG((p.acceleration + p.sprint_speed)/2) > 70 THEN
                'Linha defensiva recuada, marcar profundidade.'
            WHEN AVG(p.strength) > 70 THEN
                'Troca rápida de passes, evitar contato.'
            ELSE 
                'Estratégia padrão equilibrada.'
        END AS estrategia

    FROM players p
    JOIN nationality n ON n.code_nationality = p.code_nationality
    GROUP BY n.description;
END;
$$ LANGUAGE plpgsql;