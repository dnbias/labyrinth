%% gameState(monster(pos(_,_)),
%%           gems([]),
%%           ice_blocks([]),
%%           hammer(pos(_,_),
%%           finished(0/1)
%% )).

occupata(pos(X,Y)):-
    wall(pos(X,Y)).

applicabile(est,gameState(monster(pos(X,Y)),_,_,_,_)):-
    cols(N),
    X < N-1,
    Xdx is X+1,
    \+occupata(pos(Xdx,Y)).
applicabile(ovest,gameState(monster(pos(X,Y)),_,_,_,_)):-
    X > 0,
    Xsx is X-1,
    \+occupata(pos(Xsx,Y)).
applicabile(nord,gameState(monster(pos(X,Y)),_,_,_,_)):-
    rows(N),
    Y < N-1,
    Yup is Y+1,
    \+occupata(pos(X,Yup)).
applicabile(sud,gameState(monster(pos(X,Y)),_,_,_,_)):-
    Y > 0,
    Ydown is Y-1,
    \+occupata(pos(X,Ydown)).

trasforma(D,
          gameState(M,G,I,H,1),
          gameState(M,G,I,H,1)).
trasforma(D,S,
          gameState(
              monster(pos(Xmr,Ymr)),
              gems(Grs),
              ice_blocks(Brs),
              hammer(pos(Xh,Yh)),
              Finish
          )
         ):-
    trasfMonster(D,S,pos(Xmr,Ymr),Finish),
    checkHammer(S,Xmr,Ymr,Xh,Yh),
    trasfGems(D,S,Grs),
    trasfIceBlocks(D,S,Brs).

trasfMonster(D,S,pos(Xmr,Ymr),Finish):-
    getMonster(S,pos(Xm,Ym)),
    objectOrder(D,S,pos(Xm,Ym),N),
    raycast(D,pos(Xm,Ym),pos(Xc,Yc)),
    trasfRes(D,Xc,Yc,N,Xmr,Ymr),
    checkFinish(Xm,Ym,Xmr,Ymr,Finish),!.

%% 0 continue
%% 1 gameover
checkFinish(Xm,Ym,_,_,0):-
    portal(pos(Xp,Yp)),
    Xm =\= Xp,
    Ym =\= Yp.
checkFinish(Xm,Ym,Xmr,_,1):-
    portal(pos(Xp,Yp)),
    Ym == Yp,
    Xm < Xp,
    Xmr >= Xp.
checkFinish(Xm,Ym,Xmr,_,1):-
    portal(pos(Xp,Yp)),
    Ym == Yp,
    Xmr =< Xp,
    Xm > Xp.
checkFinish(Xm,Ym,_,Ymr,1):-
    portal(pos(Xp,Yp)),
    Xm == Xp,
    Ym < Yp,
    Ymr >= Yp.
checkFinish(Xm,Ym,_,Ymr,1):-
    portal(pos(Xp,Yp)),
    Xm == Xp,
    Ymr =< Yp,
    Ym > Yp.
checkFinish(_,_,_,_,0).

%% if X,Y == -1,-1 hammer taken
checkHammer(S,_,_,X,Y):-
    getHammer(S,pos(X,Y)),
    X < 0,
    Y < 0.
checkHammer(S,Xmr,_,Xh,Yh):-
    getMonster(S,pos(Xm,Ym)),
    getHammer(S,pos(X,Y)),
    Ym == Y,
    Xm < X,
    Xmr >= X,
    Xh is -1,
    Yh is -1.
checkHammer(S,Xmr,_,Xh,Yh):-
    getMonster(S,pos(Xm,Ym)),
    getHammer(S,pos(X,Y)),
    Ym == Y,
    Xmr =< X,
    Xm > X,
    Xh is -1,
    Yh is -1.
checkHammer(S,_,Ymr,Xh,Yh):-
    getMonster(S,pos(Xm,Ym)),
    getHammer(S,pos(X,Y)),
    Xm == X,
    Ym < Y,
    Ymr >= Y,
    Xh is -1,
    Yh is -1.
checkHammer(S,_,Ymr,Xh,Yh):-
    getMonster(S,pos(Xm,Ym)),
    getHammer(S,pos(X,Y)),
    Xm == X,
    Ymr =< Y,
    Ym > Y,
    Xh is -1,
    Yh is -1.
checkHammer(S,_,_,X,Y):-
    getHammer(S,pos(X,Y)).

   
trasfGems(D,S,Grs):-
    getGems(S,Gs),
    trasfGs(D,S,Gs,[],Grs).
