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

:-dynamic
	rpath/2.      % A reversed path

edge(a,b,10,0.5).
edge(b,c,3,0.1).
edge(b,e,5,0.2).
edge(b,d,4,0.2).
edge(e,h,2,0.1).
edge(d,h,1,0.05).
edge(c,f,2,0.1).
edge(f,i,3,0.2).
edge(f,j,3,0.2).
edge(g,j,1,0.05).
edge(h,f,1,0.05).
edge(h,i,6,0.3).


path(From,To,Dist) :- edge(To,From,Dist).
path(From,To,Dist) :- edge(From,To,Dist).
 
shorterPath([H|Path], Dist) :-		       % path < stored path? replace it
	rpath([H|T], D), !, Dist < D,          % match target node [H|_]
	retract(rpath([H|_],_)),
	writef('%w is closer than %w\n', [[H|Path], [H|T]]),
	assert(rpath([H|Path], Dist)).
shorterPath(Path, Dist) :-		       % Otherwise store a new path
	writef('New path:%w\n', [Path]),
	assert(rpath(Path,Dist)).
 
traverse(From, Path, Dist) :-		    % traverse all reachable nodes
	path(From, T, D),		    % For each neighbor
	not(memberchk(T, Path)),	    %	which is unvisited
	shorterPath([T,From|Path], Dist+D), %	Update shortest path and distance
	traverse(T,[From|Path],Dist+D).	    %	Then traverse the neighbor
 
traverse(From) :-
	retractall(rpath(_,_)),           % Remove solutions
	traverse(From,[],0).              % Traverse from origin
traverse(_).
 
go(From, To) :-
	traverse(From),                   % Find all distances
	rpath([To|RPath], Dist)->         % If the target was reached
	  reverse([To|RPath], Path),      % Report the path and distance
	  Distance is round(Dist),
	  writef('Shortest path is %w with distance %w = %w\n',
	       [Path, Dist, Distance]);
	writef('There is no route from %w to %w\n', [From, To]).
 