% name, game, score
score( 'Emma', 'FIFA18', 3 ).
score( 'Benjamin', 'Minecraft', 387 ).
score( 'Liam', 'The Legend of Zelda', 2200 ).
score( 'Ethan', 'Super Mario Odyssey', 15100 ).
score( 'Ava', 'Minecraft', 410 ).
score( 'Liam', 'Minecraft', 222 ).
score( 'Ava', 'The Legend of Zelda', 1900 ).

%setof score dans minecraft
%score(N,J,S)

%setof(X,N^score(N,'Minecraft',X),L).%pas de répétition
%findall(X,score('Liam',X,_),L).


%countGames( ['FIFA18', 'Minecraft', 'The Legend of Zelda', 'Super Mario Odyssey', 'Minecraft', 'Minecraft','The Legend of Zelda'], 'Minecraft', N).

countGames([],_,0):-
    !.

countGames([O|T],G,C):-
    O \= G,
    countGames(T,G,C).

countGames([G|T],G,C):-
    countGames(T,G,C1),
    C is C1+1.
    
%D.
popular( P ) :- findall( G, score(_,G,_),L),
                setof( G, N^S^score(N,G,S),LL),
                findMax( L, LL, P, _ ).

max( MG, MC, _, CC, MG, MC ) :- MC>CC, !.

max( _, _, G, C, G, C ) :- !.

findMax( _, [], 'None', 0 ) :- !.

findMax( L, [G|OG], M, C ) :- findMax( L, OG, MG, MC ), 
                                countGames( L, G, CC ),
                                max( MG, MC, G, CC, M, C ).