mulTable(L,H,N,R) :-
	L =< H,
	R is L * N.

mulTable(L,H,N,R) :-
	L<H,
	LL is L+1,
	mulTable( LL,H,N,R).



