
#### Refatoração da tabela service_order com Postgres

Este repositório contém a solução para o desafio de refatoração da tabela service_order, que consistiu em realizar algumas alterações na estrutura da tabela e gerar uma nova visualização dos dados. A solução foi implementada com o uso do Postgres e está documentada a seguir.

A refatoração foi realizada por meio da criação de uma **VIEW** chamada **vw_service_order**, que utiliza subtabelas para melhorar a performance da query e inclui as colunas propostas no desafio. As subtabelas são as seguintes:

- **service_order_logs**: centraliza as informações desejadas da tabela log_events. Contém os campos abaixo:
  * **datetime_first_budget_approved**: Data da primeira aprovação
  * **datetime_last_budget_approved**: Data da aprovação mais recente
  * **datetime_execution_budget_cancelled**: Data mais recente do cancelamento da aprovação

- **service_order_last_approval**: substitui os valores NULOS do campo datetime_execution_budget_approved pelo data mais recente da tabela log_event. Para isso, é utilizada a subquery service_order_logs e o campo datetime_last_budget_approved.

- **service_order_approval_status**: utiliza a lógica case when para substituir o valor da coluna datetime_execution_budget_approved pelo valor NULL, caso a data mais recente do status de Aprovação cancelada seja maior que ela. Também é feita a substituição reversa na coluna datetime_execution_budget_cancelled, para que não fique registrada uma data caso a data de aprovação seja maior.

Por fim, é realizada uma extração do mês da coluna created_at para referência de mês e são feitas contagens dos orçamentos aprovados e cancelados no ano de 2022. 
A query resultante gera uma tabela com as seguintes colunas: mês, número de orçamentos aprovados e número de orçamentos cancelados. 

A Tabela de resultados está no arquivo [service_order_results_table.ipynb](https://github.com/lauanecardoso/Desafio_DA_Refera/blob/main/service_order_results_table.ipynb), esse arquivo foi feito em Python com a biblioteca PANDAS para a leitura da tabela final. Nesse arquivo foi alterado o index para a primeira coluna do arquivo (mês) usando o Colab Google. 






