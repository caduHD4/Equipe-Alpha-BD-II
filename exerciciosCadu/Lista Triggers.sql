DROP DATABASE IF EXISTS aula; 
CREATE DATABASE aula; 
USE aula; 

CREATE TABLE estado (
id INT NOT NULL auto_increment
,nome VARCHAR(100) NOT NULL 
,sigla CHAR(2) NOT NULL 
,STATUS CHAR DEFAULT 'A' NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL
,CONSTRAINT estado_pk PRIMARY KEY (id)
,CONSTRAINT estado_nome_u UNIQUE(nome) 
,CONSTRAINT estado_sigla_u UNIQUE(sigla)
,CONSTRAINT estado_status_ai CHECK (STATUS IN('A','I'))
);

CREATE TABLE cidade(
id INT NOT NULL auto_increment
,nome VARCHAR(100) NOT NULL 
,estado_id INT NOT NULL 
,STATUS CHAR DEFAULT 'A' NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,CONSTRAINT cidade_pk PRIMARY KEY (id) 
,CONSTRAINT cidade_est_fk FOREIGN KEY (estado_id) REFERENCES estado (id)
,CONSTRAINT cidade_status_ai CHECK (STATUS IN ('A','I'))
,CONSTRAINT cidade_unique UNIQUE(nome,estado_id)
);


CREATE TABLE cliente (
id INT NOT NULL AUTO_INCREMENT
,nome_completo VARCHAR(255) NOT NULL 
,CPF_CNPJ VARCHAR(18) NOT NULL UNIQUE
,ativo CHAR(1) NOT NULL DEFAULT 'S'
,CONSTRAINT pk_cliente PRIMARY KEY (id)
);

CREATE TABLE funcionario (
id INT NOT NULL auto_increment
,nome VARCHAR(100) NOT NULL 
,apelido VARCHAR(100) 
,cpf CHAR(14) NOT NULL 
,endereco VARCHAR(100) NOT NULL 
,endereco_numero VARCHAR(20) NOT NULL 
,endereco_completo VARCHAR(100)  
,endereco_bairro VARCHAR(100) NOT NULL 
,cep VARCHAR(10) NOT NULL 
,fone VARCHAR(15) 
,fone_d VARCHAR(15)
,contato VARCHAR(100)
,STATUS CHAR DEFAULT 'A' NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,data_nascimento DATE 
,email VARCHAR(100) 
,cidade_id INT NOT NULL 
,CONSTRAINT funcionario_pk PRIMARY KEY (id)
,CONSTRAINT funcionario_cid_fk FOREIGN KEY (cidade_id) REFERENCES cidade (id)
,CONSTRAINT funcionario_cpf CHECK (LENGTH(cpf) = 14)
,CONSTRAINT funcionario_cpf_u UNIQUE (cpf)
,CONSTRAINT funcionario_status CHECK(STATUS IN('A','I'))
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

CREATE TABLE fornecedor (
id INT NOT NULL auto_increment
,nome VARCHAR(100) NOT NULL 
,apelido VARCHAR(100) 
,cpf_cnpj VARCHAR(18) NOT NULL 
,endereco VARCHAR(100) NOT NULL 
,endereco_numero VARCHAR(20) NOT NULL 
,endereco_completo VARCHAR(100)  
,endereco_bairro VARCHAR(100) NOT NULL 
,cep VARCHAR(10) NOT NULL 
,fone VARCHAR(15) 
,fone_d VARCHAR(15)
,contato VARCHAR(100)
,STATUS CHAR DEFAULT 'A' NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,data_nascimento DATE 
,email VARCHAR(100) 
,cidade_id INT NOT NULL 
,CONSTRAINT fornecedor_pk PRIMARY KEY (ID)
,CONSTRAINT fornecedor_cid_fk FOREIGN KEY (cidade_id) REFERENCES cidade (id)
,CONSTRAINT fornecedor_cpfcnpj_u UNIQUE (cpf_cnpj)
,CONSTRAINT fornecedor_status CHECK(STATUS IN('A','I'))
);

CREATE TABLE compra (
id INT NOT NULL auto_increment
,tipo CHAR(2) NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,fornecedor_id INT NOT NULL 
,funcionario_id INT NOT NULL 
,fpagamento_id INT NOT NULL 
,desconto DECIMAL(12,2)  
,acrescimo DECIMAL(12,2)  
,total DECIMAL(12,2) 
,CONSTRAINT compra_pk PRIMARY KEY (id) 
,CONSTRAINT compra_fornecedor_fk FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id)
,CONSTRAINT compra_funcionario_fk FOREIGN KEY  (funcionario_id) REFERENCES funcionario (id)
,CONSTRAINT compra_tipo CHECK(tipo IN('PA','PF','CA','CF'))
);

