empty_map(nil).

lookup_ordmap(K, t(X,Y,L,R), V) :-
    (K == X ->
        V = Y
    ; K @< X ->
        lookup_ordmap(K,L,V)
    ;
        lookup_ordmap(K,R,V)
    ).

remove_ordmap(K, t(X,Y,L0,R), t(X,Y,L,R), V) :-
    K @< X,
    remove_ordmap(K,L0,L,V).
remove_ordmap(K, t(X,Y,L,R0), t(X,Y,L,R), V) :-
    K @> X,
    remove_ordmap(K,R0,R,V).
remove_ordmap(K, t(X,V,L,R), T, V) :-
    K == X,
    (L == nil ->
        T = R
    ; R == nil ->
        T = L
    ;
        rm_max(L,L1,K1,V1),
        T = t(K1,V1,L1,R)
    ).

update_ordmap(K, V, nil, t(K,V,nil,nil)).
update_ordmap(K, V, t(K,_,L,R), t(K,V,L,R)).
update_ordmap(K, V, t(X,Y,L0,R), t(X,Y,L,R)) :-
    K @< X,
    update_ordmap(K,V,L0,L).
update_ordmap(K, V, t(X,Y,L,R0), t(X,Y,L,R)) :-
    K @> X,
    update_ordmap(K,V,R0,R).

rm_max(t(K,V,L,nil), L, K, V) :- !.
rm_max(t(X,Y,L,R0), t(X,Y,L,R), K, V) :-
    rm_max(R0,R,K,V).

insert_ordmap(K, V, nil, t(K,V,nil,nil)).
insert_ordmap(K, V, t(X,Y,L0,R), t(X,Y,L,R)) :-
    K @< X,
    insert_ordmap(K,V,L0,L).
insert_ordmap(K, V, t(X,Y,L,R0), t(X,Y,L,R)) :-
    K @> X,
    insert_ordmap(K,V,R0,R).

member_ordmap(t(X,Y,L,R), K, V) :-
    member_ordmap(L,K,V) ;
    (X=K, Y=V) ;
    member_ordmap(R,K,V).

size_ordmap(nil, 0).
size_ordmap(t(_,_,L,R), N) :-
    size_ordmap(L,NL),
    size_ordmap(R,NR),
    N is NL+NR+1.
