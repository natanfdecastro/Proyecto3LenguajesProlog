% Instituto Tecnologico de Costa Rica
% Lenguajes de Programacion
% Tarea Programada 3 -
% Paradigma Logico - Prolog
% Natan Fernandez de Castro - 2017105774
% Kevin Rojas Salazar - 2016081582

% ======================================
% |            Ejercicio 2             |
% ======================================
% Se implementa un sistema experto que
% identifica especies de insectos mediante
% clasves dicotomicas.


% --------------------------------------
% [ Hechos ]
% --------------------------------------
:- dynamic(known/3).
:- discontiguous menuask/3.
:- discontiguous ask/2.
:- use_module(library(jpl)).


% --------------------------------------
% [ Declaraciones de insectos ]
% --------------------------------------
insect(spheniscus_humboldti):- backbone(yes), lungs(yes), warm_blooded(yes), wings(yes), feathers(yes), webbed_feet(yes).
insect(aratinga_solstitialis):- backbone(yes), lungs(yes), warm_blooded(yes), wings(yes), feathers(yes), webbed_feet(no), curved_beak(yes), feathered_face(yes).
insect(geronticus_eremita):- backbone(yes), lungs(yes), warm_blooded(yes), wings(yes), feathers(yes), webbed_feet(no), curved_beak(yes), feathered_face(no).
insect(leptoptilos_crumenferus):- backbone(yes), lungs(yes), warm_blooded(yes), wings(yes), feathers(yes), webbed_feet(no), curved_beak(no).
insect(hexaprotodon_liberiensis):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(yes),nocturnal(yes).
insect(pecari_tajacu):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(yes),nocturnal(no), hair(yes).
insect(babyrousa_babyrussa):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(yes),nocturnal(no), hair(no).
insect(giraffe_camelopardalis):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(no),both_sexes_with_horns(yes), skined_horns(yes).
insect(budorcas_taxicolor_taxicolor):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(no),both_sexes_with_horns(yes), skined_horns(no), shaggy_fur(yes).
insect(gazella_dorcas_neglecta):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(no),both_sexes_with_horns(yes), skined_horns(no), shaggy_fur(no).
insect(tragelaphus_strepsiceros):- backbone(yes), lungs(yes), warm_blooded(yes), wings(no), even_toed_ungulate(yes),tusks(no),both_sexes_with_horns(no).


% --------------------------------------
% [ Declaraciones de atributos ]
% --------------------------------------
% Orden y metodos en los que seran preguntados los atributos de los insectos
backbone(X):-ask(backbone, X).
lungs(X):-ask(lungs, X).
warm_blooded(X):-ask(warm_blooded, X).
wings(X):-ask(wings, X).
feathers(X):-ask(feathers, X).
webbed_feet(X):-ask(webbed_feet, X).
curved_beak(X):-ask(curved_beak, X).
feathered_face(X):-ask(feathered_face, X).
even_toed_ungulate(X):-ask(even_toed_ungulate, X).
tusks(X):-ask(tusks, X).
nocturnal(X):-ask(nocturnal, X).
hair(X):-ask(hair, X).
both_sexes_with_horns(X):-ask(both_sexes_with_horns, X).
skined_horns(X):-ask(skined_horns, X).
shaggy_fur(X):-ask(shaggy_fur, X).


% --------------------------------------
% [ Declaraciones de preguntas ]
% --------------------------------------
%Metodos de consulta con respecto a las preguntas realizadas
ask(Attr, Val) :- known(yes, Attr, Val), !.
ask(Attr, Val) :- known(_, Attr, Val), !, fail.
ask(Attr, Val) :- known(yes, Attr, V), V \== Val, !, fail.
%Metodo que consulta al usuario cada pregunta
ask(Attr, Val) :- interface(Attr,Val).


% --------------------------------------
% [ Metodos de arranque ]
% --------------------------------------
% Metodo que incia el sistema experto, cuando encuentra un match con X se lo devuelve a la interfaz para ser imprimido.
start :- insect(X) , interfaceResponse(X).
% Si el metodo start anterior regresa false realizara este metodo que indica que el insecto no fue encontrado
start :- interfaceNotFound.


