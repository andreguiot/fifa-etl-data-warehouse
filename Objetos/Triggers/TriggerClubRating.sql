/* -------------------------------------------------------------------------
   TRIGGER 2: Atualização Dinâmica do Rating do Clube
   Objetivo: Manter a coluna 'clubs.club_rating' sempre atualizada com a média do 
   'overall' dos jogadores atuais daquele time.
   -------------------------------------------------------------------------
*/


CREATE OR REPLACE FUNCTION fn_update_club_rating()
RETURNS TRIGGER AS $$
DECLARE
    v_club_id INTEGER;
    v_new_rating INTEGER;

BEGIN

    IF (TG_OP = 'DELETE') THEN
        v_club_id := OLD.code_club_team;
    ELSE
        v_club_id := NEW.code_club_team;
    END IF;

    IF v_club_id IS NOT NULL THEN
        
        SELECT ROUND(AVG(overall_rating)) 
        INTO v_new_rating
        FROM players
        WHERE code_club_team = v_club_id;

        UPDATE clubs
        SET club_rating = v_new_rating
        WHERE code_club_team = v_club_id;
        
    END IF;
    RETURN NULL; 
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER tg_calcula_forca_time
AFTER INSERT OR DELETE OR UPDATE OF overall_rating, code_club_team
ON players
FOR EACH ROW
EXECUTE FUNCTION fn_update_club_rating();