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



main :-
    start_load_input(EDGES),
    uniqueArray(EDGES, ARRAY),
    length(ARRAY, LEN),
    EDGECOUNT is LEN - 1,
    getLenSubbags(EDGES, EDGECOUNT, LENSUBBAGS),
    write(LENSUBBAGS),
    halt.


[
    [1
        [[A],[D]],
        [[B],[C]],
        [[C],[D]]
    ],
    [2
        [[A],[C]],
        [[B],[C]],
        [[C],[D]]
    ],
    [3
        [[A],[C]],
        [[A],[D]],
        [[C],[D]]
    ],
    [4
        [[A],[C]],
        [[A],[D]],
        [[B],[C]]
    ],
    [5
        [[A],[B]],
        [[B],[C]],
        [[C],[D]]
    ],
    [6
        [[A],[B]],
        [[A],[D]],
        [[C],[D]]
    ],
    [7
        [[A],[B]],
        [[A],[D]],
        [[B],[C]]
    ],
    [8
        [[A],[B]],
        [[A],[C]],
        [[C],[D]]
    ],
    [9
        [[A],[B]],
        [[A],[C]],
        [[B],[C]]
    ],
    [10
        [[A],[B]],
        [[A],[C]],
        [[A],[D]]
    ]
]
