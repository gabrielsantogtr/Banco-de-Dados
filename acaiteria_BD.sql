-- AÇAITERIA | Estudo de 1FN, 2FN e 3FN com os campos originais
-- Fonte do modelo: Açaiteria.drawio. As sete entidades e os 27 campos foram mantidos.
-- Os tipos foram definidos em SQL, pois o desenho não informa tipos ou tamanhos.
-- Execute o arquivo inteiro em uma conexão MySQL no Workbench.
-- Cada execução apaga e recria o banco de exercícios acaiteria_adaptacao.
--
-- Limites do desenho
-- Cliente não tem Id_cliente. Item_pedido não tem Id_item nem Id_produto.
-- Por isso, três ligações desenhadas ficam sem uma FK executável.
-- Item_pedido repete os dados de Pedido. Essa redundância foi preservada.
-- O arquivo demonstra as formas normais possíveis, com essas limitações.

SET NAMES utf8mb4;
DROP DATABASE IF EXISTS acaiteria_adaptacao;
CREATE DATABASE acaiteria_adaptacao
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE acaiteria_adaptacao;

-- 1 | Tabelas do diagrama
-- 1FN | Os exemplos usam um telefone e um endereço por cliente.
-- Cliente fica sem PRIMARY KEY, pois o desenho não define um identificador.
CREATE TABLE `Cliente` (
    `Nome`     VARCHAR(150) NOT NULL,
    `Telefone` VARCHAR(30)  NULL,
    `endereço` VARCHAR(200) NULL
) ENGINE=InnoDB;

