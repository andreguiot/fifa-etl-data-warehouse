# ⚽ FIFA Data Engineering Project: ETL & Data Warehouse

Este repositório contém a implementação completa de um ambiente de
Engenharia de Dados baseado no dataset do jogo FIFA presente em : https://www.kaggle.com/datasets/shazad007/fifa-players-complete-stats/data. 
O projeto abrange desde a modelagem de banco de dados transacional, normalização, criação
de um Data Warehouse (OLAP), pipeline de ETL com Pentaho Data
Integration (PDI) e automações via Triggers SQL.

## 🎯 Objetivos do Negócio

O projeto foi desenhado para responder a duas perguntas estratégicas que
exigiam cruzamento de dados e agregações complexas:

Viés Continental (Físico vs. Mental): Existe uma tendência sistemática
no FIFA de atribuir atributos físicos superiores a jogadores de nações
Africanas/Sul-americanas e atributos mentais superiores a Europeus?

Análise Moneyball (Idade vs. Valor): Qual faixa etária oferece o melhor
custo-benefício (Performance Técnica vs. Valor de Mercado)?

## 🏗 Arquitetura e Modelagem

### 1. Fonte de Dados (OLTP)

A base original (fifa) foi normalizada para evitar redundâncias.
Principais tabelas:

players: Dados cadastrais e atributos.

clubs, national_team, positions, nationality.

### 2. Data Warehouse (OLAP) - Star Schema

O banco analítico (fifa_dw) foi modelado em esquema estrela para alta
performance de leitura:

Tabela Fato: ft_performance_nacional

Granularidade: Média agregada por Clube, Seleção, Posição e Faixa
Etária.

Métricas: avg_overall, avg_sprint_speed, avg_strength, avg_vision,
avg_wage, avg_market_value.

Dimensões:

dim_clubs: Dados dos clubes.

dim_positions: Posições táticas.

dim_national_team: Enriquecida com a coluna continent (Dado não
existente na origem).

dim_age_group: Dimensão estática baseada em regras de negócio (Jovem,
Auge, Veterano, etc.).

## ⚙️ Pipeline de ETL (Pentaho)

O processo de Extração, Transformação e Carga (ETL) foi orquestrado via
Pentaho Jobs (job_carga_completa.kjb), garantindo a execução sequencial
correta (Dimensões → Fato).

### Principais Transformações (.ktr)

#### 🌍 1. Enriquecimento Geográfico (etl_dim_selecoes)

Desafio: A base original não possuía a informação de Continentes.

Limpeza: Filtro SQL (WHERE IN) para remover clubes cadastrados
erroneamente como seleções.

Transformação: Utilização do step Value Mapper para mapear países para
seus continentes (ex: Brazil → South America, Germany → Europe).

#### 📊 2. Regra de Negócio de Idade (etl_dim_faixa_etaria)

Estratégia: Em vez de ler do banco, utilizamos um Data Grid para gerar
regras estáticas de negócio dentro do ETL, garantindo controle de versão
das regras de classificação.

ID 1: Jovem Promessa (\< 20 anos)

ID 3: Auge da Carreira (24-28 anos)

ID 5: Veterano (\> 32 anos)

#### 🚀 3. Carga da Fato (etl_fato)

Lógica: Agregação de dados usando Memory Group By.

Classificação: Step Number Range converte a idade contínua (ex: 22) para
o ID da dimensão (ex: 2).

Tratamento de Tipos: Uso de Select Values para converter tipos de dados
e evitar erros de inserção no PostgreSQL.

Lookups: Substituição de nomes (Strings) por Surrogate Keys (Integers)
via Database Lookup.

## 🤖 Automações no Banco (Triggers & Views)

Além do DW, implementamos automações no banco transacional para simular
um ambiente vivo:

Trigger de Rating Dinâmico (tg_calcula_forca_time):

Sempre que um jogador é inserido/atualizado, recalcula automaticamente a
média (club_rating) do time na tabela clubs.

Auditoria de Transferências (tg_auditoria_transferencia):

Monitora mudanças de time e grava log histórico na tabela transfer_logs
(Quem saiu, de onde, para onde e quando).

View Materializada (vw_complete_players):

Facilita consultas rápidas consolidando Jogador, Nacionalidade e
Posições em uma única visão desnormalizada.

## 📈 Insights Obtidos (Data Storytelling)

Com o DW populado, as queries de negócio revelaram:

A "Superpotência" Sul-Americana: A América do Sul lidera tanto em
atributos físicos (Força/Velocidade) quanto mentais (Visão de Jogo),
superando a Europa.

O Estereótipo Europeu: A Europa possui a menor média de velocidade entre
as potências, compensando com atributos táticos.

Estratégia Moneyball: Jogadores Veteranos (\>32 anos) entregam
performance técnica (Overall \~76.8) estatisticamente idêntica aos
jogadores no auge, custando 48% menos em valor de mercado.

## 🚀 Como Executar

### Pré-requisitos

PostgreSQL 12+

Pentaho Data Integration (PDI/Spoon) 9+

Java 8+

### Passo a Passo

Banco de Dados:

Crie dois bancos no Postgres: fifa (Origem) e fifa_dw (Destino).

Rode os scripts SQL da pasta /sql para criar as estruturas.

Pentaho:

Abra o PDI (Spoon).

Configure as conexões FIFA-ETL (Origem) e FIFA_DW_DESTINO (Destino) no
arquivo shared.xml ou nas transformações.

Abra o Job principal: job_carga_completa.kjb.

Execução:

Execute o Job. Ele carregará as dimensões em paralelo e, em seguida, a
tabela fato.

## 👥 Autores

Trabalho desenvolvido para a disciplina de Banco de Dados 2 (P2).

André Guiot

Diego Rey

Romário Eusébio

Rodrigo Lustosa
