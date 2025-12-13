CREATE OR REPLACE FUNCTION fn_block_selection_without_nationality()
RETURNS TRIGGER AS $$
BEGIN
    
    IF NEW.code_national_team IS NOT NULL
       AND NEW.code_nationality IS NULL THEN
        RAISE EXCEPTION 
            'Jogador % não pode entrar em seleção sem nacionalidade.',
            NEW.id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trg_block_selection_without_nationality
BEFORE INSERT OR UPDATE ON players
FOR EACH ROW
EXECUTE FUNCTION fn_block_selection_without_nationality();