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
,total DECIMAL(8,2);
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
,CONSTRAINT fk_venda_item FOREIGN KEY (venda_id) REFERENCES venda (id)
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


/*01- Escreva quatro procedures de sintaxe - n??o precisa ter funcionalidade, basta n??o dar erro de
sintaxe. Use vari??vel global para testar.*/


/*- Fa??a uma declarando vari??veis e com select into;*/


SET @teste1 = '444.444.444-44';

DELIMITER // 
CREATE PROCEDURE variaveis (id_cliente INT)
		BEGIN
			SELECT CPF_CNPJ INTO @teste1 FROM cliente WHERE cliente.id = id_cliente;
		END;
//
DELIMITER ;


CALL variaveis (3);
SELECT @teste1; 



/*- Fa??a a segunda com uma estrutura de decis??o;*/


SET @teste2 = "Erro";

drop PROCEDURE estrutura_decisao;
DELIMITER // 
CREATE PROCEDURE estrutura_decisao(cpf_cnpj VARCHAR(45))
	BEGIN
    	IF LENGTH(cpf_cnpj) > 14 THEN
		SET @teste2 = "Caracteres excedidos";
		END IF;
	END;
//
DELIMITER ;

CALL estrutura_decisao('222.222.222');
SELECT @teste2;


/*- Fa??a a terceira que gere erro, impedindo a a????o;*/


DELIMITER //
CREATE PROCEDURE verifica_cpf (cpf_cnpj VARCHAR(18))
	BEGIN
      	IF LENGTH(cpf_cnpj) > 14 OR LENGTH(cpf_cnpj) < 14 THEN
                	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = "N??MERO DE CARACTERES INCORRETO";
      	END IF;
	END;
//
DELIMITER ;

CALL verifica_cpf ('555.555.555-555');


/*- Fa??a a quarta com if e else.*/


SET @teste4 = "Erro";
drop PROCEDURE if_else;
DELIMITER // 
CREATE PROCEDURE estrutura_decisao(cpf_cnpj VARCHAR(45))
	BEGIN
    	IF LENGTH(cpf_cnpj) > 14 OR LENGTH(cpf_cnpj) < 14 THEN
		SET @teste4 = "Os dados s??o invalidos";
	ELSE
		SET @teste4 = "Os dados s??o v??lidos";
		END IF;
	END;
//
DELIMITER ;

CALL estrutura_decisao('222.222.222-222');
SELECT @teste4;


/*02 - Escreva uma procedure que registre a baixa de um produto e j?? atualize devidamente o estoque do
produto. Antes das a????es, verifique se o produto ?? ativo.*/

DELIMITER //
CREATE PROCEDURE inserir_item_venda(id_venda INT, id_produto INT, quantidade_produto INT, preco_unidade_produto DECIMAL(8,2), desconto_iv INT)

BEGIN
    DECLARE status_produto CHAR(1);
    SELECT STATUS INTO status_produto FROM produto WHERE id = id_produto;
    IF status_produto = 'n' OR status_produto = 'N' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'PRODUTO INATIVO';
    ELSE
        INSERT INTO produto (venda_id, produto_id, quantidade, preco_unidade, desconto) 
		VALUES (id_venda, id_produto, quantidade_produto, preco_unidade_produto, desconto_iv);
        DECLARE quantidade_antiga INT;
        SELECT estoque INTO quantidade_antiga FROM produto WHERE id = id_produto;
        UPDATE produto SET estoque = quantidade_antiga - quantidade_produto WHERE id = id_produto;
	END IF;
END;
// DELIMITER ;



 /*
03 - Escreva uma procedure que altere o pre??o de um produto vendido (venda j?? realizada - necess??rio
verificar a exist??ncia da venda). N??o permita altear????es abusivas - pre??o de venda abaixo do pre??o de
custo. ?? poss??vel implementar esta funcionalidade sem a procedure? Se sim, indique como, bem como
as vantagens e desvantagens. R: ?? possivel atrav??s do uso da trigger, que deve ser acionada tada vez
que ouver um UPDATE no pre??o unitario de um item_venda. Vantagem e Desvantagem: A unica difere??a ?? que vai mudar
de um procedure por um UPDATE.*/


DELIMITER //
CREATE TRIGGER atualiza_total_venda
AFTER 
INSERT ON item_venda FOR EACH ROW
	BEGIN
		DECLARE total_x DECIMAL(8,2);
		SELECT total INTO total_x FROM venda WHERE id = NEW.venda_id;
		UPDATE venda SET total = total_x + (NEW.preco_unidade * NEW.quantidade);
	END;
//
DELIMITER ;


INSERT ON venda (cliente_id) VALUES (1);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (1, 1, 4, 5.99);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (3, 1, 3, 1.99);

INSERT ON venda (cliente_id) VALUES (2);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (1, 2, 4, 5.99);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (2, 2, 6, 1.50);

INSERT ON venda (cliente_id) VALUES (3);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (1, 3, 2, 5.99);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (2, 3, 1, 1.50);

