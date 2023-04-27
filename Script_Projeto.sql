-- Dropa tabelas caso existam
DROP TABLE IF EXISTS orgao CASCADE;
DROP TABLE IF EXISTS viagem CASCADE;
DROP TABLE IF EXISTS pagamento CASCADE;
DROP TABLE IF EXISTS passageiro CASCADE;

-- Cria a tabela 'orgao'
--  ['cod', 'nome', 'cnpj', 'codpoder', 'nomepoder', 'codtipoadministracao', 'nometipoadministracao']
CREATE TABLE orgao (
  cod INT NOT NULL,
  nome VARCHAR(50) NOT NULL,
  CNPJ VARCHAR(18),
  codPoder INT,
  nomePoder VARCHAR(50),
  codTipoAdministracao INT,
  nomeTipoAdministracao VARCHAR(50),
  PRIMARY KEY (cod)
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
  codOrgSuperior INTEGER REFERENCES Orgao(cod),
  codOrgPagador INTEGER,
  codUnidGestoraPagadora INTEGER,
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
    REFERENCES passageiro(cpfViajante, nome)
);


-- Cria a tabela 'pagamento'
-- ['idprocessoviagem', 'numproposta', 'codorgsuperior', 'codorgpagador', 'codunidgestorapagadora', 
--  'tipopagamento', 'valor']
CREATE TABLE pagamento (
    id SERIAL PRIMARY KEY,
    idProcessoViagem INTEGER REFERENCES viagem(idProcessoViagem),
    numproposta VARCHAR(50),
    codOrgSuperior INTEGER REFERENCES Orgao(cod),
    codOrgPagador INTEGER,
    codUnidGestoraPagadora INTEGER,
    tipoPagamento VARCHAR(50),
    valor NUMERIC(15,2)
);


