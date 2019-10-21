% Instituto Tecnologico de Costa Rica
% Lenguajes de Programacion
% Tarea Programada 3 - 
% Paradigma Logico - Prolog
% Natan Fernandez de Castro - 2017105774
% Kevin Rojas Salazar - 2016XXXXXX

% ======================================
% |            Ejercicio 1             |
% ======================================
% Ejercicio que tiene como proposito implementar
% un grafo dirigido para una empresa distribuidora
% de comida y buscar la ruta mas corta para entregas
%
% --------------------------------------
% [ Hechos ]
% --------------------------------------

edge(A,B,10,0.5).
edge(B,C,3,0.1).
edge(B,E,5,0.2).
edge(B,D,4,0.2).
edge(E,H,2,0.1).
edge(D,H,1,0.05).
edge(C,F,2,0.1).
edge(F,I,3,0.2).
edge(F,J,3,0.2).
edge(G,J,1,0.05).
edge(H,F,1,0.05).
edge(H,I,6,0.3).

connected(X,Y) :- edge(X,Y) ; edge(Y,X).

path(A,B,Path) :-
	travel(A,B,[A],Q), 
	reverse(Q,Path).

travel(A,B,P,[B|P]) :- 
	connected(A,B).

travel(A,B,Visited,Path) :-
	connected(A,C),          
 	C \== B,
 	not(member(C,Visited)),
 	travel(C,B,[C|Visited],Path).

go(From, To) :-
	traverse(From),    % Find all distances
	rpath([To|RPath], Dist)->         % If the target was reached
		reverse([To|RPath], Path),      % Report the path and distance
		Distance is round(Dist),
		writef('Shortest path is %w with distance %w = %w\n',
			[Path, Dist, Distance]);
	writef('There is no route from %w to %w\n', [From, To]).

shorterPath([H|Path], Dist) :-                 % path < stored path? replace it
	rpath([H|T], D), !, Dist < D,          % match target node [H|_]
	retract(rpath([H|_],_)),
	writef('%w is closer than %w\n', [[H|Path], [H|T]]),
	assert(rpath([H|Path], Dist)).

shorterPath(Path, Dist) :-                     % Otherwise store a new path
	writef('New path:%w\n', [Path]),
	assert(rpath(Path,Dist)).

traverse(From, Path, Dist) :-               % traverse all reachable nodes
	path(From, T, D),                   % For each neighbor
	not(memberchk(T, Path)),            %   which is unvisited
	shorterPath([T,From|Path], Dist+D), %   Update shortest path and distance
	traverse(T,[From|Path],Dist+D).     %   Then traverse the neighbor

traverse(From) :-
	retractall(rpath(_,_)),           % Remove solutions
	traverse(From,[],0).              % Traverse from origin