-- Dados fictícios para a atividade de Banco de Dados
-- Açaiteria do Vini, Baía Formosa/RN
-- Rodar o script-ddl.sql antes deste arquivo.
USE acaiteria_adaptacao;
START TRANSACTION;

-- Cenário 1: Organização da loja antes de começar a atender.
-- O Vini separou os tamanhos de açaí, cremes e adicionais do cardápio.
INSERT INTO Categoria (ID_categoria, Nome, Descricao, Ativa) VALUES
(1,'Açaís','Copos de açaí',1),
(2,'Cremes','Cremes de sabores variados',1),
(3,'Bebidas','Bebidas para acompanhar',1),
(4,'Combos','Promoções com mais de um item',1),
(5,'Sobremesas','Outras opções doces',1);

-- Os fornecedores e telefones abaixo são inventados para o exercício.
INSERT INTO Fornecedor (Id_fornecedor, Nome, Telefone, Cidade, Ativo) VALUES
(1,'Distribuidora Potiguar','84990001001','Natal',1),
(2,'Frutas do Litoral','84990001002','Baía Formosa',1),
(3,'Laticínios Nordeste','84990001003','Parnamirim',1),
(4,'Embalagens RN','84990001004','Natal',1),
(5,'Doces da Vila','84990001005','Canguaretama',1);

INSERT INTO Produto (Id_produto, Nome, Descricao, Preco, Estoque, ID_categoria, Id_fornecedor) VALUES
(1,'Açaí 300 ml','Copo pequeno',17.50,40,1,1),
(2,'Açaí 500 ml','Copo médio',24.00,35,1,1),
(3,'Creme de Ninho 300 ml','Creme de leite em pó',18.00,25,2,3),
(4,'Suco de acerola 300 ml','Suco natural',9.00,30,3,2),
(5,'Combo da casa','Combo promocional',29.00,20,4,4),
(6,'Sobremesa de morango','Sobremesa gelada',14.00,18,5,5);

INSERT INTO Adicional (ID_adicional, Nome, Descricao, Preco, Disponivel) VALUES
(1,'Granola','Porção de granola',3.00,1),
(2,'Banana','Banana cortada',2.00,1),
(3,'Leite em pó','Porção de leite em pó',3.50,1),
(4,'Leite condensado','Cobertura de leite condensado',3.00,1),
(5,'Granulado','Granulado de chocolate',2.50,1);

-- Cenário 2: Cadastros feitos para receber pedidos pelo WhatsApp.
-- Nomes, datas, endereços e telefones são fictícios.
INSERT INTO Cliente (Id_cliente, Nome, Telefone, Endereco, Data_nascimento) VALUES
(1,'José Silva','84988881001','Rua Principal, 12, Baía Formosa','1990-04-15'),
(2,'Maria Oliveira','84988881002','Rua das Flores, 45, Baía Formosa','1995-06-22'),
(3,'Ana Costa','84988881003','Rua do Porto, 8, Baía Formosa','2001-02-10'),
(4,'Pedro Almeida','84988881004','Rua da Praia, 21, Baía Formosa','1988-09-05'),
(5,'Lucas Santos','84988881005','Rua Nova, 33, Baía Formosa','1999-12-18');

-- Cenário 3: Movimento do primeiro dia, 09/11/2026.
-- José comprou dois copos diferentes. Maria pediu açaí com banana e leite em pó.
-- Lucas fez outro pedido mais tarde, que ainda está em preparo.
INSERT INTO Pedido (Id_pedido, Id_cliente, Data_pedido, Status_pedido, Valor_total, Canal) VALUES
(1,1,'2026-11-09 14:10:00','Entregue',34.50,'WhatsApp'),
(2,2,'2026-11-09 14:35:00','Entregue',29.50,'WhatsApp'),
(3,3,'2026-11-09 15:05:00','Entregue',23.50,'WhatsApp'),
(4,4,'2026-11-09 15:40:00','Entregue',34.50,'WhatsApp'),
(5,5,'2026-11-09 16:15:00','Entregue',19.50,'WhatsApp'),
(6,5,'2026-11-09 17:20:00','Em preparo',9.00,'WhatsApp');

