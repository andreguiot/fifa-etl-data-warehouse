-- -----------------------------------------------------------------------------
-- PERGUNTA 1: VIÉS CONTINENTAL (FÍSICO vs. MENTAL)
-- "O jogo atribui atributos físicos superiores a Africanos/Sul-Americanos 
-- e mentais superiores a Europeus?"
-- -----------------------------------------------------------------------------

SELECT 
    d.continent AS "Continente",
    COUNT(DISTINCT d.description) AS "Qtd_Paises",
    
    ROUND(AVG(f.avg_sprint_speed)::numeric, 2) AS "Média_Velocidade",
    ROUND(AVG(f.avg_strength)::numeric, 2) AS "Média_Força",
    ROUND(AVG(f.avg_vision)::numeric, 2) AS "Média_Visão_Jogo",
    ROUND(AVG(f.avg_positioning)::numeric, 2) AS "Média_Posicionamento",
    ROUND(AVG(f.avg_overall)::numeric, 2) AS "Média_Geral_Overall"
FROM 
    ft_performance_nacional f
JOIN 
    dim_national_team d ON f.code_national_team = d.code_national_team
WHERE 
    d.continent IS NOT NULL 
GROUP BY 
    d.continent
ORDER BY 
    "Média_Velocidade" DESC;

-- -----------------------------------------------------------------------------
-- PERGUNTA 2: ANÁLISE DE FAIXA ETÁRIA (CUSTO X BENEFÍCIO)
-- "Qual faixa etária tem o maior Valor de Mercado e qual entrega o maior Overall?"
-- -----------------------------------------------------------------------------

SELECT 
    a.description AS "Faixa_Etária",
    
    -- Performance Técnica
    ROUND(AVG(f.avg_overall)::numeric, 2) AS "Média_Overall",
    
    -- Aspecto Financeiro
    TO_CHAR(AVG(f.avg_market_value), 'FM999,999,999.00') AS "Valor_Mercado_Médio_€",
    TO_CHAR(AVG(f.avg_wage_euro), 'FM999,999,999.00') AS "Salário_Médio_€",
    
    -- Indicador de Custo-Benefício (Valor / Overall)
    -- Quanto custa cada ponto de Overall?
    ROUND((AVG(f.avg_market_value) / NULLIF(AVG(f.avg_overall),0))::numeric, 2) AS "Custo_por_Ponto_Overall"
FROM 
    ft_performance_nacional f
JOIN 
    dim_age_group a ON f.code_age_group = a.code_age_group
GROUP BY 
    a.code_age_group, a.description -- Agrupa pelo código para ordenar corretamente (1,2,3...)
ORDER BY 
    a.code_age_group ASC;

-- -----------------------------------------------------------------------------
-- PERGUNTA 3 (ESTRATÉGIA): MELHORES NAÇÕES PARA JOGO AÉREO E FORÇA
-- "Contra quem devo jogar com bola no chão e contra quem evitar o choque?"
-- -----------------------------------------------------------------------------

SELECT 
    d.description AS "País",
    d.continent AS "Continente",
    ROUND(AVG(f.avg_strength)::numeric, 1) AS "Força_Física",
    ROUND(AVG(f.avg_sprint_speed)::numeric, 1) AS "Velocidade",
    ROUND(AVG(f.avg_overall)::numeric, 1) AS "Overall"
FROM 
    ft_performance_nacional f
JOIN 
    dim_national_team d ON f.code_national_team = d.code_national_team
GROUP BY 
    d.description, d.continent
HAVING 
    AVG(f.avg_overall) > 75 -- Filtrar apenas seleções de alto nível
ORDER BY 
    "Força_Física" DESC -- Top países mais fortes fisicamente
LIMIT 10;

-- -----------------------------------------------------------------------------
-- PERGUNTA 4 : TOP 5 CLUBES QUE MAIS CEDEM JOGADORES PARA SELEÇÕES
-- "Quais clubes são a base das seleções nacionais de alto nível?"
-- -----------------------------------------------------------------------------

SELECT 
    c.description AS "Clube",
    COUNT(*) AS "Total_Registros_Fato",
    ROUND(AVG(f.avg_overall)::numeric, 2) AS "Média_Overall_Cedidos"
FROM 
    ft_performance_nacional f
JOIN 
    dim_clubs c ON f.code_club = c.code_club_team
GROUP BY 
    c.description
ORDER BY 
    "Total_Registros_Fato" DESC
LIMIT 5;