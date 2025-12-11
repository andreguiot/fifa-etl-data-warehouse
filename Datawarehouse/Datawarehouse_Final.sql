-- 1. Dimensão Faixa Etária 
CREATE TABLE dim_age_group (
    code_age_group integer,
    description varchar(50),
    CONSTRAINT "pk_dim_age_group" PRIMARY KEY (code_age_group)
);

INSERT INTO dim_age_group (code_age_group, description) VALUES (1, 'Menor que 20 anos');
INSERT INTO dim_age_group (code_age_group, description) VALUES (2, 'Entre 20 e 24 anos');
INSERT INTO dim_age_group (code_age_group, description) VALUES (3, 'Entre 25 e 28 anos');
INSERT INTO dim_age_group (code_age_group, description) VALUES (4, 'Entre 28 e 32 anos');
INSERT INTO dim_age_group (code_age_group, description) VALUES (5, 'Maior que 32 anos');

-- 2. Dimensão Clubes
CREATE TABLE dim_clubs (
    code_club_team serial,
    description varchar(100),
    club_rating integer,
    CONSTRAINT "pk_dim_clubs" PRIMARY KEY (code_club_team)
);

-- 3. Dimensão Seleções 
CREATE TABLE dim_national_team (
    code_national_team serial, 
    description varchar(100),
    national_rating integer,
    CONSTRAINT "pk_dim_national_team" PRIMARY KEY (code_national_team)
);

-- 4. Dimensão Posições
CREATE TABLE dim_positions (
    code_position serial, 
    description varchar(5),
    CONSTRAINT "pk_dim_positions" PRIMARY KEY (code_position)
);

-- 5. Tabela Fato: Performance Nacional
CREATE TABLE ft_performance_nacional (
    -- FKs
    code_club integer,
    code_national_team integer,
    code_age_group integer,
    code_position integer,
    
    -- Métricas de Performance e Físico
    avg_overall float,
    avg_sprint_speed float,
    avg_strength float,
    avg_heading_accuracy float,
    avg_wage_euro float,
    
    CONSTRAINT "pk_ft_performance_nacional" PRIMARY KEY (code_club, code_national_team, code_age_group, code_position),
    
    CONSTRAINT "fk_ft_club" FOREIGN KEY (code_club) 
        REFERENCES dim_clubs (code_club_team),
        
    CONSTRAINT "fk_ft_national_team" FOREIGN KEY (code_national_team) 
        REFERENCES dim_national_team (code_national_team),
        
    CONSTRAINT "fk_ft_age_group" FOREIGN KEY (code_age_group) 
        REFERENCES dim_age_group (code_age_group),
        
    CONSTRAINT "fk_ft_position" FOREIGN KEY (code_position) 
        REFERENCES dim_positions (code_position)
);