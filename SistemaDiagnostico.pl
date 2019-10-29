:- dynamic(known/3).
:- discontiguous menuask/3.
:- discontiguous ask/2.
:- use_module(library(jpl)).

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

%insect(pteropus_rodricensis).
%insect(equus_zera_hartmannae).
%insect(panthera_tigris_altaica).
%insect(panthera_pardus_orientalis).
%insect(uncia_uncia).
%insect(callosciurus_prevostii).
%insect(macropus_fulignosus).
%insect(macroscelides_proboscideus).
%insect(tupaia_belangeri).
%insect(hylobates_syndactylus).
%insect(colobus_polykomos).
%insect(pithecia_pithecia).
%insect(saguinus_imperator_subgrisescens).
%insect(saguinus_oedipus).


% Expert recogniser
% Asks
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



% Remember what I've been told is correct
ask(Attr, Val) :- known(yes, Attr, Val), !.

% % Remember what I've been told is wrong
ask(Attr, Val) :- known(_, Attr, Val), !, fail.

% Remember when I've been told an attribute has a different value
ask(Attr, Val) :- known(yes, Attr, V), V \== Val, !, fail.

% % I don't know this, better ask!
ask(Attr, Val) :- interface(Attr,Val).


go :- insect(X) ,write('The insect is '), write(X), nl.


interface(Attr,Val) :-
	atom_concat('Pregunta ',Attr, FAtom),
	atom_concat(FAtom,Val,FinalAtom),
	jpl_new('javax.swing.JFrame', ['Claves Dicotomicas'], F),
	jpl_new('javax.swing.JLabel',['Sistema Experto de Insectos'],LBL),
	jpl_new('javax.swing.JPanel',[],Pan),
	jpl_call(Pan,add,[LBL],_),
	jpl_call(F, add, [Pan],_),
	jpl_call(F, setLocation, [0,0], _),
	jpl_call(F, setSize, [480,220], _),
	jpl_call(F, setVisible, [@(true)], _),
	jpl_call(F, toFront, [], _),
	jpl_call('javax.swing.JOptionPane', showInputDialog, [F,FinalAtom], Ans),
	jpl_call(F, dispose, [], _), 
	write(Ans),nl,asserta(known(Ans, Attr, Val)), Ans == yes.

