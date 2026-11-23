-- AÇAITERIA DO VINI | DDL 
DROP DATABASE IF EXISTS acaiteria_adaptacao;
CREATE DATABASE acaiteria_adaptacao CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE acaiteria_adaptacao;

CREATE TABLE Cliente (
 Id_cliente INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(150) NOT NULL,
 Telefone VARCHAR(20) NOT NULL UNIQUE,
 Endereco VARCHAR(200) NOT NULL,
 Data_nascimento DATE NULL
);
CREATE TABLE Categoria (
 ID_categoria INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(100) NOT NULL UNIQUE,
 Descricao VARCHAR(255) NOT NULL,
 Ativa BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE Fornecedor (
 Id_fornecedor INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(120) NOT NULL,
 Telefone VARCHAR(20) NOT NULL UNIQUE,
 Cidade VARCHAR(100) NOT NULL,
 Ativo BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE Produto (
 Id_produto INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(120) NOT NULL,
 Descricao VARCHAR(255) NOT NULL,
 Preco DECIMAL(10,2) NOT NULL CHECK (Preco >= 0),
 Estoque INT NOT NULL DEFAULT 0 CHECK (Estoque >= 0),
 ID_categoria INT NOT NULL,
 Id_fornecedor INT NOT NULL,
 FOREIGN KEY (ID_categoria) REFERENCES Categoria(ID_categoria),
 FOREIGN KEY (Id_fornecedor) REFERENCES Fornecedor(Id_fornecedor)
);
CREATE TABLE Adicional (
 ID_adicional INT AUTO_INCREMENT PRIMARY KEY,
 Nome VARCHAR(100) NOT NULL UNIQUE,
 Descricao VARCHAR(200) NOT NULL,
 Preco DECIMAL(10,2) NOT NULL CHECK (Preco >= 0),
 Disponivel BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE Pedido (
 Id_pedido INT AUTO_INCREMENT PRIMARY KEY,
 Id_cliente INT NOT NULL,
 Data_pedido DATETIME NOT NULL,
 Status_pedido VARCHAR(30) NOT NULL DEFAULT 'Pendente',
 Valor_total DECIMAL(10,2) NOT NULL DEFAULT 0 CHECK (Valor_total >= 0),
 Canal VARCHAR(30) NOT NULL DEFAULT 'WhatsApp',
 FOREIGN KEY (Id_cliente) REFERENCES Cliente(Id_cliente),
 CHECK (Status_pedido IN ('Pendente','Em preparo','Pronto','Entregue','Cancelado'))
);
CREATE TABLE Item_pedido (
 Id_item INT AUTO_INCREMENT PRIMARY KEY,
 Id_pedido INT NOT NULL,
 Id_produto INT NOT NULL,
 Quantidade INT NOT NULL CHECK (Quantidade > 0),
 Preco_unitario DECIMAL(10,2) NOT NULL CHECK (Preco_unitario >= 0),
 FOREIGN KEY (Id_pedido) REFERENCES Pedido(Id_pedido),
 FOREIGN KEY (Id_produto) REFERENCES Produto(Id_produto)
);
CREATE TABLE Item_adicional (
 Id_item_adicional INT AUTO_INCREMENT PRIMARY KEY,
 Id_item INT NOT NULL,
 ID_adicional INT NOT NULL,
 Quantidade INT NOT NULL DEFAULT 1 CHECK (Quantidade > 0),
 Preco_unitario DECIMAL(10,2) NOT NULL CHECK (Preco_unitario >= 0),
 FOREIGN KEY (Id_item) REFERENCES Item_pedido(Id_item),
 FOREIGN KEY (ID_adicional) REFERENCES Adicional(ID_adicional),
 UNIQUE (Id_item, ID_adicional)
);
CREATE TABLE Pagamento (
 Id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
 Id_pedido INT NOT NULL UNIQUE,
 Forma_pagamento VARCHAR(20) NOT NULL,
 Valor_pago DECIMAL(10,2) NOT NULL CHECK (Valor_pago >= 0),
 Data_pagamento DATETIME NOT NULL,
 Status_pagamento VARCHAR(20) NOT NULL DEFAULT 'Confirmado',
 FOREIGN KEY (Id_pedido) REFERENCES Pedido(Id_pedido),
 CHECK (Forma_pagamento IN ('Pix','Dinheiro','Cartao')),
 CHECK (Status_pagamento IN ('Confirmado','Pendente','Estornado'))
);
