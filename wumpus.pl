/*
IMPLEMENTA��O DO MUNDO DO WUMPUS

Por: Fabiano Souza - fabiano_souza@hotmail.com



ABORDAGEM PROPOSTA

Modelo:
  ---------------
4|   |   |   | B |	A - Agente (em [1,1])
  ---------------	W - Wumpus (fedor nas c�lulas adjacentes)
3| W | O | B |   |	B - Buraco (brisa nas c�lulas adjacentes)
  ---------------	O - Ouro (apresenta brilho na mesma c�lula)
2|   |   |   |   |
  ---------------	#W, #O = 1
1| A |   | B |   |	#B = 3
  ---------------	Posi��es aleat�rias (exceto [1,1])
   1   2   3   4
   
Ambiente: agente, wumpus, cavernas (c�lulas), buracos, ouro

Estado inicial:
	- agente em [1,1] com uma flecha, olhando para o leste
	- wumpus e buracos em cavernas quaisquer
	
Objetivos:
	- pegar o ouro e voltar � caverna [1,1] para sair com vida
	
Percep��es:
	-fedor, brisa, luz, choque (parede) e grito (wumpus morre)
	- vetor: [f, b, l, c, g]
	
A��es:
	- "avan�ar" para pr�xima caverna
	- virar 90 graus � "direita" ou � "esquerda"
	- "pegar" um objeto na caverna que o agente se encontra
	- "atirar" na dire��o para onde o agente est� olhando
	(a flecha para quando encontra uma parede ou mata o wumpus)
	- "sair" da caverna
	
Medida de desempenho:
	+1000 se pegar ouro;
	-1000 se cair num buraco ou virar refei��o do wumpus;
	-1 para cada a��o tomada e
	-10 por usar a flecha
*/



/* AMBIENTE E ESTADO INICIAL */

:- dynamic
	desempenho/1,			% Medida de desempenho
	agente/1,				% Localiza��o do agente
	olhando/1,				% �ngulo que o agente est� olhando
	flecha/1,				% Localiza��o/exist�ncia da flecha
	celulas_disponiveis/1,	% C�lulas dispon�veis para sele��o
	wumpus/1,				% Localiza��o/exist�ncia do wumpus
	buraco/1,				% Localiza��o dos buracos
	ouro/1					% Localiza��o/exist�ncia do ouro
.

% Define estado inicial do ambiente:
iniciar(P) :-
	retractall(desempenho(_)),
	retractall(agente(_)),
	retractall(olhando(_)),
	retractall(flecha(_)),
	retractall(celulas_disponiveis(_)),
	retractall(wumpus(_)),
	retractall(buraco(_)),
	retractall(ouro(_)),
	
	assertz(desempenho(0)),
	assertz(agente([1,1])),
	assertz(olhando(0)),
	assertz(flecha([1,1])),
	assertz(
		celulas_disponiveis([
		[1,4],[2,4],[3,4],[4,4],
		[1,3],[2,3],[3,3],[4,3],
		[1,2],[2,2],[3,2],[4,2],
		      [2,1],[3,1],[4,1]])
	),
	wumpus,
	buraco,
	buraco,
	buraco,
	ouro,
	
	writeln('\n\n-= BEM-VINDO AO MUNDO DO WUMPUS =-\n'),
	writeln('Dentro da caverna.'),
	percepcoes(P),
	atualiza_desempenho(0)
.

% Cria um wumpus numa posi��o aleat�ria:
wumpus :-
	seleciona_celula(X),
	assertz(wumpus(X))
.

%Cria um buraco numa posi��o aleat�ria:
buraco :-
	seleciona_celula(X),
	assertz(buraco(X))
.

%Cria um ouro numa posi��o aleat�ria:
ouro :-
	seleciona_celula(X),
	assertz(ouro(X))
.

% Seleciona uma c�lula dispon�vel aleat�ria e exclui esta c�lula da lista de c�lulas dispon�veis:
seleciona_celula(X) :-
	celulas_disponiveis(Y),
	random_select(X,Y,Z),
	retractall(celulas_disponiveis(_)),
	assertz(celulas_disponiveis(Z))
.

% Define as c�lulas fedorentas:
fedor([X,Y]) :-
	wumpus([U,V]),
	(
		X is U,(Y is V-1;Y is V+1);
		Y is V,(X is U-1;X is U+1)
	)
.

% Define as c�lulas com briza:
briza([X,Y]) :-
	buraco([U,V]),
	(
		X is U,(Y is V-1;Y is V+1);
		Y is V,(X is U-1;X is U+1)
	)
.

% Define a c�lula com brilho:
brilho(X) :- ouro(X).

% Define as posi��es das paredes:
parede([X,Y]) :-
	member(X,[0,5]),between(1,4,Y);
	member(Y,[0,5]),between(1,4,X)
.



/* A��ES */