CREATE TABLE  fpagamento (
id INT NOT NULL auto_increment
,descricao VARCHAR(100) NOT NULL 
,qtde_parcelas INT NOT NULL 
,entrada CHAR NOT NULL 
,STATUS CHAR DEFAULT 'A' NOT NULL 
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,CONSTRAINT fpagamento_pk PRIMARY KEY (id)
,CONSTRAINT fpagamento_status CHECK(STATUS IN('A','I'))
);

CREATE TABLE creceber (
id INT NOT NULL auto_increment
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,venda_id INT 
,fpagamento_id INT NOT NULL 
,atde_parc_pendente INT
,CONSTRAINT creceber_pk PRIMARY KEY (id) 
,CONSTRAINT crec_ven_fk FOREIGN KEY (venda_id) REFERENCES venda (id)
,CONSTRAINT crec_fpag_fk FOREIGN KEY (fpagamento_id) REFERENCES fpagamento (id)
);

CREATE TABLE parcela_receber(
id INT NOT NULL auto_increment
,valor DECIMAL(12,2) NOT NULL 
,quitado DECIMAL(12,2) DEFAULT 0
,juros DECIMAL(12,2) DEFAULT 0
,desconto DECIMAL(12,2) DEFAULT 0
,vencimento DATETIME
,creceber_id INT NOT NULL
,CONSTRAINT parcela_receber_pk PRIMARY KEY (id)
,CONSTRAINT parrec_crec_fk FOREIGN KEY (creceber_id) REFERENCES creceber(id)
);

CREATE TABLE recebimento (
id INT NOT NULL auto_increment
,descricao VARCHAR(200)
,valor DECIMAL(12,2)  
,data_recebimento DATETIME DEFAULT CURRENT_TIMESTAMP
,parcela_receber_id INT 
,CONSTRAINT recebimento_pk PRIMARY KEY (ID) 
,CONSTRAINT rec_parrec_fk FOREIGN KEY (parcela_receber_id) REFERENCES parcela_receber (id)
);

CREATE TABLE cpagar (
id INT NOT NULL auto_increment
,data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL 
,compra_id INT 
,fpagamento_id INT NOT NULL 
,qtde_parc_pendente INT
,CONSTRAINT cpagar_pk PRIMARY KEY (id) 
,CONSTRAINT cpag_com_fk FOREIGN KEY (compra_id) REFERENCES compra (id)
,CONSTRAINT cpag_fpag_fk FOREIGN KEY (fpagamento_id) REFERENCES fpagamento (id)
);

CREATE TABLE parcela_pagar(
id INT NOT NULL auto_increment
,valor DECIMAL(12,2) NOT NULL 
,quitado DECIMAL(12,2) DEFAULT 0
,juros DECIMAL(12,2) DEFAULT 0
,desconto DECIMAL(12,2) DEFAULT 0
,vencimento DATETIME
,cpagar_id INT 
,CONSTRAINT parcela_pagar_pk PRIMARY KEY (id)
,CONSTRAINT parpagar_cpag_fk FOREIGN KEY (cpagar_id) REFERENCES cpagar (id)
);