-- Os preços ficam salvos nos itens para não mudar o valor de uma venda antiga.
INSERT INTO Item_pedido (Id_item, Id_pedido, Id_produto, Quantidade, Preco_unitario) VALUES
(1,1,1,1,17.50),
(2,1,4,1,9.00),
(3,2,2,1,24.00),
(4,3,3,1,18.00),
(5,4,5,1,29.00),
(6,5,6,1,14.00),
(7,6,4,1,9.00);

-- Cenário 4: Complementos escolhidos nos pedidos.
-- O suco não leva adicional. O pedido 6 também não tem adicional.
INSERT INTO Item_adicional (Id_item_adicional, Id_item, ID_adicional, Quantidade, Preco_unitario) VALUES
(1,1,1,1,3.00),
(2,1,2,1,2.00),
(3,1,4,1,3.00),
(4,3,3,1,3.50),
(5,3,2,1,2.00),
(6,4,4,1,3.00),
(7,4,5,1,2.50),
(8,5,1,1,3.00),
(9,5,5,1,2.50),
(10,6,3,1,3.50),
(11,6,2,1,2.00);

-- Cenário 5: Pagamentos das cinco vendas concluídas.
-- O pedido 6 continua em preparo e ainda não foi pago.
INSERT INTO Pagamento (Id_pagamento, Id_pedido, Forma_pagamento, Valor_pago, Data_pagamento, Status_pagamento) VALUES
(1,1,'Pix',34.50,'2026-11-09 14:25:00','Confirmado'),
(2,2,'Dinheiro',29.50,'2026-11-09 14:50:00','Confirmado'),
(3,3,'Cartao',23.50,'2026-11-09 15:20:00','Confirmado'),
(4,4,'Pix',34.50,'2026-11-09 15:55:00','Confirmado'),
(5,5,'Dinheiro',19.50,'2026-11-09 16:30:00','Confirmado');

-- Estoque baixado somente dos itens das vendas entregues.
UPDATE Produto SET Estoque = Estoque - 1 WHERE Id_produto IN (1,2,3,4,5,6);
COMMIT;

-- Conferência 1: quantidade de registros por tabela (mínimo de 5).
SELECT 'Cliente' AS Tabela, COUNT(*) AS Registros FROM Cliente
UNION ALL SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL SELECT 'Fornecedor', COUNT(*) FROM Fornecedor
UNION ALL SELECT 'Produto', COUNT(*) FROM Produto
UNION ALL SELECT 'Adicional', COUNT(*) FROM Adicional
UNION ALL SELECT 'Pedido', COUNT(*) FROM Pedido
UNION ALL SELECT 'Item_pedido', COUNT(*) FROM Item_pedido
UNION ALL SELECT 'Item_adicional', COUNT(*) FROM Item_adicional
UNION ALL SELECT 'Pagamento', COUNT(*) FROM Pagamento;

-- Conferência 2: compara o total do pedido com a soma de itens e adicionais.
SELECT p.Id_pedido, p.Status_pedido, p.Valor_total,
       COALESCE(prod.total_produtos,0) + COALESCE(ad.total_adicionais,0) AS Total_calculado
FROM Pedido p
LEFT JOIN (
 SELECT Id_pedido, SUM(Quantidade * Preco_unitario) AS total_produtos
 FROM Item_pedido GROUP BY Id_pedido
) prod ON prod.Id_pedido = p.Id_pedido
LEFT JOIN (
 SELECT ip.Id_pedido, SUM(ia.Quantidade * ia.Preco_unitario) AS total_adicionais
 FROM Item_adicional ia
 JOIN Item_pedido ip ON ip.Id_item = ia.Id_item
 GROUP BY ip.Id_pedido
) ad ON ad.Id_pedido = p.Id_pedido
ORDER BY p.Id_pedido;
