CREATE OR REPLACE FUNCTION limit_player_positions()
RETURNS trigger AS $$
DECLARE
    total_positions integer;
BEGIN
    SELECT COUNT(*)
    INTO total_positions
    FROM position_player
    WHERE code_player = NEW.code_player;

    
    IF total_positions >= 3 THEN
        RAISE EXCEPTION 
            'O jogador % já possui 3 posições registradas. Não é permitido adicionar mais.',
            NEW.code_player;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_limit_player_positions
BEFORE INSERT ON position_player
FOR EACH ROW
EXECUTE FUNCTION limit_player_positions();