# Açaíteria do Vini — Banco de Dados

## Sobre o projeto
Este é um projeto da disciplina de Banco de Dados. O minimundo é uma pequena açaíteria de Baía Formosa/RN, que recebe pedidos pelo WhatsApp. O cardápio tem açaí de vários tamanhos, cremes e adicionais, como banana, granola, leite em pó e leite condensado.

A proposta é organizar clientes, produtos, pedidos, complementos, fornecedores e pagamentos em um banco MySQL.

## Arquivos
- `Açaiteria.drawio`: diagrama da versão inicial do projeto. **Ainda precisa ser atualizado** para mostrar as nove tabelas do SQL atual.
- `acaiteria_BD.sql`: primeira versão do exercício, mantida como histórico.
- `script-ddl.sql`: cria o banco e as nove tabelas, com chaves e restrições.
- `script-dml.sql`: insere dados fictícios em cinco cenários, do cadastro do cardápio até os pagamentos.

## Tabelas
Cliente, Categoria, Fornecedor, Produto, Adicional, Pedido, Item_pedido, Item_adicional e Pagamento.

## Regras de negócio
- Cada cliente tem um código próprio; o telefone não pode se repetir.
- Os produtos pertencem a uma categoria e têm um fornecedor.
- O preço e o estoque não podem ser negativos.
- Um pedido pertence a um cliente e pode ter vários itens.
- Cada item guarda o preço praticado no momento da compra.
- Um item pode receber adicionais, cada um com quantidade e preço.
- Os pedidos podem estar pendentes, em preparo, prontos, entregues ou cancelados.
- O pagamento registra forma, valor, data e situação.


## Limitações desta versão
As restrições SQL garantem parte das regras, mas **não automatizam** o cálculo dos totais, a baixa de estoque, o cancelamento ou o limite de adicionais. No exemplo, os totais são informados nos INSERTs e a baixa de estoque é feita com UPDATE. O diagrama original também ainda não acompanha a estrutura nova.