INSERT ON venda (cliente_id) VALUES (4);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (3, 4, 8, 1.99);
INSERT ON item_venda (produto_id, venda_id, quantidade, preco_unidade) VALUES (1, 4, 5, 5.99);

DELIMITER //
CREATE PROCEDURE altera_preco_vendido(id_venda INT, n_preco DECIMAL(8,2), id_produto INT)
	BEGIN
		DECLARE existe_venda INT;
		SELECT id INTO existe_venda FROM venda WHERE id_venda = id;
			IF existe_venda = NULL THEN
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT "VENDA N??O EXISTE!";
			ELSE
				DECLARE pc DECIMAL(8,2);
				SELECT preco_custo INTO pc FROM produto WHERE id_produto = id;
				IF pc > n_preco THEN
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT "ALTERA????O ABUSIVA!";
				ELSE
					DECLARE preco_antigo DECIMAL (8,2);
					DECLARE quantidade_antiga INT;

					SELECT preco_unidade, quantidade INTO preco_antigo, quantidade_antiga FROM item_venda WHERE id_venda = venda_id and id_produto = produto_id;
					UPDATE item_venda SET preco_unidade = (n_preco) WHERE id_venda = venda_id and id_produto = produto_id;

					DECLARE total_antigo DECIMAL (8,2);
					SELECT total INTO total_antigo FROM venda WHERE id = id_venda;
					UPDATE venda SET total = total_antigo - ((preco_antigo * quantidade_antiga) - (n_preco * quantidade_antiga));
					
				END IF;
			END IF;
	END;
// 
DELIMITER ;



CREATE TABLE venda(
id INT NOT NULL AUTO_INCREMENT
,data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,cliente_id INT NOT NULL
,total DECIMAL(8,2) DEFAULT 0
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



/*
04 - Escreva uma procedure que registre vendas de produtos e j?? defina o total da venda. ?? poss??vel
implementar a mesma funcionalidade por meio da trigger? Qual seria a diferen??a? R: ?? possivel, a diferen??a seria
que ele sempre ser?? acionado depois depois de uma inser????o na tqabela item_venda.*/

DELIMITER //
CREATE PROCEDURE regista_venda_total (id_venda INT, id_produto INT, quantidadeT INT, preco_unidadeT DECIMAL(8,2))
	BEGIN
		INSERT ON item_venda (venda_id, produto_id, quantidade, preco_unidade)
		VALUES (id_venda, id_produto, quantidadeT, preco_unidadeT);
		INSERT ON venda SET total = (preco_unidadeT * quantidadeT) WHERE id_venda = venda_id;
	END;

//
DELIMITER ;



/*
05- Para o controle de sal??rio de funcion??rios de uma empresa e os respectivos adiantamentos (vales):
- quais tabelas s??o necess??rias?
R: ?? necessaria a tabela ADIANTAMENTO que tenha as colunas, ID, FUNCIONARIO_ID, VALOR, DATA_ADIANTAMENTO.*/


/*
06- De acordo com o seu projeto de banco de dados, pense em pelo menos 3 procedures ??teis. Discuta
com os seus colegas em rela????o a relev??ncia e implemente-as.*/


/*07- Explique as diferen??as entre trigger, fun????o e procedure. Indique as vantagens e desvantagens em
utilizar a procedure.

O que todos eles tem em comum - Sintaxe com utiliza????o de CREATE, DELIMITER, BEGIN, END.

Fun????es e Procedures:

Segundo KAMAKAWA, H.(2020) as fun????es possuem retorno (return), enquanto que as procedures
podem possuir vari??veis de sa??da declaradas como ???OUT??? , que s??o diferentes dos retornos
das fun????es, pois estas n??o podem ser atribu??das a uma vari??vel externa como os retornos
das fun????es podem. Enquanto as fun????es s??o chamadas pelo comando SELECT as procedures s??o
chamadas pelo comando CALL.

Fun????o:
- Tem apenas um retorno.
- Pode usar SELECT.
- N??o pode CALL.
- N??o pode mudar o estado do BD.
- Possue somente param??tros de entrada.

Procedure:
- N??o tem retorno
- Usa CALL para chamar
- N??o pode SELECT pra chamar
- Pode usar: INSERT, UPDATE, DELETE ou SELECT.
- Pode ter par??metro "tradicional" ou "par??metro de sa??da".
- Pode mudar o estado do BD.


Triggers:
- Gerar uma A????O associado a uma opera????o - Automatizar uma a????o
(um m??dulo de bloco de c??digo).
- ?? chamado automaticamente.

Aqui temos comandos que devem ser especificados na sintaxe antes de qualquer alter????o, inser????o e exclus??o,
AFTER/BEFORE - Ser?? executado depois ou antes da a????o.
Utiliza????o de .OLD e .NEW - O dado antigo e o dado novo que foi informado.

Vantagem:
Processamento local - velocidade, acesso aos dados locais.
Centraliza????o da a????o - poupar recursos da m??quina do cliente e facilitar a manuten????o.
*/


