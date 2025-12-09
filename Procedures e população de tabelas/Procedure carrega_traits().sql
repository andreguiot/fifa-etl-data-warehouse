CREATE OR REPLACE PROCEDURE carrega_traits()
AS $$
DECLARE
code_jogador integer;
desc_trait varchar(1000);
novo_desc varchar(1000);
virgula integer;
conta_trait integer;
code_skill integer;
conta_trait_player integer;
traits CURSOR FOR SELECT id, traits FROM jogadores
	WHERE traits IS NOT NULL;
BEGIN
	OPEN traits;
	FETCH traits INTO code_jogador, desc_trait;
	LOOP 
		virgula:= position (',' in desc_trait);
		loop 
			if virgula = 0 then
				exit;
			end if;
			novo_desc:= substring (desc_trait from 1 for virgula - 1);
		    select count(*) into conta_trait from traits where description = novo_desc;
			if conta_trait = 0 then
					insert into traits (description) values (novo_desc);
			end if;
			select code_trait into code_skill from traits  where description = novo_desc;
			insert into player_traits (code_player,code_trait) values (code_jogador,code_skill);
			desc_trait := trim(substring (desc_trait from virgula + 1 ));
			virgula:= position (',' in desc_trait);
		end loop;
		select count(*) into conta_trait from traits where description = desc_trait;
		if conta_trait = 0 then
					insert into traits (description) values (desc_trait);
		end if;
		select code_trait into code_skill from traits  where description = novo_desc;
		select count(*) into conta_trait_player from player_traits where code_trait = code_skill
				and code_player=code_jogador;
	   if conta_trait_player = 0 then
			insert into player_traits (code_player,code_trait) values (code_jogador,code_skill);
		end if;
		FETCH traits INTO code_jogador, desc_trait;
		EXIT WHEN NOT FOUND;
	END LOOP;
CLOSE traits;
END; 
$$ LANGUAGE plpgsql;


CALL carrega_traits();