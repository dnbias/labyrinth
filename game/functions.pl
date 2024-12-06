raycast(est, pos(X,Y),pos(Xc,Y)):-
    Xc is X+1,
    cols(C),
    Xc == C,!.
raycast(est, pos(X,Y),pos(Xc,Y)):-
    Xc is X+1,
    wall(pos(Xc,Y)),!.
raycast(est, pos(X,Y),pos(Xc,Y)):-
    raycast(est, pos(X+1,Y),pos(Xc,Y)).
raycast(ovest, pos(X,Y),pos(Xc,Y)):-
    Xc is X-1,
    Xc == -1,!.
raycast(ovest, pos(X,Y),pos(Xc,Y)):-
    Xc is X-1,
    wall(pos(Xc,Y)),!.
raycast(ovest, pos(X,Y),pos(Xc,Y)):-
    raycast(ovest, pos(X-1,Y),pos(Xc,Y)).
raycast(nord, pos(X,Y),pos(X,Yc)):-
    Yc is Y+1,
    rows(R),
    Yc == R,!.
raycast(nord, pos(X,Y),pos(X,Yc)):-
    Yc is Y+1,
    wall(pos(X,Yc)),!.
raycast(nord, pos(X,Y),pos(X,Yc)):-
    raycast(nord, pos(X,Y+1),pos(X,Yc)).
raycast(sud, pos(X,Y),pos(X,Yc)):-
    Yc is Y-1,
    Yc == -1,!.
raycast(sud, pos(X,Y),pos(X,Yc)):-
    Yc is Y-1,
    wall(pos(X,Yc)),!.
raycast(sud, pos(X,Y),pos(X,Yc)):-
    raycast(sud, pos(X,Y-1),pos(X,Yc)).

getMonster(gameState(monster(M),_,_,_,_),M).
getGems(gameState(_,gems(Gs),_,_,_),Gs).
getBlocks(gameState(_,_,ice_blocks(Bs),_,_),Bs).
getHammer(gameState(_,_,_,hammer(H),_),H).

/* heuristic of the cheapest path from n to goal */
/*
The heuristic can be used to control A*’s behavior.

At one extreme, if h(n) is 0, then only g(n) plays a role, and A* turns into Dijkstra’s Algorithm, which is guaranteed to find a shortest path.
If h(n) is always lower than (or equal to) the cost of moving from n to the goal,
then A* is guaranteed to find a shortest path. The lower h(n) is, the more node A* expands, making it slower.
If h(n) is exactly equal to the cost of moving from n to the goal,
then A* will only follow the best path and never expand anything else, making it very fast.
If h(n) is sometimes greater than the cost of moving from n to the goal,
then A* is not guaranteed to find a shortest path, but it can run faster.
At the other extreme, if h(n) is very high relative to g(n), then only h(n) plays a role, and A* turns into Greedy Best-First-Search.
*/
hScore(S,_,Score):-
    getMonster(S,pos(Xm,Ym)),
    portal(pos(Xp,Yp)),
    abs(Xm - Xp,Xdiff),
    abs(Ym - Yp,Ydiff),
    (
        Xdiff > 0
    ->
        Xscore is 1
    ;
        Xscore is 0
    ),
    (
        Ydiff > 0
    ->
        Yscore is 1
    ;
        Yscore is 0
    ),
    Score is Xscore + Yscore.

abs(A,A):-
    A>=0,!.
abs(A,-A).

findAction(S1,S2,est):-
    getMonster(S1,pos(X1,_)),
    getMonster(S2,pos(X2,_)),
    X1 < X2.
findAction(S1,S2,ovest):-
    getMonster(S1,pos(X1,_)),
    getMonster(S2,pos(X2,_)),
    X1 > X2.
findAction(S1,S2,nord):-
    getMonster(S1,pos(_,Y1)),
    getMonster(S2,pos(_,Y2)),
    Y1 < Y2.
findAction(S1,S2,sud):-
    getMonster(S1,pos(_,Y1)),
    getMonster(S2,pos(_,Y2)),
    Y1 > Y2.
