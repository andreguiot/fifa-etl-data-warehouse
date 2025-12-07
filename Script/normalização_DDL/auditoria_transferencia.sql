-- Tabela para auditar transferências de jogadores
CREATE TABLE transfer_logs (
    log_id SERIAL PRIMARY KEY,
    player_id INT,
    old_club_id INT,
    new_club_id INT,
    transfer_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    db_user VARCHAR(50) -- Grava qual usuário do banco fez a alteração
);

ALTER TABLE transfer_logs 
ADD CONSTRAINT fk_log_player 
FOREIGN KEY (player_id) REFERENCES players(id);