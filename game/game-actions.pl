%% gameState(monster(pos(_,_)),
%%           gems([]),
%%           ice_blocks([]),
%%           hammer(pos(_,_),
%%           finished(0/1)
%% )).
:- consult(functions).

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

trasforma(_,gameState(M,G,I,H,1),gameState(M,G,I,H,1)).
trasforma(D,S,
          gameState(
              monster(pos(Xmr,Ymr)),
              gems(Grs),
              ice_blocks([]),
              hammer(pos(-1,-1)),
              Finish
          )
         ):-
    getHammer(S,pos(-1,-1)),
    trasfMonster(D,S,pos(Xm,Ym),Finish),
    (
        Finish == 0
    ->
        Xmr is Xm,
        Ymr is Ym
    ;
        portal(pos(Xp,Yp)),
        Xmr is Xp,
        Ymr is Yp
    ),
    trasfGems(D,S,Grs).
trasforma(D,S,
          gameState(
              monster(pos(Xmr,Ymr)),
              gems(Grs),
              ice_blocks(Brs),
              hammer(pos(Xh,Yh)),
              Finish
          )
         ):-
    trasfMonster(D,S,pos(Xm,Ym),Finish),
    (
        Finish == 0
    ->
        Xmr is Xm,
        Ymr is Ym
    ;
        portal(pos(Xp,Yp)),
        Xmr is Xp,
        Ymr is Yp
    ),
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

trasfIceBlocks(_,S,[]):-
    getHammer(S,pos(Xh,_)),
    Xh < 0.
trasfIceBlocks(D,S,Brs):-
    getBlocks(S,Bs).
    %% trasfIB(D,S,Bs,[],Brs). %% stop from moving
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

