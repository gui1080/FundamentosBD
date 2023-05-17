-- Cria View
CREATE OR REPLACE VIEW pessoas_por_valor_viagens AS
SELECT a.cpfViajante, a.nome, a.datainicio, a.datafim, SUM(b.valor) AS total
FROM viagem a
INNER JOIN pagamento b ON a.idProcessoViagem = b.idProcessoViagem
GROUP BY a.cpfViajante, a.nome, a.datainicio, a.datafim
ORDER BY total DESC;


-- Cria Trigger para Integridade do SeqTrecho
CREATE OR REPLACE FUNCTION check_sequencial() RETURNS TRIGGER AS $$
 BEGIN
    -- Verifica se o sequencial do novo trecho é o próximo da sequência
     IF NEW.seqTrecho <> (((SELECT COALESCE(MAX(seqTrecho), 0) FROM trecho WHERE idProcessoViagem = NEW.idProcessoViagem) + 1)) THEN
       RAISE EXCEPTION 'O sequencial do novo trecho não segue a sequência correta!';
    END IF;
    
    RETURN NEW;
 END;

$$ LANGUAGE plpgsql;
CREATE OR REPLACE TRIGGER sequencial_trechos_viagem
BEFORE INSERT OR UPDATE ON trecho
FOR EACH ROW
EXECUTE FUNCTION check_sequencial();


-- Cria Procedimento que gera relatório de Gastos
CREATE OR REPLACE PROCEDURE relatorio_gasto_passagens()
LANGUAGE plpgsql
AS $$
DECLARE
  total_gasto VARCHAR(20);
  total_gasto_sigilo VARCHAR(20);
BEGIN
  -- Executar a consulta SQL para obter o valor total gasto em passagens
  SET lc_monetary = 'pt_BR';
  SELECT  to_char(SUM(valor), 'FM999,999,999,999.99') 
  INTO total_gasto 
  FROM pagamento;
  
  SELECT to_char(SUM(valor), 'FM999,999,999,999.99') 
  INTO total_gasto_sigilo 
  FROM pagamento 
  WHERE codorgpagador <= 0;
  
  -- Exibir o relatório
  RAISE NOTICE 'Valor total gasto em passagens: R$%', total_gasto;
  RAISE NOTICE 'Valor total gasto em sigilo   : R$%', total_gasto_sigilo;
END;
$$;
