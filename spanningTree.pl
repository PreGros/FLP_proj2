:- use_module(input2).

/* Get unique */
% Pomáhá pří vytváření pole unikátních znaků, zjistí zda-li prvky v poli
% jsou již v poli unikátních prvků a podle toho vloží nebo vynechá
tryPut([], RECRES, RECRES).
tryPut([H|T],RECRES, RES) :-
    tryPut(T, RECRES, SUBRES),
    (memberchk(H,SUBRES) ->
        RES = SUBRES
    ;
        RES = [H|SUBRES]
    ).

% Vytváří pole unikátních znaků ze zadaného pole polí 
uniqueArray([], []).
uniqueArray([H|T], RES) :-
    uniqueArray(T, RECRES),
    tryPut(H, RECRES, RES).
/* --------------------------- */

/* Kombinace o velikost (Počet vrcholů - 1) */
% Inspiroval jsem se funkcí subbags ze cvičení
addOneToAll(_, [], []).
addOneToAll(E, [L|LS], [[E|L]|T]) :- addOneToAll(E, LS, T).

subbags([], [[]]).
subbags([X|XS], P) :-
    subbags(XS, RECRES),
    addOneToAll(X, RECRES, ALLRES),
    append(RECRES, ALLRES,P).

filterLenArray([], _, []).
filterLenArray([H|T], LEN, RES) :-
    filterLenArray(T, LEN, RECRES),
    length(H, HLEN),
    (HLEN =:= LEN ->
        RES = [H|RECRES]
    ;
        RES = RECRES
    ).

getLenSubbags(EDGES, LEN, SpanTreeCandidates) :-
    subbags(EDGES, Subbags),
    filterLenArray(Subbags, LEN, SpanTreeCandidates).
/* --------------------------- */

/* Lepší způsob generování kombinací o určité velikosti */

noRepeatCombination(0, _, []) :- !.
noRepeatCombination(NUM, [H|T], [H|RES]) :-
    NUM > 0,
    DECNUM is NUM - 1,
    noRepeatCombination(DECNUM, T, RES).
noRepeatCombination(NUM, [_|T], RES) :-
    noRepeatCombination(NUM, T, RES).

/* ---------------------------*/



main :-
    start_load_input(EDGES),
    uniqueArray(EDGES, UARRAY),
    length(UARRAY, LEN),
    SPANEDGECOUNT is LEN - 1,
    %getLenSubbags(EDGES, SPANEDGECOUNT, LENSUBBAGS),
    findall(K, noRepeatCombination(SPANEDGECOUNT, EDGES, K), Kombinace),
    write(Kombinace),
    halt.