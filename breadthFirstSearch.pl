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

leadTo([V1,V2], V1, V2).
leadTo([V1,V2], V2, V1).

getAllNext([], _, [], []).
getAllNext([H|T], STARTVERTICE, [NEWVERTICE|TOVISIT], NEWEDGES) :-
    leadTo(H, STARTVERTICE, NEWVERTICE),
    getAllNext(T, STARTVERTICE, TOVISIT, NEWEDGES), !.
getAllNext([H|T], STARTVERTICE, TOVISIT, [H|NEWEDGES]) :-
    getAllNext(T, STARTVERTICE, TOVISIT, NEWEDGES).

popFst([], _, _) :- fail.
popFst([H|T], H, T).

breadthFirstSearch(_, _, [], []).
breadthFirstSearch(EDGES, STARTVERTICE, TOVISIT, [STARTVERTICE|RES]) :-
    getAllNext(EDGES, STARTVERTICE, NEWTOVISIT, NEWEDGES),
    append(TOVISIT, NEWTOVISIT, TOVISITRES),
    (popFst(TOVISITRES, FST, REST) ->
        breadthFirstSearch(NEWEDGES, FST, REST, RES)
    ;
        RES = []
    ).

getStart([[V1,_]|_], V1).

getLast([X], X) :- !.
getLast([_|T], RES) :-
    getLast(T, RES).

% Chci vracet pole potkaných vrcholů, protože ho potom v predikátu nad ním kontroluji se všemi prvky
breadthFirstSearchInit(CANDIDATE, RES) :-
    getStart(CANDIDATE, STARTVERTICE),
    findall(V, breadthFirstSearch(CANDIDATE, STARTVERTICE, [], V), SUBRES),
    getLast(SUBRES, RES).


dropWithCycle([], _, []).
dropWithCycle([H|T], ALLVERTICES, [H|SUBRES]) :-
    breadthFirstSearchInit(H, FOUNDVERTICES),
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
    onlyEdges(T, RES).
onlyEdges([_|T], RES) :-
    onlyEdges(T, RES).

/* --------------------------- */

getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT) :-
    length(ALLVERTICES, LEN),
    SPANEDGECOUNT is LEN - 1.

main :-
    input2:start_load_input(CONTENT), % načtení vstupních hran ve tvaru [[A,B],...]
    onlyEdges(CONTENT, EDGES), % z načteného vstupu vybrat pouze dvojice symbolů
    uniqueArray(EDGES, ALLVERTICES), % vybrat všechny unikátní symboly ze vstupu (vrcholy)
    getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT), % výpočet kolik hran bude mit každá kostra
    findall(K, noRepeatCombination(SPANEDGECOUNT, EDGES, K), CANDIDATES), % vygenerování kombinací bez opak z načtených hran ze vstupu (všechny kandidáty na kostry)
    dropWithCycle(CANDIDATES, ALLVERTICES, SPANNINGTREES), % prozkoumání všech kandidátů na kostru a vyřazení těch, které kostrami nejsou
    writeAllST(SPANNINGTREES), % výpis nalezených koster podle zadání
    halt.
