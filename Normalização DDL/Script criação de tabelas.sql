CREATE TABLE jogadores(
	id integer,
	name varchar(50),
	full_name varchar(100),
	birth_date date,
	age integer,
	height_cm float,
	weight_kgs float,
        positions varchar(30),
	nationality varchar(70),
	overall_rating integer,
	potential integer,
	value_euro float,
	wage_euro float,
        preferred_foot varchar(10),
	international_reputation integer,
	weak_foot integer,
	skill_moves integer,
	work_rate varchar(20),  
	body_type varchar(50),
	release_clause_euro float,
	club_team varchar(80),
	club_rating integer,
	club_position varchar(50),
	club_jersey_number integer,
	club_join_date date,
	contract_end_year varchar(100),
	national_team varchar(80),
	national_rating integer,
	national_team_position varchar(50),
	national_jersey_number integer,
	crossing integer,
	finishing integer,
	heading_accuracy integer,
	short_passing integer,
	volley integer,
	dribbling integer,
	curve integer,
	freekick_accuracy integer,
	long_passing integer,
	ball_control integer,
	acceleration integer,
	sprint_speed integer,
	agility integer,
	reactions integer,
	balance integer,
	shot_power integer,
	jumping integer,
	stamina integer,
	strength integer,
	long_shots integer,
	agression integer,
	interceptation integer,
	positioning integer,
	vision integer,
	penalties integer,
	composure integer,
	marking integer,
	standing_tackle integer,
	sliding_tackle integer,
	gk_diving integer,
	gk_handing integer,
	gk_kiking integer,
	gk_positioning integer,
	gk_reflexes integer,
	tags varchar(1000),
	traits varchar(1000),
	ls varchar(10),
	st varchar(10),
	rs varchar(10),
	lw varchar(10),
	lf varchar(10),
	cf varchar(10),
	rf varchar(10),
	rw varchar(10),
	lam varchar(10),
	cam varchar(10),
	ram varchar(10),
	lm varchar(10),
	lcm varchar(10),
	cm varchar(10),
	rcm varchar(10),
	rm varchar(10),
	lwb varchar(10),
	ldm varchar(10),
	cdm varchar(10),
	rdm varchar(10),
	rwb varchar(10),
	lb varchar(10),
	lcb varchar(10),
	cb varchar(10),
	rcb varchar(10),
	rb varchar(10),
	CONSTRAINT "pk_jogadores" PRIMARY KEY(id)
)



CREATE TABLE players(
	id integer,
	name varchar(50),
	full_name varchar(100),
	birth_date date,
	age integer,
	height_cm float,
	weight_kgs float,
	code_nationality integer,
	overall_rating integer,
	potential integer,
	value_euro float,
	wage_euro float,
        preferred_foot varchar(10),
	international_reputation integer,
	weak_foot integer,
	skill_moves integer,
	work_rate_defense varchar(10),  
	work_rate_attack varchar(10),
	body_type varchar(50),
	release_clause_euro float,
	code_club_team integer,
	club_position varchar(50),
	club_jersey_number integer,
	club_join_date date,
	contract_end_year varchar(100),
	code_national_team integer,
	national_team_position varchar(50),
	national_jersey_number integer,
	crossing integer,
	finishing integer,
	heading_accuracy integer,
	short_passing integer,
	volley integer,
	dribbling integer,
	curve integer,
	freekick_accuracy integer,
	long_passing integer,
	ball_control integer,
	acceleration integer,
	sprint_speed integer,
	agility integer,
	reactions integer,
	balance integer,
	shot_power integer,
	jumping integer,
	stamina integer,
	strength integer,
	long_shots integer,
	agression integer,
	interceptation integer,
	positioning integer,
	vision integer,
	penalties integer,
	composure integer,
	marking integer,
	standing_tackle integer,
	sliding_tackle integer,
	gk_diving integer,
	gk_handing integer,
	gk_kiking integer,
	gk_positioning integer,
	gk_reflexes integer,
	ls varchar(10),
	st varchar(10),
	rs varchar(10),
	lw varchar(10),
	lf varchar(10),
	cf varchar(10),
	rf varchar(10),
	rw varchar(10),
	lam varchar(10),
	cam varchar(10),
	ram varchar(10),
	lm varchar(10),
	lcm varchar(10),
	cm varchar(10),
	rcm varchar(10),
	rm varchar(10),
	lwb varchar(10),
	ldm varchar(10),
	cdm varchar(10),
	rdm varchar(10),
	rwb varchar(10),
	lb varchar(10),
	lcb varchar(10),
	cb varchar(10),
	rcb varchar(10),
	rb varchar(10),
	CONSTRAINT "pk_players" PRIMARY KEY(id)
)



CREATE TABLE nationality (
	code_nationality serial,
	description varchar(40),
	CONSTRAINT "pk_nationality" PRIMARY KEY(code_nationality)
)



CREATE TABLE positions(
	code_position serial,
	description varchar(5),
	CONSTRAINT "pk_positions" PRIMARY KEY(code_position)
)


CREATE TABLE position_player(
	code_player integer,
	code_position integer,
	CONSTRAINT "pk_position_player" PRIMARY KEY(code_player, code_position),
	CONSTRAINT "fk_position_player_1" FOREIGN KEY(code_player) REFERENCES players(id),
	CONSTRAINT "fk_position_player_2" FOREIGN KEY(code_position) REFERENCES positions(code_position)
)


CREATE TABLE clubs(
	code_club_team serial,
	description varchar(40),
	club_rating integer,
	CONSTRAINT "pk_clubs" PRIMARY KEY(code_club_team)
)


ALTER TABLE players ADD CONSTRAINT "fk_players_1" FOREIGN KEY(code_club_team) REFERENCES clubs(code_club_team)


CREATE TABLE national_team(
	code_national_team serial,
	description varchar(40),
	national_rating integer,
	CONSTRAINT "pk_national_team" PRIMARY KEY(code_national_team)
)

ALTER TABLE players ADD CONSTRAINT "fk_players_2" FOREIGN KEY(code_national_team) REFERENCES national_team(code_national_team)

CREATE TABLE tags(
	code_tag serial,
	description varchar(80),
	CONSTRAINT "pk_tags" PRIMARY KEY(code_tag)
)


CREATE TABLE player_tags(
	code_player integer,
	code_tag integer,
	CONSTRAINT "pk_player_tags" PRIMARY KEY(code_player, code_tag),
	CONSTRAINT "fk_player_tags_1" FOREIGN KEY(code_player) REFERENCES players(id),
	CONSTRAINT "fk_player_tags_2" FOREIGN KEY(code_tag) REFERENCES tags(code_tag)
)



CREATE TABLE traits(
	code_trait serial,
	description varchar(80),
	CONSTRAINT "pk_traits" PRIMARY KEY(code_trait)
)


CREATE TABLE player_traits(
	code_player integer,
	code_trait integer,
	CONSTRAINT "pk_player_traits" PRIMARY KEY(code_player, code_trait),
	CONSTRAINT "fk_player_traits_1" FOREIGN KEY(code_player) REFERENCES players(id),
	CONSTRAINT "fk_player_traits_2" FOREIGN KEY(code_trait) REFERENCES traits(code_trait)
)
