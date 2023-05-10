-- Dropa tabelas caso existam
DROP TABLE IF EXISTS pais CASCADE;
DROP TABLE IF EXISTS uf CASCADE;
DROP TABLE IF EXISTS cidade CASCADE;
DROP TABLE IF EXISTS poder CASCADE;
DROP TABLE IF EXISTS tipo_administracao CASCADE;
DROP TABLE IF EXISTS orgao CASCADE;
DROP TABLE IF EXISTS viagem CASCADE;
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS passageiro CASCADE;
DROP TABLE IF EXISTS trecho CASCADE;

CREATE TABLE poder (
  id INT NOT NULL,
  nomePoder VARCHAR(50),
  PRIMARY KEY (id)
);

CREATE TABLE uf (
  id INT NOT NULL,
  nome VARCHAR(50),
  pais INT,
  PRIMARY KEY (id),
  CONSTRAINT fk_pais
    FOREIGN KEY (pais)
    REFERENCES pais(id)
);

CREATE TABLE cidade (
  id INT NOT NULL,
  nome VARCHAR(50),
  internacional INT,
  nacional INT,
  PRIMARY KEY (id),
  CONSTRAINT fk_internacional 
    FOREIGN KEY (internacional)
    REFERENCES pais(id),
  CONSTRAINT fk_nacional
    FOREIGN KEY (nacional)
    REFERENCES uf(id)
);

-- Cria a tabela 'poder'
-- ['codpoder', 'nomepoder']
CREATE TABLE poder (
  codPoder INT NOT NULL,
  nomePoder VARCHAR(50),
  PRIMARY KEY (codPoder)
);

-- Cria a tabela 'tipo_administracao'
-- ['codtipoadministracao', 'nometipoadministracao']
CREATE TABLE tipo_administracao (
  codTipoAdministracao INT NOT NULL,
  nomeTipoAdministracao VARCHAR(50),
  PRIMARY KEY (codTipoAdministracao)
);

-- Cria a tabela 'orgao'
--  ['cod', 'nome', 'cnpj', 'codPoder', 'codtipoadministracao']
CREATE TABLE orgao (
  cod INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  CNPJ VARCHAR(18),
  codPoder INT,
  codTipoAdministracao INT,
  PRIMARY KEY (cod),
  CONSTRAINT fk_poder 
    FOREIGN KEY (codPoder)
    REFERENCES poder(codPoder),
  CONSTRAINT fk_adm 
    FOREIGN KEY (codTipoAdministracao)
    REFERENCES tipo_administracao(codTipoAdministracao)
);

-- Cria a tabela 'passageiro'
-- a partir de campos originalmente no .csv de "viagens"
-- [ 'cpfviajante', 'nome', 'cargo', 'funcao', 'descricaofuncao']
-- 1 passageiro pode ir a 0 ou n viagens
CREATE TABLE passageiro (
  cpfViajante VARCHAR(14) NOT NULL,
  nome VARCHAR(150) NOT NULL, 
  cargo VARCHAR(150), 
  funcao VARCHAR(150), 
  descricaoFuncao VARCHAR(150),
  PRIMARY KEY (cpfViajante, nome)
);


-- Cria tabela Viagem
-- [ 'idProcessoViagem', 'numproposta', 'situacao', 'viagemurgente', 'justificativaurgencia', 
--   'codorgsuperior', 'codorgpagador', 'cpfviajante', 
--   'nome', 'cargo', 'funcao', 'descricaofuncao', 'datainicio', 
--   'datafim', 'destino', 'motivo', 'valordiarias', 'valorpassagens', 
-- ]
-- [0, 1, 2, 3, 4, 5, 7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19]
CREATE TABLE viagem (
  idProcessoViagem INT NOT NULL,
  numproposta VARCHAR(50),
  situacao VARCHAR(18),
  viagemUrgente BOOLEAN,
  justificativaUrgencia TEXT,
  codOrgSuperior INTEGER,
  codOrgPagador INTEGER,
  cpfViajante VARCHAR(14) NOT NULL,
  nome VARCHAR(150) NOT NULL, 
  dataInicio DATE, 
  dataFim DATE, 
  destinos TEXT,
  motivo TEXT, 
  valorDiarias NUMERIC(15,2),
  valorPassagens NUMERIC(15,2), 
  PRIMARY KEY (idProcessoViagem),
  CONSTRAINT fk_passageiro 
    FOREIGN KEY (cpfViajante, nome)
    REFERENCES passageiro(cpfViajante, nome),
  CONSTRAINT fk_orgao_sup
    FOREIGN KEY (codOrgSuperior)
    REFERENCES orgao(cod),
  CONSTRAINT fk_orgao_pag
    FOREIGN KEY (codOrgPagador)
    REFERENCES orgao(cod)

);

-- Cria Tabela Trecho
-- campos = ['idprocessoviagem', 'seqtrecho', 'dataorigem', 'paisorigem', 'uforigem', 'cidadeorigem',
--           'datadestino', 'paisdestino', 'ufdestino', 'cidadedestino',
--           'meiotrasnporte', 'numdiarias', 'missao' 
-- ]
-- cols =   [0, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
CREATE TABLE trecho (
  idProcessoViagem INT NOT NULL,
  seqTrecho INT NOT NULL,
  dataOrigem DATE, 
  cidadeOrigem INT, 
  dataDestino DATE, 
  cidadeDestino INT, 
  meioTrasnporte VARCHAR(50),
  numDiarias NUMERIC(5,2),
  missao BOOLEAN,
  PRIMARY KEY (idProcessoViagem, seqTrecho),
  CONSTRAINT fk_viagem
    FOREIGN KEY (idProcessoViagem)
    REFERENCES viagem(idProcessoViagem),
  CONSTRAINT fk_origem
    FOREIGN KEY (cidadeOrigem)
    REFERENCES cidade(id),
  CONSTRAINT fk_destino
    FOREIGN KEY (cidadeDestino)
    REFERENCES cidade(id)
);

-- Cria a tabela 'pagamento'
-- ['idprocessoviagem', 'numproposta', 'codorgsuperior', 'codorgpagador', 
--  'tipopagamento', 'valor']
CREATE TABLE pagamento (
  id SERIAL PRIMARY KEY,
  idProcessoViagem INTEGER,
  numproposta VARCHAR(50),
  codOrgSuperior INTEGER,
  codOrgPagador INTEGER,
  tipoPagamento VARCHAR(50),
  valor NUMERIC(15,2),
  CONSTRAINT fk_viagem
    FOREIGN KEY (idProcessoViagem)
    REFERENCES viagem(idProcessoViagem),
  CONSTRAINT fk_orgao_sup
    FOREIGN KEY (codOrgSuperior)
    REFERENCES orgao(cod),  
  CONSTRAINT fk_orgao_pag
    FOREIGN KEY (codOrgPagador)
    REFERENCES orgao(cod)  
);

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

CREATE TRIGGER sequencial_trechos_viagem
BEFORE INSERT OR UPDATE ON trecho
FOR EACH ROW
EXECUTE FUNCTION check_sequencial();



