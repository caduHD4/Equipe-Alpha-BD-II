DROP DATABASE IF EXISTS crispim;

-- CRIAÇÃO DO BANCO DE DADOS

CREATE DATABASE crispim DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

USE crispim;

-- CRIAÇÃO DAS TABELAS DO BANCO DE DADOS

CREATE TABLE estado(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(200) NOT NULL
    ,sigla CHAR(2) NOT NULL
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,CONSTRAINT pk_estado PRIMARY KEY estado(id)
);

CREATE TABLE cidade(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(200) NOT NULL
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,estado_id INT NOT NULL
    ,CONSTRAINT pk_cidade PRIMARY KEY cidade(id)
    ,CONSTRAINT fk_cidade_estado FOREIGN KEY (estado_id) REFERENCES estado(id)
);

CREATE TABLE categoria_produto(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(100) NOT NULL
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,CONSTRAINT pk_categoria_produto PRIMARY KEY categoria(id)
);

CREATE TABLE produto(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(200) NOT NULL
    ,preco DECIMAL(10,2) NOT NULL
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,categoria_id INT
    ,CONSTRAINT pk_produto PRIMARY KEY produto(id)
    ,CONSTRAINT fk_categoria_produto FOREIGN KEY (categoria_id) REFERENCES categoria_produto(id)
);



CREATE TABLE cliente(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(200) NOT NULL
    ,cpf VARCHAR(20) NOT NULL UNIQUE
    ,telefone VARCHAR(20) NOT NULL
    ,endereco VARCHAR(200) NOT NULL
    ,numero VARCHAR(10) NOT NULL
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,cidade_id INT NOT NULL
    ,CONSTRAINT pk_cliente PRIMARY KEY cliente(id)
    ,CONSTRAINT fk_cidade_cliente FOREIGN KEY (cidade_id) REFERENCES cidade(id)
);