-- PRIMARY KEY identifica a categoria. Seu nome será consultado pelos produtos.
CREATE TABLE `Categoria` (
    `ID_categoria` INT          NOT NULL,
    `Nome`         VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ID_categoria`)
) ENGINE=InnoDB;

-- 3FN | O nome da categoria fica em Categoria, evitando sua repetição em Produto.
-- FOREIGN KEY exige uma categoria existente. DECIMAL(10,2) permite centavos.
CREATE TABLE `Produto` (
    `Id_produto`   INT           NOT NULL,
    `Nome`         VARCHAR(150)  NOT NULL,
    `Descrição`    VARCHAR(255)  NULL,
    `Preço`        DECIMAL(10,2) NOT NULL,
    `Estoque`      INT           NOT NULL,
    `ID_categoria` INT           NOT NULL,
    PRIMARY KEY (`Id_produto`),
    CONSTRAINT `fk_produto_categoria`
        FOREIGN KEY (`ID_categoria`) REFERENCES `Categoria` (`ID_categoria`)
) ENGINE=InnoDB;

-- ID_categoria foi mantido como identificador de adicional, conforme o desenho.
-- Nesta tabela, esse campo identifica a cobertura cadastrada.
CREATE TABLE `adicional` (
    `ID_categoria` INT           NOT NULL,
    `Nome`         VARCHAR(100)  NOT NULL,
    `Preço`        DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`ID_categoria`)
) ENGINE=InnoDB;

-- Id_cliente permanece no pedido, mas falta a coluna correspondente em Cliente.
-- O vínculo com o cadastro do cliente depende dessa informação ausente.
CREATE TABLE `Pedido` (
    `Id_pedido`   INT           NOT NULL,
    `Data_pedido` DATETIME      NOT NULL,
    `Valor_total` DECIMAL(10,2) NOT NULL,
    `status`      VARCHAR(40)   NOT NULL,
    `Id_cliente`  INT           NOT NULL,
    PRIMARY KEY (`Id_pedido`)
) ENGINE=InnoDB;

-- Todos os campos repetidos foram mantidos. Várias linhas podem apontar ao pedido.
-- Falta um identificador próprio do item. Os campos atuais não identificam o produto.
-- Para normalizar essa parte, os dados do cabeçalho deveriam ficar apenas em Pedido.
CREATE TABLE `Item_pedido` (
    `Id_pedido`   INT           NOT NULL,
    `Data_pedido` DATETIME      NOT NULL,
    `Valor_total` DECIMAL(10,2) NOT NULL,
    `Status`      VARCHAR(40)   NOT NULL,
    `Id_cliente`  INT           NOT NULL,
    CONSTRAINT `fk_item_pedido`
        FOREIGN KEY (`Id_pedido`) REFERENCES `Pedido` (`Id_pedido`)
) ENGINE=InnoDB;

-- 2FN | A quantidade depende do par (Id_item, ID_adicional).
-- Nome e preço dependem só do adicional e ficam na tabela adicional.
-- ID_adicional referencia a chave chamada ID_categoria em adicional.
-- Id_item fica sem FK porque a coluna correspondente falta em Item_pedido.
CREATE TABLE `Item_adicional` (
    `Id_item`      INT NOT NULL,
    `ID_adicional` INT NOT NULL,
    `_quantidade`  INT NOT NULL,
    PRIMARY KEY (`Id_item`, `ID_adicional`),
    CONSTRAINT `fk_item_adicional`
        FOREIGN KEY (`ID_adicional`) REFERENCES `adicional` (`ID_categoria`)
) ENGINE=InnoDB;

-- 2 | Dados fictícios
-- INSERT adiciona os registros. A transação agrupa a carga e COMMIT a confirma.
START TRANSACTION;

INSERT INTO `Cliente` (`Nome`, `Telefone`, `endereço`) VALUES
    ('Marina Costa', '85 90000-0101', 'Rua do Cajueiro, 18'),
    ('Luís Almeida', '85 90000-0102', 'Rua das Palmeiras, 25'),
    ('Rosa Freitas', NULL, NULL);

INSERT INTO `Categoria` (`ID_categoria`, `Nome`) VALUES
    (10, 'Açaí'), (20, 'Bebidas');
INSERT INTO `Produto` (`Id_produto`, `Nome`, `Descrição`, `Preço`, `Estoque`, `ID_categoria`) VALUES
    (201, 'Açaí 300 ml', 'Copo de açaí de 300 ml', 17.50, 30, 10),
    (202, 'Açaí 500 ml', 'Copo de açaí de 500 ml', 24.00, 20, 10),
    (203, 'Suco de acerola', 'Garrafa de 300 ml', 9.00, 15, 20);

INSERT INTO `adicional` (`ID_categoria`, `Nome`, `Preço`) VALUES
    (61, 'Granola', 3.00),
    (62, 'Banana', 2.00),
    (63, 'Leite em pó', 3.50);

-- Os códigos de cliente abaixo não podem ser associados aos nomes do cadastro.
INSERT INTO `Pedido` (`Id_pedido`, `Data_pedido`, `Valor_total`, `status`, `Id_cliente`) VALUES
    (501, '2026-11-09 14:10:00', 41.50, 'Entregue',   101),
    (502, '2026-11-09 14:30:00', 24.00, 'Preparando', 102),
    (503, '2026-11-09 15:00:00',  0.00, 'Aberto',     101);

-- Duas linhas repetem o cabeçalho de 501. Somar seus totais duplicaria a venda.
INSERT INTO `Item_pedido` (`Id_pedido`, `Data_pedido`, `Valor_total`, `Status`, `Id_cliente`) VALUES
    (501, '2026-11-09 14:10:00', 41.50, 'Entregue',   101),
    (501, '2026-11-09 14:10:00', 41.50, 'Entregue',   101),
    (502, '2026-11-09 14:30:00', 24.00, 'Preparando', 102);

-- Os códigos 901 e 902 exemplificam Id_item. O modelo não permite ligá-los a Item_pedido.
INSERT INTO `Item_adicional` (`Id_item`, `ID_adicional`, `_quantidade`) VALUES
    (901, 61, 1),
    (901, 62, 2),
    (902, 61, 3);
COMMIT;

-- 3 | Consultas demonstrativas

-- Consulta 1 | Atomicidade dos contatos (1FN)
-- Cada campo guarda um valor. IS NOT NULL seleciona quem tem telefone informado.
SELECT `Nome`, `Telefone`, `endereço`
FROM `Cliente`
WHERE `Telefone` IS NOT NULL
ORDER BY `Nome`;

-- Consulta 2 | Quantidade por item e adicional (2FN)
-- Granola aparece com quantidades diferentes nos itens 901 e 902.
SELECT ia.`Id_item`, ia.`ID_adicional`, a.`Nome` AS adicional,
       ia.`_quantidade`, a.`Preço` AS preco_atual,
       ia.`_quantidade` * a.`Preço` AS valor_pelo_catalogo
FROM `Item_adicional` AS ia
JOIN `adicional` AS a ON a.`ID_categoria` = ia.`ID_adicional`
ORDER BY ia.`Id_item`, ia.`ID_adicional`;

-- Consulta 3 | Cardápio e categorias (3FN)
-- JOIN recupera o nome da categoria pelo código armazenado em Produto.
SELECT p.`Id_produto`, p.`Nome` AS produto, c.`Nome` AS categoria,
       p.`Preço`, p.`Estoque`
FROM `Produto` AS p
JOIN `Categoria` AS c ON c.`ID_categoria` = p.`ID_categoria`
ORDER BY c.`Nome`, p.`Id_produto`;

-- Consulta 4 | Conferência das linhas de cada pedido
-- COUNT conta linhas sem somar o total repetido. LEFT JOIN inclui o pedido 503.
SELECT p.`Id_pedido`, p.`status`, p.`Valor_total`,
       COUNT(ip.`Id_pedido`) AS linhas_em_item_pedido
FROM `Pedido` AS p
LEFT JOIN `Item_pedido` AS ip ON ip.`Id_pedido` = p.`Id_pedido`
GROUP BY p.`Id_pedido`, p.`status`, p.`Valor_total`
ORDER BY p.`Id_pedido`;

-- Consulta 5 | Valores registrados por código de cliente
-- A soma usa Pedido. Id_cliente 101 tem dois pedidos, totalizando 41,50.
SELECT `Id_cliente`, COUNT(*) AS pedidos, SUM(`Valor_total`) AS total_registrado
FROM `Pedido`
GROUP BY `Id_cliente`
ORDER BY `Id_cliente`;
