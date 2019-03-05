mulTable(L,H,N,R) :- 
	L =< H,
	R is L * N.

mulTable(L,H,N,R) :-
	L<H,
	LL is L+1,
	mulTable( LL,H,N,R).


mulTableC(L,H,_,_) :- 
	L > H, !, fail.

mulTableC(L,L,N,R) :-
	R is L * N, !.

mulTableC(L,_,N,R) :- 
	R is L * N.

mulTableC(L,H,N,R) :-
	LL is L+1,
	mulTableC(LL,H,N,R).


