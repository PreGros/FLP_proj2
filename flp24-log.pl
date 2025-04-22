:- use_module(input2).

/* Kontrola vstupu */

%% onlyEdges(+InputEdges) is det.
%
% Prošetřuje vstupní hrany, jestli se jedná opravdu o
% dvojice dvou vrcholů.
%
% +InputEdges: Načtené hrany ze standardního vstupu.
%
onlyEdges([],[]).
onlyEdges([[V1,V2]|T], [[V1,V2]|RES]) :-
    onlyEdges(T, RES).
onlyEdges([_|T], RES) :-
    onlyEdges(T, RES).

/* --------------------------- */

/* Get unique */
%% tryPut(+Edge, +FoundUniqueArray, -NewUniqueArray) is det.
%
% Pomáhá pří vytváření pole unikátních vrcholů, zjistí zda-li prvky v poli
% jsou již v poli unikátních vrcholů a podle toho vloží nebo vynechá.
%
% +Edge: Hrana spojující vrcholy, které se vyzkouší vložit do pole unikátních vrcholů.
% +FoundUniqueArray: Dosavadní nalezené unikátní vrcholy.
% -NewUniqueArray: Výstupní pole unikátních vrcholů.
%
tryPut([], RECRES, RECRES).
tryPut([H|T],RECRES, RES) :-
    tryPut(T, RECRES, SUBRES),
    (memberchk(H,SUBRES) -> % předělat tento if spíš na prolog-like syntaxi (myšleno přidat misto toho třetí volání tryPut podobně jak noRepeatCombination)
        RES = SUBRES
    ;
        RES = [H|SUBRES]
    ).

%% uniqueArray(+Edges, -UniqueArray) is det.
%
% Vytváří pole unikátních vrcholů ze zadaného pole polí.
%
% +Edges: Vstupní pole hran, ze kterých se získávají vrcholy hran. 
% -UniqueArray: Pole nalezených unikátních vrcholů.
%
uniqueArray([], []).
uniqueArray([H|T], RES) :-
    uniqueArray(T, RECRES),
    tryPut(H, RECRES, RES).
/* --------------------------- */

/* Lepší způsob generování kombinací o určité velikosti */

%% noRepeatCombination(+N, +InputList, -Candidates) is nondet.
%
% Vygeneruje kombinaci N prvků z InputList bez opakování pomocí
% hlubokého prohledávání s omezenou hloubkou.
%
% +N: Počet prvků v kombinaci.
% +InputList: Vstupní seznam, ze kterého se generují kombinace.
% -Candidates: Výsledná kombinace.
%
noRepeatCombination(0, _, []) :- !.
noRepeatCombination(NUM, [H|T], [H|RES]) :-
    NUM > 0,
    DECNUM is NUM - 1,
    noRepeatCombination(DECNUM, T, RES).
noRepeatCombination(NUM, [_|T], RES) :-
    noRepeatCombination(NUM, T, RES).

/* --------------------------- */

/* Hledání cyklů */

%% deepSearch(+StartVertex, -FoundVertex) is nondet.
%
% Prohledává stavový prostor stylem hlubokého prohlédávání.
% Vrací zpět vrchol, do kterého se lze dostat a nejde z něho již jinou cestou dál.
% Po použití hrany ji hned vyřadí, aby nedošlo k zacyklení.
% Hrany jsou dynamicky odstraněny z databáze (obě orientace).
%
% +StartVertex: Startovací vrchol, ze kterého se spouští prohledávání.
% -FoundVertex: Nalezený vrchol, ze kterého se nelze již dál dostat.
%
deepSearch(STARTVERTEX, RES) :-
    (edge(STARTVERTEX, X) ->
        retract(edge(STARTVERTEX, X)),
        retract(edge(X, STARTVERTEX)),
        deepSearch(X, RES)
    ;
        !, RES = STARTVERTEX
    ).
deepSearch(STARTVERTEX, RES) :-
    deepSearch(STARTVERTEX, RES).
 
%% insertEdges(+Edges, -FirstVertex) is det.
%% insertEdges(+Edges) is det.
%
% Vkládá predikáty hran dynamicky do databáze jak z jedné strany, tak z druhé.
% Nejdříve se volá insertEdges/2, aby vrátil první vrchol z první
% hrany, jinak se dále rekurzivně volá už jen insertEdges/1.
%
% +Edges: Vstupní hrany, které se mají vložit do databáze.
% -FirstVertex: První vrchol z první hrany jako startovací pro prohledávání.
%
insertEdges([[V1,V2]|T], V1) :-
    insertEdges([[V1,V2]|T]).
