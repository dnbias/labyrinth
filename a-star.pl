search(Path):-
    iniziale(S0),
    empty_map(G_map),
    empty_map(F_map),
    empty_map(CameFrom_map),
    a_star(S0,G_map,CameFrom_map,Path).

a_star(Start,G_map,F_map,CameFrom_map,Path):-
    insert_ordmap(Start,0,G_map,NewG_map),
    finale(Goal),
    hScore(Start,Goal,H),
    insert_ordmap(Start,H,F_map,NewF_map),
    a_star_search([Start|nil],G_map,F_map,CameFrom_map,Goal,Path).

a_star_search([],_,_,_,[])!.
a_star_search(OpenSet,_,_,_,_,Path):-
    current(OpenSet,F_map,Current),
    finale(Current),!,
    recostructPath(Current,CF_map,Path).
a_star_search(OpenSet,G_map,F_map,CF_map,Goal,Path):-
    current(OpenSet,F_map,Current),
    applicabile(Az,Current),
    trasforma(Az,Current,Neighbor),

    gScore(Current,Goal,G_map,G_curr),
    G_tentative is G_curr+1,
    gScore(Neighbor,Goal,G_map,G_neighbor),
    G_tentative < G_neighbor,

    update_ordmap(Neighbor,Current,CF_map,NewCF_map),
    update_ordmap(Neighbor,G_tentative,G_map,NewG_map),

    hScore(Neighbor, Goal, H),

    F is H + G_tentative,
    update_ordmap(Neighbor,F,F_map,NewF_map),
    a_star_search([Neighbor|OpenTail],NewG_map,NewF_map,NewCF_map,Goal,Path).

reconstructPath(S,CF_map,Path):-
    recostruct(P,CF_map,[],Path).
recostruct(S0,_,Temp,Temp):-
    iniziale(S0).
recostruct(S,CF_map,Temp,R):-
    lookup_ordmap(S,CF_map,P),
    recostruct(P,CF_map,[S|Temp],R).

current(OpenSet,F_map,R):-
    curr(OpenSet,F_map,99999,R).
curr([],_,Temp,Temp).
curr([S|OpenSet],F_map,Temp,R):-
    lookup_ordmap(S,F_map,F),
    F < Temp,
    curr(OpenSet,F_map,F,R).
curr([S|OpenSet],F_map,Temp,R):-
    curr(OpenSet,F_map,Temp,R).

/* cost of the cheapest path from start to n currently known */
gScore(S0,S0,_,0).
gScore(_,S,Map,99999):-
    /+member_ordmap(Map,S,_).
gScore(_,S,Map,Score):-
    lookup_ordmap(S,Map,Score).

/* heuristic of the cheapest path from n to goal */
hScore(S,G,Score):-
    manhattan(S,G,Score).

/* our current best guess */
fScore(S0,S_map,G_map,Score):-
    gScore(S0,S_map,Score_g),
    hScore(S,G_map,Score_h),
    Score is Score_g+Score_h.

manhattan(pos(Sx,Sy),pos(Gx,Gy),Score):-
    abs(Sx-Gx,Rx),
    abs(Sy-Gy,Ry),
    Score is Rx+Ry.

abs(A,R):-
    A>=0,
    R is A.
abs(A,R):-
    A < 0,
    R is -A.
