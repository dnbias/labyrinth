:- use_module(library(lists)).

search(Path):-
    iniziale(S0),
    empty_map(G_map),
    empty_map(F_map),
    empty_map(CameFrom_map),
    a_star(S0,G_map,F_map,CameFrom_map,Path).

a_star(Start,G_map,F_map,CameFrom_map,Path):-
    finale(Goal),
    hScore(Start,Goal,H),
    insert_ordmap(Start,0,G_map,NewG_map),
    insert_ordmap(Start,H,F_map,NewF_map),
    a_star_search([Start],NewG_map,NewF_map,CameFrom_map,Goal,[],Path).

a_star_search([],_,_,_,_,_,[]).
a_star_search(OpenSet,_,F_map,CF_map,_,_,Path):-
    current(OpenSet,F_map,Current),
    finale(Current),!,
    iniziale(S0),
    reconstructPath(Current,CF_map,PathStates),
    reconstructActions([S0|PathStates],Path).
a_star_search(OpenSet0,G_map,F_map,CF_map,Goal,Visited,Path):-
    diff(OpenSet0,Visited,OpenSet),
    current(OpenSet,F_map,Current),
    %% \+finale(Current),!,
    subtract(OpenSet,[Current],NewOpenSet),
    \+member(Current,Visited),!,
    findall(Az,applicabile(Az,Current),ListAz),
    neighbors(Current,ListAz,Neighbors0),
    diff(Neighbors0,Visited,Neighbors1),
    diff(Neighbors1,NewOpenSet,StatesToAdd),
    append(NewOpenSet,StatesToAdd,OS),
    gScore(Current,Goal,G_map,G_curr),
    G_tentative is G_curr+1,
    a_star_search_neighbors(Current,G_tentative,G_map,F_map,CF_map,Goal,StatesToAdd,NewG_map,NewF_map,NewCF_map),
    a_star_search(OS,NewG_map,NewF_map,NewCF_map,Goal,[Current|Visited],Path).

a_star_search_neighbors(_,_,G_map,F_map,CF_map,_,[],G_map,F_map,CF_map).
a_star_search_neighbors(Current,G_tentative,G_map,F_map,CF_map,G,[N|Neighbors],NewG_map,NewF_map,NewCF_map):-
    gScore(N,G,G_map,G_neighbor),
    /* heuristic of the cheapest path from n to goal */
    hScore(N, G, H),
    F is H + G_tentative,
    (
        G_tentative < G_neighbor
    ->
        %% if member ordmap update else insert
        (
            member_ordmap(G_map,N,_)
        ->
            update_ordmap(N,Current,CF_map,NewCF_map1),
            update_ordmap(N,G_tentative,G_map,NewG_map1),
            update_ordmap(N,F,F_map,NewF_map1)
        ;
            insert_ordmap(N,Current,CF_map,NewCF_map1),
            insert_ordmap(N,G_tentative,G_map,NewG_map1),
            insert_ordmap(N,F,F_map,NewF_map1)
        ),
        a_star_search_neighbors(Current,G_tentative,NewG_map1,NewF_map1,NewCF_map1,G,Neighbors,NewG_map,NewF_map,NewCF_map)
    ;
        a_star_search_neighbors(Current,G_tentative,G_map,F_map,CF_map,G,Neighbors,NewG_map,NewF_map,NewCF_map)
    ).

reconstructPath(S,CF_map,Path):-
    reconstruct(S,CF_map,[],Path).
reconstruct(S0,_,Temp,Temp):-
    iniziale(S0).
reconstruct(S,CF_map,Temp,R):-
    lookup_ordmap(S,CF_map,P),
    reconstruct(P,CF_map,[S|Temp],R).

reconstructActions(Ss,Path):-
    recAct(Ss,[],Path).
recAct([S1|[S2|Ss]],Temp,R):-
    findAction(S1,S2,Az),
    append(Temp,[Az],T),
    recAct([S2|Ss],T,R).
recAct([S],Temp,Temp).


current(OpenSet,F_map,R):-
    curr(OpenSet,F_map,99999,_,R).
curr([],_,_,R,R).
curr([S|Tail],F_map,TempF,_,R):-
    lookup_ordmap(S,F_map,F),
    F < TempF,!,
    curr(Tail,F_map,F,S,R).
curr([_|Tail],F_map,TempF,TempR,R):-
    curr(Tail,F_map,TempF,TempR,R).

neighbors(S,AzList,R):-
    neigh(S,AzList,[],R).
neigh(_,[],Temp,Temp).
neigh(S,[A|T],Temp,R):-
    trasforma(A,S,S1),
    neigh(S,T,[S1|Temp],R).


/* cost of the cheapest path from start to n currently known */
gScore(S,_,Map,99999):-
    \+member_ordmap(Map,S,_),!.
gScore(S,_,Map,Score):-
    lookup_ordmap(S,Map,Score).


/* our current best guess */
fScore(S,S_map,G_map,Score):-
    gScore(S,S_map,Score_g),
    hScore(S,G_map,Score_h),
    Score is Score_g+Score_h.


abs(A,A):-
    A>=0,!.
abs(A,-A).

diff(A,B,R):-
    diff0(A,B,[],R).
diff0([],_,Temp,Temp).
diff0([S|T],B,Temp,R):-
    \+member(S,B),!,
    diff0(T,B,[S|Temp],R).
diff0([_|T],B,Temp,R):-
    diff0(T,B,Temp,R).