insertEdges([]).
insertEdges([[V1,V2]|T]) :-
    assertz(edge(V1, V2)),
    assertz(edge(V2, V1)),
    insertEdges(T).

%% deepSearchInit(+Candidate, -FoundVertices) is det.
% 
% Vrací všechny nalezené vrcholy predikátem deepSearch.
%
% +Candidate: Kandidát na kostru grafu, obsahuje jednotlivé hrany.
% -FoundVertices: Nalezené vrcholy průchodem.
%
deepSearchInit(CANDIDATE, RES) :-
    insertEdges(CANDIDATE, STARTVERTEX),
    findall(V, deepSearch(STARTVERTEX, V), RES),
    retractall(edge(_,_)).

%% dropWithCycle(+SpanTreeCandidates, +AllVertices, -SpanTrees) is det.
%
% Kontroluje kanditáty na kostru grafu porovnáním vrcholů nalezenými
% pomocí prohledávání statového prostoru se všemi vrcholy grafu.
%
% +SpanTreeCandidates: Jednotlivý kandidáti na kostru grafu
% +AllVertices: Všechny hrany vstupního grafu
% -SpanTrees: Výsledné kostry grafu.
%
dropWithCycle([], _, []).
dropWithCycle([H|T], ALLVERTICES, [H|SUBRES]) :-
    deepSearchInit(H, FOUNDVERTICES),
    subset(ALLVERTICES, FOUNDVERTICES), % TODO: podívat se na subset, pokud vrátím jen 2 vrcholy v FOUNDVERTICES, tak to muze byt subset
    dropWithCycle(T, ALLVERTICES, SUBRES).
dropWithCycle([_|T], ALLVERTICES, SUBRES) :-
    dropWithCycle(T, ALLVERTICES, SUBRES).

/* --------------------------- */

/* Logika na výpis */

%% writeST(+Edges) is det.
%
% Výpis jednotlivých hran výstupní kostry grafu na standardní výstup.
%
% +Edges: Hrany výstupní kostry grafu.
%
writeST([[V1,V2]]) :-
    format("~w-~w", [V1, V2]).
writeST([[V1,V2]|T]) :-
    format("~w-~w ", [V1, V2]),
    writeST(T).

%% writeAllST(+SpanningTrees) is det.
%
% Vkládá do výpisu jednotlivé kostry grafu a odděluje je novým řádkem.
% Na konci výpisu je nový řádek.
%
% +SpanningTrees: Výstupní kostry grafu.
%
writeAllST([]).
writeAllST([H|T]) :-
    writeST(H),
    write("\n"),
    writeAllST(T).

/* --------------------------- */

%% getSpanEdgeCount(+AllVertices, -SpanTreeEdgeCount) is det.
%
% Pomocná funkce pro vrácení čísla, které udává jak dlouhá je každá kostra u
% daného grafu.
%
% +AllVertices: Všechny vrcholy daného grafu.
% -SpanTreeEdgeCount: Počet hran u každé kostry daného grafu.
%
getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT) :-
    length(ALLVERTICES, LEN),
    SPANEDGECOUNT is LEN - 1.

main :-
    input2:start_load_input(CONTENT), % Načtení vstupních hran ve tvaru [[A,B],...].
    onlyEdges(CONTENT, EDGES), % Z načteného vstupu vybrat pouze dvojice vrcholů-
    uniqueArray(EDGES, ALLVERTICES), % Vybrat všechny unikátní vrcholy ze vstupu.
    getSpanEdgeCount(ALLVERTICES, SPANEDGECOUNT), % Výpočet kolik hran bude mit každá kostra.
    findall(K, noRepeatCombination(SPANEDGECOUNT, EDGES, K), CANDIDATES), % Vygenerování kombinací bez opak z načtených hran ze vstupu (kandidáti na kostry).
    dropWithCycle(CANDIDATES, ALLVERTICES, SPANNINGTREES), % Prozkoumání všech kandidátů na kostru a vyřazení těch, které kostrami nejsou.
    writeAllST(SPANNINGTREES), % Výpis nalezených koster podle zadání.
    halt.
