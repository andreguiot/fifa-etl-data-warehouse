CREATE OR REPLACE PROCEDURE carrega_positions()
AS $$
DECLARE
code_jogador integer;
desc_posicao varchar(25);
novo_desc varchar(25);
virgula integer;
conta_posicao integer;
code_posicao integer;
conta_posicao_player integer;
posicao CURSOR FOR SELECT id, positions FROM jogadores;
BEGIN
	OPEN posicao;
	FETCH posicao INTO code_jogador, desc_posicao;
	LOOP 
		virgula:= position (',' in desc_posicao);
		loop 
			if virgula = 0 then
				exit;
			end if;
			novo_desc:= substring (desc_posicao from 1 for virgula - 1);
		    select count(*) into conta_posicao from positions where description = novo_desc;
			if conta_posicao = 0 then
					insert into positions (description) values (novo_desc);
			end if;
			select code_position into code_posicao from positions  where description = novo_desc;
			insert into position_player (code_player,code_position) values (code_jogador,code_posicao);
			desc_posicao := trim(substring (desc_posicao from virgula + 1 ));
			virgula:= position (',' in desc_posicao);
		end loop;
		select count(*) into conta_posicao from positions where description = desc_posicao;
		if conta_posicao = 0 then
					insert into positions (description) values (desc_posicao);
		end if;
		select code_position into code_posicao from positions  where description = novo_desc;
		select count(*) into conta_posicao_player from position_player where code_position = code_posicao
				and code_player=code_jogador;
	   if conta_posicao_player = 0 then
			insert into position_player (code_player,code_position) values (code_jogador,code_posicao);
		end if;
		FETCH posicao INTO code_jogador, desc_posicao;
		EXIT WHEN NOT FOUND;
	END LOOP;
CLOSE posicao;
END; 
$$ LANGUAGE plpgsql;

CALL carrega_positions();