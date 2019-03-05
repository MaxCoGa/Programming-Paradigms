
distanceEuclid( X, Y, D ) :- distanceEuclid( X, Y, 0, DD),
	D is sqrt( DD ). 

distanceEuclid( [],[],A,A). 


distanceEuclid( [HX|TX],[HY|TY],A,D)  :-
	AA is A + (HX - HY)*(HX - HY),
	distanceEuclid(TX,TY,AA,D).




distanceEuclidM( X, Y, D ) :- distanceEuclidM( X, Y, 0, DD),
	D is sqrt( DD ). 

distanceEuclidM( [],[],A,A). 

distanceEuclidM( [HX|TX],[],A,D)  :-
	AA is A + HX * HX,
	distanceEuclidM(TX,[],AA,D).

distanceEuclidM( [],[HY|TY],A,D)  :-
	AA is A + HY * HY,
	distanceEuclidM([],TY,AA,D).

distanceEuclidM( [HX|TX],[HY|TY],A,D)  :-
	AA is A + HX * HY,
	distanceEuclidM(TX,TY,AA,D).
