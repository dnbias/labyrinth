applicabile(nord,pos(X,Y)):-
    num_righe(N),
    Y < N-1,
    Yup is Y+1,
    \+occupata(pos(X,Yup)).

applicabile(sud,pos(X,Y)):-
    Y > 0,
    Ydown is Y-1,
    \+occupata(pos(X,Ydown)).

applicabile(est,pos(X,Y)):-
    num_colonne(N),
    X < N-1,
    Xdx is X+1,
    \+occupata(pos(Xdx,Y)).

applicabile(ovest,pos(X,Y)):-
    X > 0,
    Xsx is X-1,
    \+occupata(pos(Xsx,Y)).

trasforma(est,pos(X,Y),pos(Xdx,Y)):- Xdx is X+1.
trasforma(ovest,pos(X,Y),pos(Xsx,Y)):- Xsx is X-1.
trasforma(nord,pos(X,Y),pos(X,Yup)):- Yup is Y+1.
trasforma(sud,pos(X,Y),pos(X,Ydown)):- Ydown is Y-1.

/* heuristic of the cheapest path from n to goal */
hScore(S,G,Score):-
    manhattan(S,G,Score).

manhattan(pos(Sx,Sy),pos(Gx,Gy),Score):-
    abs(Gx-Sx,Rx),
    abs(Gy-Sy,Ry),
    Score is Rx+Ry.

findAction(pos(X1,_),pos(X2,_),est):-
    X1 < X2,!.
findAction(pos(X1,_),pos(X2,_),ovest):-
    X1 > X2,!.
findAction(pos(_,Y1),pos(_,Y2),nord):-
    Y1 < Y2,!.
findAction(pos(_,Y1),pos(_,Y2),sud):-
    Y1 > Y2,!.
