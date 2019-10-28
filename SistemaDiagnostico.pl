:- dynamic(known/3).
:- discontiguous menuask/3.
:- discontiguous ask/2.

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
menuask(Attr, Val, _) :- known(yes, Attr, Val), !.
% % Remember what I've been told is wrong
ask(Attr, Val) :- known(_, Attr, Val), !, fail.
menuask(Attr, Val, _) :- known(_, Attr, Val), !, fail.
% Remember when I've been told an attribute has a different value
ask(Attr, Val) :- known(yes, Attr, V), V \== Val, !, fail.
menuask(Attr, Val, _) :- known(yes, Attr, V), V \== Val, !, fail.
% % I don't know this, better ask!
ask(Attr, Val) :- write(Attr:Val), write('? '), read(Ans), asserta(known(Ans, Attr, Val)), Ans == yes.
menuask(Attr, Val, List) :- write('What is the value for '), write(Attr), write('? '), nl,
                            write(List), nl,
                            read(Ans),
                            check_val(Ans, Attr, Val, List),
                            asserta(known(yes, Attr, Ans)),
                            Ans == Val.
check_val(Ans, _, _, List) :- member(Ans, List), !.
check_val(Ans, Attr, Val, List) :- write(Ans), write(' is not a known answer, please try again.'), nl,
                                   menuask(Attr, Val, List).

go :- insect(X), write('The insect is '), write(X), nl.