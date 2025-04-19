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