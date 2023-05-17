-- Consulta Gasto por orgao Superior
select b.cod, b.nome,  SUM(a.valor) soma
from pagamento a
inner join orgao b
on a.codorgsuperior = b.cod
Group BY b.cod
ORDER BY soma DESC

-- consulta Gasto por orgao pagador
SELECT  b.cod, b.nome, SUM(a.valor) total
FROM pagamento a
INNER JOIN orgao b
ON a.codorgpagador = b.cod
GROUP BY b.cod
ORDER BY total DESC

-- Pessoas por valor de viagens 
SELECT a.cpfViajante, a.nome, a.datainicio, 
       a.datafim, SUM(b.valor) total
FROM viagem a
INNER JOIN pagamento b ON a.idProcessoViagem = b.idProcessoViagem
-- WHERE (a.datainicio > '2019-01-01') AND (a.datafim < '2023-03-01')
GROUP BY a.cpfViajante, a.nome, a.datainicio, a.datafim
ORDER BY total DESC;


Select count(*) from passageiro
where cpfViajante = '***.000.000-**' -- and nome like 'zir%'
Order by nome

Select * from trecho

CALL relatorio_gasto_passagens();

SELECT SUM(valor) FROM pagamento

Select total_gasto

Select cpfviajante, nome, sum(total) as SOMA 
from pessoas_por_valor_viagens
where datainicio > '2023-01-01'
Group by cpfviajante, nome
ORDER BY SOMA DESC

Select cpfviajante, nome, sum(total) as SOMA 
from pessoas_por_valor_viagens
where datainicio > '2019-01-01' and datafim < '2019-12-31'
Group by cpfviajante, nome
ORDER BY SOMA DESC


Select cpfviajante, nome, sum(total) as SOMA 
from pessoas_por_valor_viagens
where datainicio > '2023-01-01'
Group by cpfviajante, nome
ORDER BY SOMA DESC

Select sum(total) as SOMA_Bolsa
from pessoas_por_valor_viagens
where datainicio > '2019-01-01' and datafim < '2019-12-31'


Select sum(total) as SOMA_Lalu 
from pessoas_por_valor_viagens
where datainicio > '2023-01-01'

SELECT
  (SELECT SUM(total) FROM pessoas_por_valor_viagens WHERE datainicio > '2018-01-01' AND datafim < '2018-12-31') AS SOMA_Bolsa,
  (SELECT SUM(total) FROM pessoas_por_valor_viagens WHERE datainicio > '2023-01-01') AS SOMA_Lalu;
