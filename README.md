# wumpus
Wumpus World Prolog Implementation

Esta é uma implementação do Mundo do Wumpus para o SWI-Prolog baseada no livro Artificial Intelligence: A Modern Approach (Russell - Norvig).  
A abordagem proposta para o ambiente, estado inicial, ações e percepções são descritas abaixo.

Modelo:
```
  ---------------
4|   |   |   | B |	A - Agente (em [1,1])
  ---------------	W - Wumpus (fedor nas células adjacentes)
3| W | O | B |   |	B - Buraco (brisa nas células adjacentes)
  ---------------	O - Ouro (apresenta brilho na mesma célula)
2|   |   |   |   |
  ---------------	#W, #O = 1
1| A |   | B |   |	#B = 3
  ---------------	Posições aleatórias (exceto [1,1])
   1   2   3   4
```
Ambiente: agente, wumpus, cavernas (células), buracos, ouro

Estado inicial:
- agente em [1,1] com uma flecha, olhando para o leste
- wumpus e buracos em cavernas quaisquer

Objetivos:
- pegar o ouro e voltar à caverna [1,1] para sair com vida
	
Percepções:
- fedor, brisa, luz, choque (parede) e grito (wumpus morre)
- vetor: [f, b, l, c, g]

Ações:
- "avançar" para próxima caverna
- virar 90 graus à "direita" ou à "esquerda"
- "pegar" um objeto na caverna que o agente se encontra
- "atirar" na direção para onde o agente está olhando
  (a flecha para quando encontra uma parede ou mata o wumpus)
- "sair" da caverna

Medida de desempenho:
- +1000 se pegar ouro
- -1000 se cair num buraco ou virar refeição do wumpus
- -1 para cada ação tomada
- -10 por usar a flecha

Para implementação foi utilizado o software SWI-Prolog versão 7.6.4, sendo que nenhuma modificação foi realizada ou extensão adicionada ao pacote original.  
Foi definido um ambiente dinâmico, isto é, fatos e regras não são salvos na base de conhecimento com o decorrer das ações, esta foi considerada uma função do agente.  
O ambiente é distinto do agente, podendo ser interagido também por um agente humano.  
Algumas regras definidas foram escritas com o objetivo de facilitar sua interpretação, sem focar em desempenho.

As seguintes regras podem ser utilizadas para se agir no ambiente e receber as percepções disponíveis:
- `iniciar(-Term)`: Define o estado inicial do ambiente
- `avancar(-Term)`: Avança o agente para a célula adiante caso não seja uma parede
- `esquerda(-Term)`: Direciona o agente à célula a sua esquerda
- `direita(-Term)`: Direciona o agente à célula a sua direita
- `pegar(-Term)`: Pega o ouro caso esteja disponível na mesma célula que o agente
- `atirar(-Term)`: Atira uma flecha na direção que o agente está olhando
- `sair(-Term)`: Sai da caverna caso exista uma saída

`Term` é a matriz de flags de percepções recebidas após cada ação, ou a medida de desempenho final caso o agente saia da caverna ou morra. Este termo foi criado para que um agente autônomo interaja com o ambiente.

Para facilitar a utilização por um usuário humano, as regras `iniciar`, `avancar`, `esquerda`, `direita`, `pegar`, `atirar` e `sair`, sem a necessidade de se incluir um termo, também foram criadas, sendo que as percepções e a medida de desempenho são apresentadas em formato de texto no terminal do software.  
Estas ações são sempre executadas e contadas na medida de desempenho, mesmo que não possam ser concluídas, como avançar uma célula com parede, tentar pegar o ouro quando este não estiver presente ou já estiver com o agente, atirar sem uma flecha e tentar sair de uma caverna que não possua saída.
