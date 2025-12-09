CREATE OR REPLACE PROCEDURE carrega_tags()
AS $$
DECLARE
code_jogador integer;
desc_tag varchar(1000);
novo_desc varchar(1000);
virgula integer;
conta_tag integer;
code_tralha integer;
conta_tag_player integer;
tags CURSOR FOR SELECT id, tags FROM jogadores
	WHERE tags IS NOT NULL;
BEGIN
	OPEN tags;
	FETCH tags INTO code_jogador, desc_tag;
	LOOP 
		virgula:= position (',' in desc_tag);
		loop 
			if virgula = 0 then
				exit;
			end if;
			novo_desc:= substring (desc_tag from 1 for virgula - 1);
		    select count(*) into conta_tag from tags where description = novo_desc;
			if conta_tag = 0 then
					insert into tags (description) values (novo_desc);
			end if;
			select code_tag into code_tralha from tags  where description = novo_desc;
			insert into player_tags (code_player,code_tag) values (code_jogador,code_tralha);
			desc_tag := trim(substring (desc_tag from virgula + 1 ));
			virgula:= position (',' in desc_tag);
		end loop;
		select count(*) into conta_tag from tags where description = desc_tag;
		if conta_tag = 0 then
					insert into tags (description) values (desc_tag);
		end if;
		select code_tag into code_tralha from tags  where description = novo_desc;
		select count(*) into conta_tag_player from player_tags where code_tag = code_tralha
				and code_player=code_jogador;
	   if conta_tag_player = 0 then
			insert into player_tags (code_player,code_tag) values (code_jogador,code_tralha);
		end if;
		FETCH tags INTO code_jogador, desc_tag;
		EXIT WHEN NOT FOUND;
	END LOOP;
CLOSE tags;
END; 
$$ LANGUAGE plpgsql;


CALL carrega_tags();