CREATE TABLE venda(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
    ,cliente_id INT NOT NULL
    ,CONSTRAINT pk_venda PRIMARY KEY venda(id)
    ,CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE item_venda(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,produto_id INT NOT NULL
    ,quantidade INT NOT NULL
    ,data_hora DATETIME DEFAULT CURRENT_TIMESTAMP
    ,venda_id INT NOT NULL
    ,total DECIMAL(10,2) AS (quantidade * (SELECT produto.preco FROM produto WHERE produto.id = produto_id)) STORED
    ,CONSTRAINT pk_item_venda PRIMARY KEY item_venda(id)
    ,CONSTRAINT fk_produto_id FOREIGN KEY (produto_id) REFERENCES produto(id)
    ,CONSTRAINT fk_venda_id FOREIGN KEY (venda_id) REFERENCES venda(id)
);

CREATE TABLE forma_de_pagamento(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,nome VARCHAR(100) NOT NULL
    ,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,ativo CHAR(1) NOT NULL DEFAULT 'S' CHECK(ativo IN('S', 'N'))
    ,CONSTRAINT pk_fpagamento PRIMARY KEY forma_de_pagamento(id)
);

CREATE TABLE pagamento(
    id INT NOT NULL AUTO_INCREMENT UNIQUE
    ,status_pagamento VARCHAR(20) NOT NULL
    ,data_hora DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
    ,total_bruto INT NOT NULL
    ,desconto INT
    ,total_liquido INT NOT NULL
    ,fpagamento_id INT NOT NULL
    ,venda_id INT NOT NULL
    ,CONSTRAINT pk_pagamento PRIMARY KEY pagamento(id)
    ,CONSTRAINT status_pagamento_padrao CHECK(status_pagamento IN('PENDENTE', 'PAGO'))
    ,CONSTRAINT fk_pagamento_fpagamento FOREIGN KEY (fpagamento_id) REFERENCES forma_de_pagamento(id)
    ,CONSTRAINT fk_pagamento_venda FOREIGN KEY (venda_id) REFERENCES venda(id)
);



-- ALIMENTANDO O BANCO

-- ESTADOS

INSERT INTO estado (nome, sigla) VALUES ('RIO GRANDE DO SUL', 'RS');
INSERT INTO estado (nome, sigla) VALUES ('RIO GRANDE DO SUL', 'RS');
INSERT INTO estado (nome, sigla) VALUES ('PARANÁ', 'PR');
INSERT INTO estado (nome, sigla) VALUES ('SANTA CATARINA', 'SC');
INSERT INTO estado (nome, sigla) VALUES ('ESPIRITO SANTO', 'ES');
INSERT INTO estado (nome, sigla) VALUES ('SÃO PAULO', 'SP');
INSERT INTO estado (nome, sigla) VALUES ('RIO DE JANEIRO', 'RJ');
INSERT INTO estado (nome, sigla) VALUES ('MINAS GERAIS', 'MG');
INSERT INTO estado (nome, sigla) VALUES ('MATO GROSSO DO SUL', 'MS');
INSERT INTO estado (nome, sigla) VALUES ('MATO GROSSO', 'MT');
INSERT INTO estado (nome, sigla) VALUES ('TOCANTINS', 'TO');
INSERT INTO estado (nome, sigla) VALUES ('AMAZONAS', 'AM');
INSERT INTO estado (nome, sigla) VALUES ('GOIÁS', 'GO');
INSERT INTO estado (nome, sigla) VALUES ('RONDONIA', 'RO');
INSERT INTO estado (nome, sigla) VALUES ('ACRE', 'AC');
INSERT INTO estado (nome, sigla) VALUES ('RORAIMA', 'RR');
INSERT INTO estado (nome, sigla) VALUES ('PARÁ', 'PA');
INSERT INTO estado (nome, sigla) VALUES ('AMAPÁ', 'AP');
INSERT INTO estado (nome, sigla) VALUES ('MARANHÃO', 'MA');
INSERT INTO estado (nome, sigla) VALUES ('PIAUÍ', 'PI');
INSERT INTO estado (nome, sigla) VALUES ('RIO GRANDE DO NORTE', 'RN');
INSERT INTO estado (nome, sigla) VALUES ('PARAÍBA', 'PB');
INSERT INTO estado (nome, sigla) VALUES ('PERNAMBUCO', 'PE');
INSERT INTO estado (nome, sigla) VALUES ('ALAGOAS', 'AL');
INSERT INTO estado (nome, sigla) VALUES ('SERGIPE', 'SE');
INSERT INTO estado (nome, sigla) VALUES ('BAHIA', 'BA');

-- CATEGORIAS DE PRODUTOS

INSERT INTO categoria_produto (nome) VALUES ('LANCHE');
INSERT INTO categoria_produto (nome) VALUES ('LANCHE GOURMET');
INSERT INTO categoria_produto (nome) VALUES ('PORÇÃO');
INSERT INTO categoria_produto (nome) VALUES ('COMBO');
INSERT INTO categoria_produto (nome) VALUES ('SUCO');
INSERT INTO categoria_produto (nome) VALUES ('BEBIDA');

-- CIDADES
INSERT INTO cidade(nome, estado_id) VALUES ('TERRA RICA', 1);
INSERT INTO cidade(nome, estado_id) VALUES ('PARANAVAÍ', 1);
INSERT INTO cidade(nome, estado_id) VALUES ('MARINGÁ', 1);
INSERT INTO cidade(nome, estado_id) VALUES ('CURITIBA', 1);
INSERT INTO cidade(nome, estado_id) VALUES ('PORTO ALEGRE', 2);
INSERT INTO cidade(nome, estado_id) VALUES ('FLORIANÓPOLIS', 3);
INSERT INTO cidade(nome, estado_id) VALUES ('ITAJAÍ', 3);
INSERT INTO cidade(nome, estado_id) VALUES ('BALNEÁRIO CAMBORIÚ', 3);
INSERT INTO cidade(nome, estado_id) VALUES ('SÃO PAULO', 5);
INSERT INTO cidade(nome, estado_id) VALUES ('SANTO ANASTÁCIO', 5);
INSERT INTO cidade(nome, estado_id) VALUES ('VITÓRIA', 4);
INSERT INTO cidade(nome, estado_id) VALUES ('RIO DE JANEIRO', 6);
INSERT INTO cidade(nome, estado_id) VALUES ('BELO HORIZONTE', 7);
INSERT INTO cidade(nome, estado_id) VALUES ('CAMPO GRANDE', 8);
INSERT INTO cidade(nome, estado_id) VALUES ('CUIABÁ', 9);
INSERT INTO cidade(nome, estado_id) VALUES ('PALMAS', 10);
INSERT INTO cidade(nome, estado_id) VALUES ('MANAUS', 11);
INSERT INTO cidade(nome, estado_id) VALUES ('GOIANIA', 12);
INSERT INTO cidade(nome, estado_id) VALUES ('PORTO VELHO', 13);
INSERT INTO cidade(nome, estado_id) VALUES ('RIO BRANCO', 14);
INSERT INTO cidade(nome, estado_id) VALUES ('BOA VISTA', 15);
INSERT INTO cidade(nome, estado_id) VALUES ('BELÉM', 16);
INSERT INTO cidade(nome, estado_id) VALUES ('MACAPÁ', 17);
INSERT INTO cidade(nome, estado_id) VALUES ('SÃO LUÍS', 18);
INSERT INTO cidade(nome, estado_id) VALUES ('TERESINA', 19);
INSERT INTO cidade(nome, estado_id) VALUES ('NATAL', 20);
INSERT INTO cidade(nome, estado_id) VALUES ('JOÃO PESSOA', 21);
INSERT INTO cidade(nome, estado_id) VALUES ('RECIFE', 22);
INSERT INTO cidade(nome, estado_id) VALUES ('MACEIÓ', 23);
INSERT INTO cidade(nome, estado_id) VALUES ('ARACAJU', 24);
INSERT INTO cidade(nome, estado_id) VALUES ('SALVADOR', 26);

-- FORMA DE PAGAMENTO

INSERT INTO forma_de_pagamento(nome) VALUES ('DÉBITO');
INSERT INTO forma_de_pagamento(nome) VALUES ('CRÉDITO');
INSERT INTO forma_de_pagamento(nome) VALUES ('DINHEIRO');
INSERT INTO forma_de_pagamento(nome) VALUES ('PIX');

-- PRODUTOS

INSERT INTO produto(nome, preco, categoria_id) VALUES ('HOT DOG', 12.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('MISTO QUENTE', 12.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE CARNE', 14.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE CARNE DUPLO', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE CARNE COM BACON', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE FRANGO', 14.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE FRANGO COM CATUPIRY', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE FRANGO DUPLO', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('PRENSADO DE FRANGO COM BACON', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-BACON', 16.50, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-CALABRESA', 16.50, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-BURGUER', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-CRISPINZINHO', 15.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-BACONLEZA', 19.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-EGG', 19.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-CRISPIN', 22.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-FILÉ MIGNON', 25.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-FILÉ DE FRANGO', 25.00, 1);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG BURGUER', 15.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG SALADA', 17.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG BACON', 18.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG EGG', 18.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG ESPECIAL', 19.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BIG FILÉ MIGNON', 22.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-COSTELA DORITOS', 25.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-COSTELA BACON', 25.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('X-COSTELA CALABRESA', 25.00, 2);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BATATA COM QUEIJO E BACON', 18.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BATATA COM CHEDDAR E BACON', 20.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BATATA COM QUEIJO', 15.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('BATATA COM BACON', 15.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('CALABRESA COM CEBOLA', 20.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('FILÉ DE TILAPIA', 25.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('FRANGO FRITO', 20.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('TORRESMO', 20.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('POLENTA', 20.00, 3);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COMBO 01', 30.00, 4);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COMBO 02', 30.00, 4);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE LARANJA', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE MARACUJÁ', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE ABACAXI', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE ABACAXI COM HORTELÃ', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE LIMÃO', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO DE MORANGO', 10.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('REFRIGERANTE LATA 350ML', 4.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('FANTA', 4.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COCA', 4.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('GUARANÁ', 4.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COCA-COLA 600ML', 5.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COCA-COLA 1L', 6.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('COCA-COLA 2L', 10.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('TUBAÍNA 600ML', 3.50, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('TUBAÍNA 2L', 6.00, 6);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO PRATS 350ML', 4.50, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SUCO PRATS 1L', 9.00, 5);
INSERT INTO produto(nome, preco, categoria_id) VALUES ('SKOL LATA 350ML', 4.00, 6);

-- CLIENTES

INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('DIOGO MENESES DE FRANÇA', "44991162891", '12345678910', 'RUA INDAIAL ', '1230', 1);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('CARLOS EDUARDO DE FRANÇA', "44991768883", '12345678911', 'RUA MATO GROSSO', '1050', 1);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('ARACELES DE MENESES', "18988022202", '12345678912', 'RUA DOM PEDRO I', '70 C', 10);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('ANDRÉ LUIZ DE ALMEIDA', "47991584678", '12345678913', 'RUA PERNAMBUCO', '257', 7);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('JOÃO DOS SANTOS', "11994755812", '12345678914', 'RUA SERGIPE', '479', 9);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('IRENE FERRAZ', "11987541759", '12345678915', 'AVENIDA JOSÉ BONIFÁCIO', '1630', 9);
INSERT INTO cliente(nome,telefone, cpf, endereco, numero, cidade_id ) VALUES ('ROSA MARIA DOS SANTOS', "1154574832", '12345678916', 'RUA SANTO ANTONIO', '1326', 9);


-- CRIANDO VENDAS

-- DIOGO COMPROU 2 HOT DOG E UMA COCA 600ML
INSERT INTO venda(cliente_id) VALUES (1);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (1, 2, 1);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (49, 1, 1);

-- CARLOS EDUARDO COMPROU 1 X-BACON E UMA COCA 2L
INSERT INTO venda(cliente_id) VALUES (2);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (10, 1, 2);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (51, 1, 2);

-- ARACELES COMPROU 2 X-BACON E 1 COCA GARRAFINHA
INSERT INTO venda(cliente_id) VALUES (3);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (10, 2, 3);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (47, 1, 3);

-- IRENE COMPROU UMA PORÇÃO DE BATATA COM QUEIJO E BACON E 2 CERVEJAS SKOL LATA
INSERT INTO venda(cliente_id) VALUES (6);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (28, 1, 4);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (56, 2, 4);

-- JOÃO COMPROU UMA PORÇÃO DE FILÉ DE TILÁPIA E 3 CERVEJAS SKOL LATA
INSERT INTO venda(cliente_id) VALUES (5);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (33, 1, 5);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (56, 3, 5);

-- ANDRÉ LUIZ COMPROU 2 X-CALABRESA E 1 COCA 2L
INSERT INTO venda(cliente_id) VALUES (4);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (11, 2, 6);
INSERT INTO item_venda(produto_id, quantidade, venda_id) VALUES (51, 1, 6);



