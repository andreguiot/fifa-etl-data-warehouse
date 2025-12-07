/* -------------------------------------------------------------------------
   TRIGGER: Auditoria de Transferências
   Objetivo: Monitorar a tabela 'players'. Sempre que o 'code_club_team' mudar,
   gravar um registro na tabela 'transfer_logs' com os dados antigos e novos.
   -------------------------------------------------------------------------
*/

CREATE OR REPLACE FUNCTION fn_audit_transfer_logic()
RETURNS TRIGGER AS $$
BEGIN
    IF (OLD.code_club_team IS DISTINCT FROM NEW.code_club_team) THEN
        INSERT INTO transfer_logs (
            player_id, 
            old_club_id, 
            new_club_id, 
            db_user
        )
        VALUES (
            OLD.id, 
            OLD.code_club_team, 
            NEW.code_club_team, 
            CURRENT_USER
        );
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditoria_transferencia
AFTER UPDATE ON players
FOR EACH ROW
EXECUTE FUNCTION fn_audit_transfer_logic();

-- Em aguardo para a atualização do DDL para adicionar a tabela de auditoria transfer_logs