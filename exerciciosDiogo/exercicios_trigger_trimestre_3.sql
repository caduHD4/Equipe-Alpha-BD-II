DROP DATABASE IF EXISTS aula; 
CREATE DATABASE aula; 
USE aula; 

CREATE TABLE cliente (
id INT NOT NULL AUTO_INCREMENT
,nome_completo VARCHAR(255) NOT NULL 
,CPF_CNPJ VARCHAR(18) NOT NULL UNIQUE
,ativo CHAR(1) NOT NULL DEFAULT 'S'
,CONSTRAINT pk_cliente PRIMARY KEY (id)
);

CREATE TABLE produto (
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(255) NOT NULL
,preco_custo DECIMAL(8,2) NOT NULL 
,preco_venda DECIMAL(8,2) NOT NULL 
,estoque INT NOT NULL
,CONSTRAINT pk_produto PRIMARY KEY (id)
);

CREATE TABLE venda(
id INT NOT NULL AUTO_INCREMENT
,data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,cliente_id INT NOT NULL 
,CONSTRAINT pk_venda PRIMARY KEY (id)
,CONSTRAINT fk_venda_cliente FOREIGN KEY (cliente_id) REFERENCES cliente (id)
);

CREATE TABLE item_venda(
produto_id INT NOT NULL
,venda_id INT NOT NULL
,quantidade INT NOT NULL 
,preco_unidade DECIMAL(8,2) NOT NULL 
,total_item DECIMAL(8,2) AS (quantidade * preco_unidade) STORED
);

INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('MARIO PEREIRA','111.111.111-11');
INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('JOANA MARCONDES','222.222.222-22');
INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('SILVIO SANTOS','333.333.333-33');
INSERT INTO cliente (nome_completo,CPF_CNPJ,ativo) values ('MARIANA ANTUNES','444.444.444-44','N');

INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('COCA-COLA',4.0,5.5,30);
INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('CHOKITO',2.3,4.5,60);
INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('BACONZITOS',4.7,9.0,80);

-- 01- Escreva quatro triggers de sintaxe - a trigger não precisa ter funcionalidade, basta não dar erro de sintaxe. Use variável global para testar.
-- Faça uma declarando variáveis e com select into; 

SET @var = 0;

DELIMITER //
CREATE TRIGGER var_global_cpf_cliente
AFTER INSERT ON cliente
FOR EACH ROW
	BEGIN
		SELECT CPF_CNPJ INTO @var FROM cliente WHERE cliente.id = 1;
    
    END;
//
DELIMITER ;

INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('DIOGO M FRANCA','346.111.222-11');
SELECT @var;

-- Faça a segunda com uma estrutura de decisão; 


UPDATE produto SET preco_venda = 6 WHERE id = 1;
SELECT @teste;

-- Faça a terceira que gere erro, impedindo a ação;

DELIMITER //
CREATE TRIGGER gerando_erro
BEFORE INSERT ON cliente
FOR EACH ROW
BEGIN
    IF LENGTH(NEW.CPF_CNPJ) < 11 OR LENGTH(NEW.CPF_CNPJ) > 14 THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'CPF INVALIDO!';
    END IF;
END;
//
DELIMITER ;
INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('CARLOS EDUARDO','111.111.11');

-- Faça a quarta que utilize a variável new e old - tente diferenciar. 

SET @teste = 'a';
DELIMITER //
CREATE TRIGGER usando_if_else
BEFORE UPDATE ON produto
FOR EACH ROW
BEGIN
	IF NEW.preco_venda < OLD.preco_custo + OLD.preco_custo * 0.30 THEN
		SET @teste = "Preco de venda muito baixo!!!";
	ELSE
		SET @teste = "Preco de venda muito bom!";
	END IF;
END;
//
DELIMITER //