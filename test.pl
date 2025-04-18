noRepeatCombination(0, _, []) :- !.
noRepeatCombination(NUM, [H|T], [H|RES]) :-
    NUM > 0,
    DECNUM is NUM - 1,
    noRepeatCombination(DECNUM, T, RES).
noRepeatCombination(NUM, [_|T], RES) :-
    noRepeatCombination(NUM, T, RES).

main(N, POLE) :-
    findall(K, noRepeatCombination(N, POLE, K), Kombinace),
    write(Kombinace).