trasfGs(_,_,[],T,T).
trasfGs(D,S,[G|Gs],T,Grs):-
    trasfG(D,S,G,Gr),
    trasfGs(D,S,Gs,[Gr|T],Grs).
trasfG(D,S,gem(pos(X,Y)),gem(pos(Xr,Yr))):-
    objectOrder(D,S,pos(X,Y),N),
    raycast(D,pos(X,Y),pos(Xc,Yc)),
    trasfRes(D,Xc,Yc,N,Xr,Yr).
trasfIceBlocks(D,S,Brs):-
    getBlocks(S,Bs),
    trasfIB(D,S,Bs,[],Brs).
trasfIB(_,_,[],T,T).
trasfIB(D,S,[B|Bs],T,Brs):-
    trasfB(D,S,B,Br),
    trasfIB(D,S,Bs,[Br|T],Brs).
trasfB(D,S,ice(pos(X,Y)),ice(pos(Xr,Yr))):-
    objectOrder(D,S,pos(X,Y),N),
    raycast(D,pos(X,Y),pos(Xc,Yc)),
    trasfRes(D,Xc,Yc,N,Xr,Yr).

trasfRes(est,Xc,Yc,N,Xr,Yc):-
    Xr is Xc-N-1.
trasfRes(ovest,Xc,Yc,N,Xr,Yc):-
    Xr is Xc+N+1.
trasfRes(nord,Xc,Yc,N,Xc,Yr):-
    Yr is Yc-N-1.
trasfRes(sud,Xc,Yc,N,Xc,Yr):-
    Yr is Yc+N+1.

objectOrder(D,S,pos(X,Y),Nm):-
    raycast(D,pos(X,Y),pos(Xc,Yc)),
    countObjects(D,S,X,Y,Xc,Yc,Nm).

countObjects(_,_,X,Y,X,Y,0).
countObjects(_,_,X,_,_,_,0):-
    cols(C),
    X >= C,!.
countObjects(_,_,X,_,_,_,0):-
    X =< 0,!.
countObjects(_,_,_,Y,_,_,0):-
    rows(C),
    Y >= C,!.
countObjects(_,_,_,Y,_,_,0):-
    Y =< 0,!.
countObjects(est,S,X,Y,Xc,Yc,Rf):-
    object(X,Y,S),!,
    Xn is X+1,
    countObjects(est,S,Xn,Y,Xc,Yc,R),
    Rf is R+1.
countObjects(est,S,X,Y,Xc,Yc,R):-
    Xn is X+1,
    countObjects(est,S,Xn,Y,Xc,Yc,R).
countObjects(ovest,S,X,Y,Xc,Yc,Rf):-
    object(X,Y,S),!,
    Xn is X-1,
    countObjects(ovest,S,Xn,Y,Xc,Yc,R),
    Rf is R+1.
countObjects(ovest,S,X,Y,Xc,Yc,R):-
    Xn is X-1,
    countObjects(ovest,S,Xn,Y,Xc,Yc,R).
countObjects(nord,S,X,Y,Xc,Yc,Rf):-
    object(X,Y,S),!,
    Yn is Y+1,
    countObjects(nord,S,X,Yn,Xc,Yc,R),
    Rf is R+1.
countObjects(nord,S,X,Y,Xc,Yc,R):-
    Yn is Y+1,
    countObjects(nord,S,X,Yn,Xc,Yc,R).
countObjects(sud,S,X,Y,Xc,Yc,Rf):-
    object(X,Y,S),!,
    Yn is Y-1,
    countObjects(sud,S,X,Yn,Xc,Yc,R),
    Rf is R+1.
countObjects(sud,S,X,Y,Xc,Yc,R):-
    Yn is Y-1,
    countObjects(sud,S,X,Yn,Xc,Yc,R).

object(X,Y,gameState(monster(pos(X,Y)),_,_,_)).
object(X,Y,
      gameState(
          monster(pos(Xm,Ym)),
          Gs,Is,H)):-
    \+pos(X,Y) == pos(Xm,Ym),
    object(X,Y,Gs,Is,H).
object(X,Y,_,ice_blocks([ice(pos(X,Y))|_]),_).
object(X,Y,_,ice_blocks([ice(pos(Xi,Yi))|Is]),H):-
    \+pos(X,Y) == pos(Xi,Yi),
    object(X,Y,[],ice_blocks(Is),H).
%% object(X,Y,gems([gem(pos(X,Y))|_]),_,_).
%% object(X,Y,gems([gem(pos(Xg,Yg))|Gs]),Is,H):-
%%     \+pos(X,Y) == pos(Xg,Yg),
%%     object(X,Y,gems(Gs),Is,H).

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
