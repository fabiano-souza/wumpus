# wumpus
Wumpus World Prolog Implementation

Esta é uma implementação do Mundo do Wumpus para o SWI-Prolog baseando-se no livro Artificial Intelligence: A Modern Approach (Russell - Norvig).  
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
- +1000 se pegar ouro;  
- -1000 se cair num buraco ou virar refeição do wumpus;  
- -1 para cada ação tomada e  
- -10 por usar a flecha  
