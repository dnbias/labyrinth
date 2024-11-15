%% gameState(monster(pos(_,_)),
%%           gems([]),
%%           ice_blocks([]),
%%           hammer(pos(_,_))).


applicabile(nord,gameState(S)):-

    num_righe(N),
    Y < N-1,
    Yup is Y+1,
    \+occupata(pos(X,Yup)).

applicabile(sud,monster(pos(X,Y))):-
    Y > 0,
    Ydown is Y-1,
    \+occupata(pos(X,Ydown)).

applicabile(est,monster(pos(X,Y))):-
    num_colonne(N),
    X < N-1,
    Xdx is X+1,
    \+occupata(pos(Xdx,Y)).

applicabile(ovest,monster(pos(X,Y))):-
    X > 0,
    Xsx is X-1,
    \+occupata(pos(Xsx,Y)).

monster(pos(X,Y)):-
    occupata(X,Y).
gem(pos(X,Y)):-
    occupata(X,Y).
ice(pos(X,Y)):-
    occupata(X,Y).
wall(pos(X,Y)):-
    occupata(X,Y).


trasforma(est,
          gameState(
              monster(pos(Xm,Ym)),
              gems(Gs),
              ice_blocks(Bs),
              hammer_pos(Xh,Ym))
          ),
          gameState(
              monster(pos(Xmr,Ym))
              gems(Gs),
              ice_blocks(Bs),
              hammer_pos(Xh,Ym))
          )
         ):-
    slide(est,monster)
    raycast(est,pos(Xm,Ym),pos(Xcollision,_)).
    Xmr is Xcollision-1.

trasforma(ovest,monster(X,Y),monster(Xsx,Y)):- Xsx is X-1.
trasforma(nord,monster(X,Y),monster(X,Yup)):- Yup is Y+1.
trasforma(sud,monster(X,Y),monster(X,Ydown)):- Ydown is Y-1.

raycast()
