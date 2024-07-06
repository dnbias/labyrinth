search(Path,Threshold):-
    iniziale(S0),
    s_depth_lim(S0,Threshold,[],Path).

search_b(Path):-
    iniziale(S0),
    s_breadth([[S0,[]]],[],PathInv),
    inverti(PathInv,Path).

s_depth(S,_,[]):-finale(S),!.
s_depth(S,Visited,[Az|SeqAz]):-
    applicabile(Az,S),
    trasforma(Az,S,S2),
    \+member(S2,Visited),
    s_depth(S2,[S|Visited],SeqAz).

s_depth_lim(S,_,_,_,[]):-finale(S),!.
s_depth_lim(S,Threshold,Visited,[Az|SeqAz]):-
    Threshold > 0,
    applicabile(Az,S),
    trasforma(Az,S,S2),
    \+member(S2,Visited),
    ThresholdNew is Threshold-1,
    s_depth_lim(S2,ThresholdNew,[S|Visited],SeqAz).

s_breadth([[S,Path]|_],_,Path):-finale(S),!.
s_breadth([[S,Path]|Tail],Visited,Res):-
    \+member(S,Visited),!,
    findall(Az,applicabile(Az,S),ListAz),
    generateChildren([S,Path],ListAz,ListChildren),
    diff(ListChildren,Tail,StatesToAdd),
    append(Tail,StatesToAdd,TailNew),
    s_breadth(TailNew,[S|Visited],Res).
s_breadth([_|Tail],Visited,Res):-
    s_breadth(Tail,Visited,Res).

generateChildren(_,[],[]).
generateChildren([S,Path],[Az|Tail],[[S2,[Az|Path]]|ListTail]):-
    trasforma(Az,S,S2),
    generateChildren([S,Path],Tail,ListTail).

diff([],_,[]).
diff([[S,Path]|T],B,[[S,Path]|R]):-
    \+member([S,Path],B),!,
    diff(T,B,R).
diff([_,T],B,R):-
    diff(T,B,R).

inverti(L,R):-inv(L,[],R).
inv([],Temp,Temp).
inv([H|T],Temp,R):-
    inv(T,[H|Temp],R).
