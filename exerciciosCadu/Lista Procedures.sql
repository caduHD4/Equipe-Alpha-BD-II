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


/*01- Escreva quatro procedures de sintaxe - não precisa ter funcionalidade, basta não dar erro de
sintaxe. Use variável global para testar.
- Faça uma declarando variáveis e com select into;*/


SET @teste1 = 'CARLOS';

DELIMITER // 
CREATE PROCEDURE variaveis (id_cliente INT)
		BEGIN
			SELECT nome_completo INTO @teste1 FROM cliente WHERE cliente.id = id_cliente;
		END;
//
DELIMITER ;


CALL variaveis (3);
SELECT @teste1; 


/*
- Faça a segunda com uma estrutura de decisão;
- Faça a terceira que gere erro, impedindo a ação;
- Faça a quarta com if e else.
02 - Escreva uma procedure que registre a baixa de um produto e já atualize devidamente o estoque do
produto. Antes das ações, verifique se o produto é ativo.
 
03 - Escreva uma procedure que altere o preço de um produto vendido (venda já realizada - necessário
verificar a existência da venda). Não permita altearções abusivas - preço de venda abaixo do preço de
custo. É possível implementar esta funcionalidade sem a procedure? Se sim, indique como, bem como
as vantagens e desvantagens.
04 - Escreva uma procedure que registre vendas de produtos e já defina o total da venda. É possível
implementar a mesma funcionalidade por meio da trigger? Qual seria a diferença?
05- Para o controle de salário de funcionários de uma empresa e os respectivos adiantamentos (vales):
- quais tabelas são necessárias?
06- De acordo com o seu projeto de banco de dados, pense em pelo menos 3 procedures úteis. Discuta
com os seus colegas em relação a relevância e implemente-as.
07- Explique as diferenças entre trigger, função e procedure. Indique as vantagens e desvantagens em
utilizar a procedure.
*/