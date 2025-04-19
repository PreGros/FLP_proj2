:- use_module(input2).

/* Get unique */
% Pomáhá pří vytváření pole unikátních znaků, zjistí zda-li prvky v poli
% jsou již v poli unikátních prvků a podle toho vloží nebo vynechá
tryPut([], RECRES, RECRES).
tryPut([H|T],RECRES, RES) :-
    tryPut(T, RECRES, SUBRES),
    (memberchk(H,SUBRES) -> % předělat tento if spíš na prolog-like syntaxi (myšleno přidat misto toho třetí volání tryPut podobně jak noRepeatCombination)
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

/* Lepší způsob generování kombinací o určité velikosti */

noRepeatCombination(0, _, []) :- !.
noRepeatCombination(NUM, [H|T], [H|RES]) :-
    NUM > 0,
    DECNUM is NUM - 1,
    noRepeatCombination(DECNUM, T, RES).
noRepeatCombination(NUM, [_|T], RES) :-
    noRepeatCombination(NUM, T, RES).

/* --------------------------- */

/* Hledání cyklů */

dropWithCycle([], []).
dropWithCycle([H|T], ALLVERTICES, [H|SUBRES]) :-
    deepSearch(H, FOUNDVERTICES),
    permutation(ALLVERTICES, FOUNDVERTICES), % kontrola jestli se v hlubokém prohlédávání  našly všechny vrcholy, pokud ano, tak vloží H jako kostru (ve zkratce porovnává pole)
    dropWithCycle(T, ALLVERTICES, SUBRES).
dropWithCycle([_|T], ALLVERTICES, SUBRES) :-
    dropWithCycle(T, ALLVERTICES, SUBRES).


/* --------------------------- */


getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT) :-
    length(ALLVERTICES, LEN),
    SPANEDGECOUNT is LEN - 1.

main :-
    input2:start_load_input(EDGES),
    uniqueArray(EDGES, ALLVERTICES),
    getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT),
    findall(K, noRepeatCombination(SPANEDGECOUNT, EDGES, K), CANDIDATES),
    dropWithCycle(CANDIDATES, ALLVERTICES, SPANNINGTREES),
    write(CANDIDATES),
    halt.
