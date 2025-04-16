:- use_module(input2).

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


main :-
    start_load_input(Content),
    uniqueArray(Content, Array),
    length(Array, Count),
    write(Count),
    halt.