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
edge(G,J,1,0.05).
edge(H,F,1,0.05).
edge(H,I,6,0.3).