% --------------------------------------
% [ Interfaces graficas ]
% --------------------------------------
% Metodo creado para traducir los numero booleanos del JOptionPane a los caracteres 'yes' y 'no'
numberToString(X, Y):- (X == 0) -> Y = yes; Y = no.

%Interfaz que conecta con java e imprime una ventana con sus caracteristicas. Pide un input y lo agrega utilizando el metodo asserta.
interface(Attr,Val) :-
	atom_concat(Attr, ': ', FAtom),
	atom_concat(FAtom,Val,FinalAtom),
	jpl_new('javax.swing.JFrame', ['Claves Dicotomicas'], F),
	jpl_new('javax.swing.JLabel',['Sistema Experto de Insectos'],LBL),
	jpl_new('javax.swing.JPanel',[],Pan),
	jpl_new('java.awt.Color',[153, 153, 255],Color),
	jpl_call(Pan,add,[LBL],_),
	jpl_new('java.awt.Font', ['Verdana', 1, 48],Font),
	jpl_call(LBL, setFont, [Font], _),
	jpl_call(F, add, [Pan],_),
	jpl_call(F, setLocation, [0,0], _),
	jpl_call(F, setSize, [1080,720], _),
	jpl_call(F, setVisible, [@(true)], _),
	jpl_call(Pan, setBackground, [Color], _),
	jpl_call(F, toFront, [], _),
	jpl_call('javax.swing.JOptionPane', showConfirmDialog, [F,FinalAtom], N), %Crea un input y guarda el valor seleccionado en N
	jpl_call(F, dispose, [], _), 
	write(N),
	numberToString(N, Ans), % Convierte el valor en los acronimos 'yes' o 'no' dependiendo de la respuesta dada.
	write(Ans),
	asserta(known(Ans, Attr, Val)), Ans == yes.

%Interfaz que conecta con java e imprime una ventana con sus caracteristicas. Toma una variable INSECTO y la pone en un mensaje de la ventana.
interfaceResponse(INSECTO) :-
	jpl_new('javax.swing.JFrame', ['Claves Dicotomicas'], F),
	jpl_new('javax.swing.JLabel',['Sistema Experto de Insectos'],LBL),
	jpl_new('javax.swing.JPanel',[],Pan),
	jpl_new('java.awt.Color',[153, 153, 255],Color),
	jpl_call(Pan,add,[LBL],_),
	jpl_new('java.awt.Font', ['Verdana', 1, 48],Font),
	jpl_call(LBL, setFont, [Font], _),
	jpl_call(F, add, [Pan],_),
	jpl_call(F, setLocation, [0,0], _),
	jpl_call(F, setSize, [1080,720], _),
	jpl_call(F, setVisible, [@(true)], _),
	jpl_call(Pan, setBackground, [Color], _),
	jpl_call(F, toFront, [], _),
	jpl_call('javax.swing.JOptionPane', showMessageDialog, [F,INSECTO], N),
	jpl_call(F, dispose, [], _).

%Interfaz que conecta con java e imprime una ventana con sus caracteristicas. Indica en una ventana de mensaje que el insecto no fue encontrado
interfaceNotFound :-
	jpl_new('javax.swing.JFrame', ['Claves Dicotomicas'], F),
	jpl_new('javax.swing.JLabel',['Sistema Experto de Insectos'],LBL),
	jpl_new('javax.swing.JPanel',[],Pan),
	jpl_new('java.awt.Color',[153, 153, 255],Color),
	jpl_call(Pan,add,[LBL],_),
	jpl_new('java.awt.Font', ['Verdana', 1, 48],Font),
	jpl_call(LBL, setFont, [Font], _),
	jpl_call(F, add, [Pan],_),
	jpl_call(F, setLocation, [0,0], _),
	jpl_call(F, setSize, [1080,720], _),
	jpl_call(F, setVisible, [@(true)], _),
	jpl_call(Pan, setBackground, [Color], _),
	jpl_call(F, toFront, [], _),
	jpl_call('javax.swing.JOptionPane', showMessageDialog, [F,'Insecto No Encontrado'], N),
	jpl_call(F, dispose, [], _).

% --------------------------------------
% [ Comienzo del programa ]
% --------------------------------------
%Metodo que corre el programa apenas inicia	
:- start.
