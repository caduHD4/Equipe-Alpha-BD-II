CREATE DATABASE farmacia_base;

USE farmacia_base;

CREATE TABLE estado(
id INT NOT NULL AUTO_INCREMENT 
,nome VARCHAR(200) NOT NULL UNIQUE
,sigla CHAR(2) NOT NULL UNIQUE 
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
,CONSTRAINT pk_estado PRIMARY KEY (id) 
);

CREATE TABLE cidade(
id INT NOT NULL AUTO_INCREMENT 
,nome VARCHAR(200) NOT NULL 
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP 
,estado_id INT NOT NULL 
,CONSTRAINT pk_cidade PRIMARY KEY (id) 
,CONSTRAINT cidade_estado FOREIGN KEY (estado_id) REFERENCES estado (id) 
,UNIQUE(nome, estado_id) 
);

CREATE TABLE cliente_cadastro(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(200) NOT NULL
,cpf VARCHAR(14) NOT NULL UNIQUE
,fone VARCHAR(13) NOT NULL
,ativo ENUM('S','N') NOT NULL DEFAULT 'S'
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,cidade_id INT NOT NULL
,CONSTRAINT pk_client_cadastro PRIMARY KEY (id)
,CONSTRAINT cliente_cidade FOREIGN KEY (cidade_id) REFERENCES cidade (id)
);

CREATE TABLE funcionario(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(200) NOT NULL
,cpf CHAR(11) NOT NULL UNIQUE
,fone VARCHAR(13) NOT NULL
,ativo ENUM('S','N') NOT NULL DEFAULT 'S'
,salario DECIMAL(9,2) NOT NULL
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,cidade_id INT NOT NULL
,CONSTRAINT pk_funcionario PRIMARY KEY (id)
,CONSTRAINT funcionario_cidade FOREIGN KEY (cidade_id) REFERENCES cidade (id)
);

CREATE TABLE filial(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR (45) NOT NULL
,cnpj VARCHAR(45) NOT NULL
,tipo VARCHAR(45) NOT NULL
,CONSTRAINT pk_filial PRIMARY KEY (id)
);

CREATE TABLE remedio(
id INT NOT NULL AUTO_INCREMENT
,nome VARCHAR(24) NOT NULL
,descricao VARCHAR(200) NOT NULL
,remedio_tipo VARCHAR (14) NOT NULL
,marca VARCHAR(14) NOT NULL
,preco DECIMAL(10,2) NOT NULL
,validade DATETIME NOT NULL
,estoque INT NOT NULL
,filial_id INT NOT NULL, FOREIGN KEY (filial_id) REFERENCES filial (id)
,CONSTRAINT pk_remedio PRIMARY KEY (id)
);

CREATE TABLE audi_remedio(
id INT NULL AUTO_INCREMENT
,nome VARCHAR(24) NOT NULL
,marca VARCHAR(14) NOT NULL
,antigo_preco DECIMAL(10,2) NOT NULL
,novo_preco DECIMAL(10,2) NOT NULL
,data_alteracao DATETIME DEFAULT CURRENT_TIMESTAMP
,CONSTRAINT pk_audi_remedio PRIMARY KEY (id)
);

CREATE TABLE fpagamento(
id INT NOT NULL AUTO_INCREMENT
,descricao VARCHAR(200) NOT NULL
,quant_parcelas VARCHAR(12) NOT NULL
,entrada VARCHAR(200) NOT NULL
,CONSTRAINT pk_fpagamento PRIMARY KEY (id)
);

CREATE TABLE venda(
id INT NOT NULL AUTO_INCREMENT
,data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,ativo ENUM('S','N') NOT NULL DEFAULT 'S'
,total VARCHAR(14)
,cliente_cadastro_id INT NOT NULL, FOREIGN KEY (cliente_cadastro_id) REFERENCES cliente_cadastro (id)
,funcionario_id INT NOT NULL,FOREIGN KEY (funcionario_id) REFERENCES funcionario (id)
,fpagamento_id INT NOT NULL, FOREIGN KEY (fpagamento_id) REFERENCES fpagamento (id)
,remedio_id INT NOT NULL, FOREIGN KEY (remedio_id) REFERENCES remedio (id)
,filial_id INT NOT NULL, FOREIGN KEY (filial_id) REFERENCES filial(id)
,PRIMARY KEY (id)
);

CREATE TABLE item_venda(
id INT NOT NULL AUTO_INCREMENT
,quantidade VARCHAR(200) NOT NULL
,preco_unidade INT NOT NULL
,data_venda DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
,PRIMARY KEY (id)
,venda_id INT NOT NULL, FOREIGN KEY (venda_id) REFERENCES venda(id)
,remedio_id INT NOT NULL, FOREIGN KEY (remedio_id) REFERENCES remedio(id)
);

/* Trigger acionado quando ?? feito algum INSERT na tabela item_venda,
diminuindo a quantidade no estoque*/

DELIMITER // 
CREATE TRIGGER baixa_de_estoque
AFTER 
INSERT ON item_venda FOR EACH ROW
	BEGIN 
        UPDATE remedio set remedio.estoque = remedio.estoque - NEW.quantidade
        WHERE remedio.id = NEW.remedio_id;
    END;
//
DELIMITER ;	

/* Trigger que impede a venda se o remedio estiver vencido*/

DELIMITER // 
CREATE TRIGGER impedir_venda_remedio_vencido
BEFORE 
INSERT ON item_venda FOR EACH ROW
	BEGIN 
        DECLARE remedio_validade;
		SELECT validade INTO remedio_validade FROM remedio WHERE id = NEW.remedio_id;

		IF NOW() > remedio_validade THEN
			signal sqlstate '45000' set message_text = 'Inapropriado para venda - Fora da validade';
		END IF;
	END;
		
END;
//
DELIMITER ;	


/*Trigger monitora a altera????o nos pre??os dos remedios*/

DELIMITER //
CREATE TRIGGER auditoria_remedio
AFTER
UPDATE ON remedio FOR EACH ROW
    BEGIN
        IF NEW.preco < OLD.preco THEN
            INSERT INTO audi_remedio (nome, marca, antigo_preco, novo_preco) 
            VALUES (NEW.nome, NEW.marca, OLD.preco, NEW.preco);
        END IF;
    END;

//
DELIMITER

