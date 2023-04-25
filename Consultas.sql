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
SELECT a.cpfViajante, a.nome, SUM(b.valor) total
FROM viagem a
INNER JOIN pagamento b ON a.idProcessoViagem = b.idProcessoViagem
GROUP BY a.cpfViajante, a.nome
ORDER BY total DESC
