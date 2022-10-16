/*01- Escreva quatro procedures de sintaxe - não precisa ter funcionalidade, basta não dar erro de
sintaxe. Use variável global para testar.
- Faça uma declarando variáveis e com select into;*/

SET @teste = 2;

DELIMITER //
CREATE PROCEDURE variaveis (id_produto INT)
    BEGIN
        SELECT estoque INTO @teste FROM produto WHERE produto.id = id_produto;
    END;
//
DELIMITER ;

--Teste.
CALL variaveis (1);

SELECT @teste;



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