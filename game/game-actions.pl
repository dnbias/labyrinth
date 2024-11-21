%% gameState(monster(pos(_,_)),
%%           gems([]),
%%           ice_blocks([]),
%%           hammer(pos(_,_))).
applicabile(est,gameState(monster(pos(X,Y)),_,_,_)):-
    num_colonne(N),
    X < N-1,
    Xdx is X+1,
    \+occupata(pos(Xdx,Y)).
applicabile(ovest,gameState(monster(pos(X,Y)),_,_,_)):-
    X > 0,
    Xsx is X-1,
    \+occupata(pos(Xsx,Y)).
applicabile(nord,gameState(monster(pos(X,Y)),_,_,_)):-
    num_righe(N),
    Y < N-1,
    Yup is Y+1,
    \+occupata(pos(X,Yup)).
applicabile(sud,gameState(monster(pos(X,Y)),_,_,_)):-
    Y > 0,
    Ydown is Y-1,
    \+occupata(pos(X,Ydown)).

trasforma(D,S,
          gameState(
              monster(pos(Xmr,Ymr)),
              gems(Grs),
              ice_blocks(Brs),
              hammer(pos(Xh,Yh))
          )
         ):-
    trasfMonster(D,S,pos(Xmr,Ymr)),
    %% check if taken hammer
    trasfGems(D,S,Grs),
    trasfIceBlocks(D,S,Brs).

trasfMonster(D,S,pos(Xmr,Ymr)):-
    getMonster(S,pos(Xm,Ym)),
    objectOrder(D,S,pos(Xm,Ym),N),
    raycast(D,pos(Xm,Ym),pos(Xc,Yc)),
    trasfRes(D,Xc,Yc,N,Xmr,Ymr).
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
    Xr is Xc-N.
trasfRes(ovest,Xc,Yc,N,Xr,Yc):-
    Xr is Xc+N.
trasfRes(nord,Xc,Yc,N,Xc,Yr):-
    Yr is Yc-N.
trasfRes(sud,Xc,Yc,N,Xc,Yr):-
    Yr is Yc+N.

objectOrder(D,S,pos(X,Y),Nm):-
    raycast(D,pos(X,Y),pos(Xc,Yc)),
    countObjects(D,S,X,Y,Xc,Yc,Nm).

countObjects(_,_,X,Y,X,Y,0).
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
object(X,Y,gems([]),ice_blocks([ice(pos(X,Y))|_]),_).
object(X,Y,gems([]),ice_blocks([ice(pos(Xi,Yi))|Is]),H):-
    \+pos(X,Y) == pos(Xi,Yi),
    object(X,Y,[],ice_blocks(Is),H).
object(X,Y,gems([gem(pos(X,Y))|_]),_,_).
object(X,Y,gems([gem(pos(Xg,Yg))|Gs]),Is,H):-
    \+pos(X,Y) == pos(Xg,Yg),
    object(X,Y,gems(Gs),Is,H).

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

getMonster(gameState(monster(M),_,_,_),M).
getGems(gameState(_,gems(Gs),_,_),Gs).
getBlocks(gameState(_,_,ice_blocks(Bs),_),Bs).
getHammer(gameState(_,_,_,hammer(H)),H).