% Avan�a o agente:
avancar(T) :-
	atualiza_desempenho(-1),
	
	agente(X),
	olhando(Y),
	
	avancar(X,Y,Z),
	retractall(agente(_)),
	assertz(agente(Z)),
	
	% Checa por parede e retorna o agente caso encontre, e checa por buraco ou wumpus, que matam o agente:
	(
		parede(Z),
		percepcoes(_),
		retractall(agente(_)),
		assertz(agente(X)),
		writeln('Permanecendo no lugar.'),
		percepcoes([F,B,L,_,G]),
		T = [F,B,L,1,G];
		
		buraco(Z),
		retractall(agente(_)),
		atualiza_desempenho(-1000),
		desempenho(T),
		format('~w~n~w~n~w~n~w~n~n~w ~w~n',[
			'Avan�ada uma caverna.',
			'AAAAaaaa....',
			'Voc� morreu num buraco.',
			'Fim de jogo.',
			'Seu desempenho foi de:',T
		]);
		
		wumpus(Z),
		retractall(agente(_)),
		atualiza_desempenho(-1000),
		desempenho(T),
		format('~w~n~w~n~w~n~w~n~n~w ~w~n',[
			'Avan�ada uma caverna.',
			'CHOMP, CHOMP, CHOMP, ...',
			'Devorado pelo Wumpus.',
			'Fim de jogo.',
			'Seu desempenho foi de:',T
		]);
		
		writeln('Avan�ada uma caverna.'),
		percepcoes(T)
	),
	!
.

% Vira o agente 90 graus � esquerda:
esquerda(T) :-
	atualiza_desempenho(-1),
	
	agente(_),
	olhando(X),
	
	plus(X,+90,U),
	(U = 360,R is 0;R is U),
	retractall(olhando(_)),
	assertz(olhando(R)),
	
	writeln('Virado � esquerda.'),
	percepcoes(T),
	!	
.

% Vira o agente 90 graus � direita:
direita(T) :-
	atualiza_desempenho(-1),
	
	agente(_),
	olhando(X),
	
	plus(X,-90,U),
	(U = -90,R is 270;R is U),
	retractall(olhando(_)),
	assertz(olhando(R)),
	
	writeln('Virado � direita.'),
	percepcoes(T),
	!	
.
% Checa por brilho e pega o ouro caso j� n�o tenha pego:
pegar(T) :-
	atualiza_desempenho(-1),
	
	agente(X),
	
	(
		\+ouro(_),
		writeln('J� estava com o ouro.'),
		percepcoes(T);
		
		brilho(X),
		retractall(ouro(_)),
		atualiza_desempenho(+1000),
		writeln('OURO PEGO!!!'),
		percepcoes(T);
		
		writeln('Nada para pegar aqui.'),
		percepcoes(T)
	),
	!
.

% Atira a flecha caso tenha dispon�vel:
atirar(T) :-
	atualiza_desempenho(-1),
	
	agente(_),
	
	(
		\+flecha(_),
		writeln('Atirando sem flecha.'),
		percepcoes(T);
		
		agente(X),
		avancar_flecha(X,T),
		atualiza_desempenho(-10),
		retractall(flecha(_))
	),
	!
.

% Sai caso esteja em [1,1]:
sair(T) :-
	atualiza_desempenho(-1),
	
	agente(_),
	(
		agente([1,1]),
		retractall(agente(_)),
		desempenho(T),
		format('~w~n~w~n~n~w ~w~n',[
			'Voc� saiu da caverna.',
			'Fim de jogo.',
			'Seu desempenho foi de:',T
		]);
		
		writeln('Aqui n�o tem sa�da.'),
		percepcoes(T)
	),
	!
.


/* A��es para usu�rio humano */

iniciar :- iniciar(_).
avancar :- avancar(_).
esquerda :- esquerda(_).
direita :- direita(_).
pegar :- pegar(_).
atirar :- atirar(_).
sair :- sair(_).


/* Sub-regras das a��es */

% Avan�a a flecha:
avancar_flecha(X,P) :-
	olhando(Y),
	avancar(X,Y,Z),
	retractall(flecha(_)),
	assertz(flecha(Z)),
	
	% Checa por wumpus ou parede, sen�o continua avan�ando:
	(
		wumpus(Z),
		retractall(wumpus(_)),
		writeln('Flecha atirada.'),
		percepcoes(P);
		
		parede(Z),
		writeln('Flecha atirada.'),
		percepcoes(P);
		
		avancar_flecha(Z,P)
	)
.

% Avan�a o que quer que seja (POSI��O INICIAL, DIRE��O INICIAL, POSI��O FINAL):
avancar(A,B,C) :-
	A = [X,Y],
	(
		B = 0  ,plus(X,+1,U),V is Y;
		B = 90 ,plus(Y,+1,V),U is X;
		B = 180,plus(X,-1,U),V is Y;
		B = 270,plus(Y,-1,V),U is X
	),
	C = [U,V]
.

% Atualiza a medida de desempenho:
atualiza_desempenho(A) :-
	desempenho(D),
	plus(D,A,E),
	retractall(desempenho(_)),
	assertz(desempenho(E))
.



/* PERCEP��ES */

% Retorna e mostra as percep��es:
percepcoes(P) :-
	agente(X),
	(fedor(X) ,F is 1;F is 0),
	(briza(X) ,B is 1;B is 0),
	(brilho(X),L is 1;L is 0),
	(parede(X),C is 1;C is 0),
	(\+wumpus(_),flecha(_),G is 1;G is 0),
	P = [F,B,L,C,G],
	
	(F = 1,writeln('*Que fedor.');F = 0),
	(B = 1,writeln('*Estou sentindo uma brisa.');B = 0),
	(L = 1,writeln('*Vejo um brilho aqui.');L = 0),
	(C = 1,writeln('*Ouch! Uma parede.');C = 0),
	(G = 1,writeln('*Ou�o um grito ecoando pelas cavernas.');G = 0),
	writeln(''),
	!
.