CREATE TABLE pagamento (
id INT NOT NULL auto_increment
,descricao VARCHAR(200)
,valor DECIMAL(12,2)  
,data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP
,parcela_pagar_id INT 
,fornecedor_id INT  
,CONSTRAINT pagamento_pk PRIMARY KEY (id) 
,CONSTRAINT pag_parpag_fk FOREIGN KEY (parcela_pagar_id) REFERENCES parcela_pagar (id)
,CONSTRAINT pag_forn_fk FOREIGN KEY (fornecedor_id) REFERENCES fornecedor (id)
);

CREATE TABLE auditoria (
old_id INT NOT NULL
,new_id INT NOT NULL
,nome_tabela VARCHAR(40)
,descricao VARCHAR(200)
,new_descricao VARCHAR(200)
,valor DECIMAL(12,2)
,new_valor DECIMAL(12,2)
,data_hora VARCHAR(40)
);

INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('MARIO PEREIRA','111.111.111-11');
INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('JOANA MARCONDES','222.222.222-22');
INSERT INTO cliente (nome_completo,CPF_CNPJ) values ('SILVIO SANTOS','333.333.333-33');
INSERT INTO cliente (nome_completo,CPF_CNPJ,ativo) values ('MARIANA ANTUNES','444.444.444-44','N');

INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('COCA-COLA',4.0,5.5,30);
INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('CHOKITO',2.3,4.5,60);
INSERT INTO produto (nome,preco_custo,preco_venda,estoque) values ('BACONZITOS',4.7,9.0,80);


/*
Exercícios de fixação - utilize o script do estudo de caso
https://github.com/heliokamakawa/curso_bd/blob/master/16b-trigger%20script%20base.sql
01- Escreva quatro triggers de sintaxe - a trigger não precisa ter funcionalidade, basta não dar erro de sintaxe. Use variável global para testar.
- Faça uma declarando variáveis e com select into; */

SET @teste1 = 'CARLOS';

DELIMITER // 
CREATE TRIGGER variaveis 
BEFORE
INSERT ON cliente FOR EACH ROW 
		BEGIN
			SELECT nome_completo FROM cliente WHERE cliente.id = 3 INTO @teste1;
		END;
//
DELIMITER ;

SELECT @teste1; 


/*
- Faça a segunda com uma estrutura de decisão; */

SET @teste2 = "Erro";

DELIMITER // 
CREATE TRIGGER estrutura_decisao 
AFTER
INSERT ON cliente FOR EACH ROW 
	BEGIN
    	IF LENGTH(NEW.CPF_CNPJ) <= 14 THEN
		SET @teste2 = "Os dados são válidos";
	ELSE
		SET @teste2 = "Dados inválidos";
		END IF;
	END;
//
DELIMITER ;

SELECT @teste2;


/*
- Faça a terceira que gere erro, impedindo a ação; */
drop trigger verifica_cpf;
DELIMITER //
CREATE TRIGGER verifica_cpf
BEFORE UPDATE ON cliente FOR EACH ROW
	BEGIN
      	IF LENGTH(NEW.CPF_CNPJ) > 14 OR LENGTH(NEW.CPF_CNPJ) < 14 THEN
                	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "NÚMERO DE CARACTERES INCORRETO";
      	END IF;
	END;
//
DELIMITER ;

UPDATE cliente SET CPF_CNPJ = '555.555.555-55' WHERE ID = 1;


/*
- Faça a quarta que utilize a variável new e old - tente diferenciar. */

DELIMITER //
CREATE TRIGGER validar_alteracao_cliente_inativo
 BEFORE UPDATE ON cliente FOR EACH ROW
	BEGIN
		IF NEW.ativo <> OLD.ativo AND
			EXISTS(SELECT * FROM conta_receber WHERE CLIENTE_ID = NEW.id)
		THEN
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ALTERAÇÃO INVÁLIDA - CLIENTE POSSUI DÍVIDA ';
		END IF;
	END
 //
