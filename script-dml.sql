-- AÇAITERIA DO VINI | DML | Narrativa fictícia de operação
-- Execute script-ddl.sql primeiro. Dados organizados em ordem cronológica.
USE acaiteria_adaptacao;
START TRANSACTION;

-- Cenário 1: Preparação do catálogo em 08/11/2026.
-- Antes da inauguração, a equipe cadastrou categorias, fornecedores, estoque e adicionais.
INSERT INTO Categoria (ID_categoria,Nome,Descricao,Ativa) VALUES
(1,'Açaís','Copos de açaí em diferentes tamanhos',1),
(2,'Cremes','Cremes gelados da casa',1),
(3,'Bebidas','Bebidas para acompanhar',1),
(4,'Combos','Combinações promocionais',1),
(5,'Sobremesas','Opções doces da loja',1);
INSERT INTO Fornecedor (Id_fornecedor,Nome,Telefone,Cidade,Ativo) VALUES
(1,'Distribuidora Potiguar','84990001001','Natal',1),
(2,'Frutas do Litoral','84990001002','Baía Formosa',1),
(3,'Laticínios Nordeste','84990001003','Parnamirim',1),
(4,'Embalagens RN','84990001004','Natal',1),
(5,'Doces da Vila','84990001005','Canguaretama',1);
INSERT INTO Produto (Id_produto,Nome,Descricao,Preco,Estoque,ID_categoria,Id_fornecedor) VALUES
(1,'Açaí 300 ml','Copo de açaí tradicional',17.50,40,1,1),
(2,'Açaí 500 ml','Copo de açaí tradicional',24.00,35,1,1),
(3,'Creme de Ninho 300 ml','Creme gelado de leite em pó',18.00,25,2,3),
(4,'Suco de acerola 300 ml','Suco natural de acerola',9.00,30,3,2),
(5,'Combo da casa','Açaí com acompanhamento',29.00,20,4,4),
(6,'Sobremesa de morango','Doce gelado de morango',14.00,18,5,5);
INSERT INTO Adicional (ID_adicional,Nome,Descricao,Preco,Disponivel) VALUES
(1,'Granola','Porção de granola',3.00,1),
(2,'Banana','Banana em rodelas',2.00,1),
(3,'Leite em pó','Porção de leite em pó',3.50,1),
(4,'Leite condensado','Porção de leite condensado',3.00,1),
(5,'Granulado','Cobertura de chocolate granulado',2.50,1);

-- Cenário 2: Chegada dos primeiros clientes em 09/11/2026.
-- Cinco moradores se cadastraram para pedir pelo WhatsApp na inauguração.
INSERT INTO Cliente (Id_cliente,Nome,Telefone,Endereco,Data_nascimento) VALUES
(1,'José Silva','84988881001','Rua Principal, 12, Baía Formosa','1990-04-15'),
(2,'Maria Oliveira','84988881002','Rua das Flores, 45, Baía Formosa','1995-06-22'),
(3,'Ana Costa','84988881003','Rua do Porto, 8, Baía Formosa','2001-02-10'),
(4,'Pedro Almeida','84988881004','Rua da Praia, 21, Baía Formosa','1988-09-05'),
(5,'Lucas Santos','84988881005','Rua Nova, 33, Baía Formosa','1999-12-18');

-- Cenário 3: Pedidos recebidos ao longo da tarde.
-- Os preços unitários ficam gravados para preservar o valor histórico da venda.
INSERT INTO Pedido (Id_pedido,Id_cliente,Data_pedido,Status_pedido,Valor_total,Canal) VALUES
(1,1,'2026-11-09 14:10:00','Entregue',22.50,'WhatsApp'),
(2,2,'2026-11-09 14:30:00','Entregue',29.50,'WhatsApp'),
(3,3,'2026-11-09 15:00:00','Entregue',23.50,'WhatsApp'),
(4,4,'2026-11-09 15:20:00','Entregue',34.50,'WhatsApp'),
(5,5,'2026-11-09 16:00:00','Entregue',19.50,'WhatsApp');
INSERT INTO Item_pedido (Id_item,Id_pedido,Id_produto,Quantidade,Preco_unitario) VALUES
(1,1,1,1,17.50),
(2,2,2,1,24.00),
(3,3,3,1,18.00),
(4,4,5,1,29.00),
(5,5,6,1,14.00);

-- Cenário 4: Personalização dos pedidos.
-- Cada cliente escolheu complementos; cada subtotal inclui os adicionais.
INSERT INTO Item_adicional (Id_item_adicional,Id_item,ID_adicional,Quantidade,Preco_unitario) VALUES
(1,1,1,1,3.00),(2,1,2,1,2.00),
(3,2,3,1,3.50),(4,2,2,1,2.00),
(5,3,4,1,3.00),(6,3,5,1,2.50),
(7,4,1,1,3.00),(8,4,5,1,2.50),
(9,5,3,1,3.50),(10,5,2,1,2.00);

-- Cenário 5: Fechamento das vendas, com cinco pagamentos confirmados.
INSERT INTO Pagamento (Id_pagamento,Id_pedido,Forma_pagamento,Valor_pago,Data_pagamento,Status_pagamento) VALUES
(1,1,'Pix',22.50,'2026-11-09 14:25:00','Confirmado'),
(2,2,'Dinheiro',29.50,'2026-11-09 14:45:00','Confirmado'),
(3,3,'Cartao',23.50,'2026-11-09 15:15:00','Confirmado'),
(4,4,'Pix',34.50,'2026-11-09 15:35:00','Confirmado'),
(5,5,'Dinheiro',19.50,'2026-11-09 16:15:00','Confirmado');

-- Baixa do estoque após a confirmação das cinco vendas.
UPDATE Produto SET Estoque = Estoque - 1 WHERE Id_produto IN (1,2,3,5,6);
COMMIT;

-- Conferência: todas as nove tabelas devem apresentar ao menos cinco registros.
SELECT 'Cliente' AS Tabela,COUNT(*) AS Registros FROM Cliente
UNION ALL SELECT 'Categoria',COUNT(*) FROM Categoria
UNION ALL SELECT 'Fornecedor',COUNT(*) FROM Fornecedor
UNION ALL SELECT 'Produto',COUNT(*) FROM Produto
UNION ALL SELECT 'Adicional',COUNT(*) FROM Adicional
UNION ALL SELECT 'Pedido',COUNT(*) FROM Pedido
UNION ALL SELECT 'Item_pedido',COUNT(*) FROM Item_pedido
UNION ALL SELECT 'Item_adicional',COUNT(*) FROM Item_adicional
UNION ALL SELECT 'Pagamento',COUNT(*) FROM Pagamento;

-- Conferência: o total de cada pedido corresponde aos produtos e adicionais.
SELECT p.Id_pedido,p.Valor_total,
 SUM(ip.Quantidade*ip.Preco_unitario) +
 COALESCE((SELECT SUM(ia.Quantidade*ia.Preco_unitario)
 FROM Item_adicional ia JOIN Item_pedido i2 ON i2.Id_item=ia.Id_item
 WHERE i2.Id_pedido=p.Id_pedido),0) AS Total_calculado
FROM Pedido p JOIN Item_pedido ip ON ip.Id_pedido=p.Id_pedido
GROUP BY p.Id_pedido,p.Valor_total;
