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

deepSearch(STARTVERTICE, RES) :-
    (edge(STARTVERTICE, X) ->
        retract(edge(STARTVERTICE, X)),
        retract(edge(X, STARTVERTICE)),
        deepSearch(X, RES)
    ;
        !, RES = STARTVERTICE
    ).
deepSearch(STARTVERTICE, RES) :-
    deepSearch(STARTVERTICE, RES).
 
insertEdges([[V1,V2]|T], V1) :-
    insertEdges([[V1,V2]|T]).
insertEdges([]).
insertEdges([[V1,V2]|T]) :-
    assertz(edge(V1, V2)),
    assertz(edge(V2, V1)),
    insertEdges(T).

% Chci aby tento predikát vracel pole potkaných vrcholů, protože ho potom v predikátu nad ním kontroluji se všemi prvky
deepSearchInit(CANDIDATE, RES) :-
    insertEdges(CANDIDATE, STARTVERTICE),
    findall(V, deepSearch(STARTVERTICE, V), RES),
    retractall(edge(_,_)).

dropWithCycle([], _, []).
dropWithCycle([H|T], ALLVERTICES, [H|SUBRES]) :-
    deepSearchInit(H, FOUNDVERTICES),
    subset(ALLVERTICES, FOUNDVERTICES), % TODO: podívat se na subset, pokud vrátím jen 2 vrcholy v FOUNDVERTICES, tak to muze byt subset
    dropWithCycle(T, ALLVERTICES, SUBRES).
dropWithCycle([_|T], ALLVERTICES, SUBRES) :-
    dropWithCycle(T, ALLVERTICES, SUBRES).

/* --------------------------- */

/* Logika na výpis */

writeST([[V1,V2]]) :-
    format("~w-~w", [V1, V2]).
writeST([[V1,V2]|T]) :-
    format("~w-~w ", [V1, V2]),
    writeST(T).

writeAllST([]).
writeAllST([H|T]) :-
    writeST(H),
    write("\n"),
    writeAllST(T).

/* --------------------------- */

/* Kontrola vstupu */

onlyEdges([],[]).
onlyEdges([[V1,V2]|T], [[V1,V2]|RES]) :-
    !,
    onlyEdges(T, RES).
onlyEdges([_|T], RES) :-
    onlyEdges(T, RES).

/* --------------------------- */

getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT) :-
    length(ALLVERTICES, LEN),
    SPANEDGECOUNT is LEN - 1.

main :-
    input2:start_load_input(CONTENT),
    onlyEdges(CONTENT, EDGES),
    uniqueArray(EDGES, ALLVERTICES),
    getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT),
    findall(K, noRepeatCombination(SPANEDGECOUNT, EDGES, K), CANDIDATES),
    dropWithCycle(CANDIDATES, ALLVERTICES, SPANNINGTREES),
    writeAllST(SPANNINGTREES),
    halt.