DELIMITER ;

/*
02- Uma trigger que tem a função adicionar a entrada de produtos no estoque deve ser associado para qual:
•	Tabela? 	ITEM_VENDA
•	Tempo? 		AFTER
•	Evento? 	INSERT
•	Precisa de variáveis? Quais? 	Nenhuma, pois será usado UPDATE
•	Implemente a trigger. 
*/

DELIMITER // 
CREATE TRIGGER adicao_estoque
AFTER 
INSERT ON item_venda FOR EACH ROW
	BEGIN 
		UPDATE produto SET estoque = estoque + NEW.quantidade WHERE produto.id = NEW.produto_id;
	END;
//
DELIMITER ;

SELECT estoque FROM produto WHERE id = 1;

/*
03- Uma trigger que tem a função criar um registro de auditoria quando um pagamento e recebimento for alterada deve ser associado para qual(is):
•	Tabela(s)? Pagamento, recebimento
•	Tempo? BEFORE
•	Evento? UPDATE
•	Implemente a trigger (pode criar a tabela de auditoria)

*/

DELIMITER //
CREATE TRIGGER registro_auditoria_p
AFTER
UPDATE ON pagamento FOR EACH ROW
	BEGIN 
		INSERT INTO auditoria(old_id, new_id, nome_tabela, descricao, new_descricao, valor, new_valor, data_hora)
        VALUES (OLD.id, NEW.id, 'pagamento', OLD.descricao, NEW.descricao, OLD.valor, NEW.valor, NOW());
	END
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER registro_auditoria_r
AFTER
UPDATE ON recebimento FOR EACH ROW
	BEGIN 
		INSERT INTO auditoria(old_id, new_id, nome_tabela, descricao, new_descricao, valor, new_valor, data_hora)
        VALUES (OLD.id, NEW.id, 'recebimento', OLD.descricao, NEW.descricao, OLD.valor, NEW.valor, NOW());
	END
//
DELIMITER ;


/*
04- Uma trigger que tem a função impedir a venda de um produto inferior a 50% do preço de venda deve ser associado para qual:
•	Tabela? item_venda
•	Tempo? BEFORE
•	Evento? INSERT
•	Implemente a trigger
*/

DELIMITER // 
CREATE TRIGGER impedir_venda_produto_desconto
BEFORE 
INSERT ON item_venda FOR EACH ROW
	BEGIN 
		DECLARE preco_produto DECIMAL (8,2); 
    	DECLARE preco_unitario DECIMAL (8,2);
    
		SELECT preco_venda INTO preco_produto FROM produto WHERE id = NEW.produto_id;
		SELECT preco_unidade INTO preco_unitario FROM item_venda;
    
		IF preco_produto * 0.5 > preco_unitario THEN
			signal sqlstate '45000' set message_text = 'Valor de desconto inapropriado para venda';
		END IF;
END;
//
DELIMITER ;	

INSERT INTO item_venda(produto_id,venda_id,quantidade,preco_unidade) VALUES (1,1,4,27);

/*
05- Este é para testar a sintaxe - tente implementar sem o script
Uma trigger que tem a função de gerar o RA automático na tabela ALUNO deve ser associada para qual
•	Tabela? Aluno
•	Tempo? AFTER
•	Evento? INSERT
•	Precisa de variáveis? Quais? não
•	Implemente a trigger - RA igual a concatenção do ano corrente, código do curso e o id do cadastro do aluno. 
*/

DELIMITER //

CREATE TRIGGER ra_auto
AFTER 
INSERT ON matricula FOR EACH ROW
	BEGIN
		DECLARE ano VARCHAR(10);
		SELECT year(CURRENT_TIMESTAMP) INTO ano;
      	INSERT INTO aluno.ra VALUES (CONCAT(ano, NEW.curso_id, NEW.id));
	END;
//
DELIMITER ;


SELECT FROM produto