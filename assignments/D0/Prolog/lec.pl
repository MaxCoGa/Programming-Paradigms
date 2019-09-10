notre-insert(A,L,[A|L]).
notre-insert(A,[X|L],[X|LL]:-
             notre-insert(A,L,LL).



nonegal([]).
nonegal([_|[]]).
nonegal([T|[T2|Q]]):-
    T=\T2,
    nonegal([T2|Q]).


