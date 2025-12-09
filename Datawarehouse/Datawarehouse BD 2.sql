CREATE TABLE valor_overall(
	overall_value integer,
	code_club integer,
	code_national_team integer,
	code_age_group integer,
	code_position integer,
	CONSTRAINT "pk_valor_contrato" PRIMARY KEY (code_club, code_national_team, code_age_group, code_position),
	CONSTRAINT "fk_valor_contrato_1" FOREIGN KEY (code_club) REFERENCING clubs(code_club),
	CONSTRAINT "fk_valor_contrato_2" FOREIGN KEY (code_national_team) REFERENCING national_team(code_national_team),
	CONSTRAINT "fk_valor_contrato_3" FOREIGN KEY (code_age_group) REFERENCING age_group(code_age_group),
	CONSTRAINT "fk_valor_contrato_4" FOREIGN KEY (code_position) REFERENCING position(code_position),
)


CREATE OR REPLACE TABLE age_group(
	code_age_group integer,
	description varchar(30),
	CONSTRAINT "pk_age_group" PRIMARY KEY (code_age_group)
)


CREATE TABLE national_team(
	code_national_team serial,
	description varchar(40),
	national_rating integer,
	CONSTRAINT "pk_national_team" PRIMARY KEY(code_national_team)
)



CREATE TABLE clubs(
	code_club_team serial,
	description varchar(40),
	club_rating integer,
	CONSTRAINT "pk_clubs" PRIMARY KEY(code_club_team)
)



CREATE TABLE positions(
	code_position serial,
	description varchar(5),
	CONSTRAINT "pk_positions" PRIMARY KEY(code_position)
)


INSERT INTO age_group (code_age_group, description) VALUES(1, "Menor que 20 anos");
INSERT INTO age_group (code_age_group, description) VALUES(2, "Entre 20 e 24 anos");
INSERT INTO age_group (code_age_group, description) VALUES(3, "Entre 25 e 28 anos");
INSERT INTO age_group (code_age_group, description) VALUES(4, "Entre 28 e 32 anos");
INSERT INTO age_group (code_age_group, description) VALUES(5, "maior que 32 anos");