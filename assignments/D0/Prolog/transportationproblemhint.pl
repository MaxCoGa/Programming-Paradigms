:- use_module(library(simplex)).
cost(X):- 
	X =[[6,8,10],[7,11,11],[4,5,12]].
soli(X):- 
	X=[[0,10,20],[0,0,40],[40,10,0]].

%lire %nth0 prédéfinie
elementAt(M,(X,Y),E):- 
	nth0(X,M,R),
	nth0(Y,R,E).
	
%trouver un chemin utilisé dans une certaine matrice
%soli(X),nonutilise(X,C).
nonutilise(M, (X,Y)):-
	elementAt(M,(X,Y),0).
	%elementAt(M,(X,Y),E),
	%E=0.


utilise(M, (X,Y)):-
	elementAt(M,(X,Y),E),
	E\=0.
	
	
%route
circuit(M,[(X0,Y0),(X0,Y1),(X2,Y1), (X2,Y0)]) :-
	nonutilise(M,(X0,Y0)),
	utilise(M,(X0,Y1)),
	utilise(M,(X2,Y1)),
	X2\=X0,
	utilise(M,(X2,Y0)).
	
%marginal cost
%soli(X),circuit(X,C),cost(Y),coutmH(Y,C,T).
coutmH(M,[],0).
coutmH(M,[T|Q],C):-
	elementAt(M,T,C1),
	coutmV(M,Q,CM),
	C is C1+CM.
	
coutmV(M,[],0).
coutmV(M,[T|Q],C):-
	elementAt(M,T,C1),
	coutmH(M,Q,CM),
	C is CM-C1.

%lesscost(T,0,C,L).
lesscost(T,T1,C,L):-
	soli(X),
	circuit(X,C),
	cost(Y),
	coutmH(Y,C,T),
	T<T1,!,
	changesoli(X,C,L).
	
% M=[[0,10,20],[0,0,40],[40,10,0]], 
%C=[(0, 0),  (0, 1),  (2, 1),  (2, 0)],
%lesscost(T,0,C,L),changesoli(M,C,L).	
changesoli(Matrix,Circuit,Liste):-
	nsoliH(Matrix,Circuit,Liste),!.

%M=[[0,10,20],[0,0,40],[40,10,0]],C = [(0, 0),  (0, 1),  (2, 1),  (2, 0)], nsoliH(M,C,L).
nsoliH(M,[],0).
nsoliH(M,[T|Q],L):-
	elementAt(M,T,E),
	E1 is E+1,
	getXY(T,X,Y),
	replace(M,X,Y,E1,L),write(L),write("\n"),
	nsoliV(L,Q,L1).
	
nsoliV(M,[],0).
nsoliV(M,[T|Q],L):-
	elementAt(M,T,E),
	E1 is E-1,
	getXY(T,X,Y),
	replace(M,X,Y,E1,L),write(L),write("\n"),
	nsoliH(L,Q,L1).

%Get X and Y coordinate from T list
getXY((T,Q),X,Y):-
	X is T,
	Y is Q.
	
	
%assert add fait into db
%retract remove fait from db

%%%TEST%%%
% replace(M,X,Y,VALUE,L).
replace( [L|Ls] , 0 , Y , Z , [R|Ls] ) :- % once we find the desired row,
  replace_column(L,Y,Z,R)                 % - we replace specified column, and we're done.
  .                                       %
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :- % if we haven't found the desired row yet
  X > 0 ,                                 % - and the row offset is positive,
  X1 is X-1 ,                             % - we decrement the row offset
  replace( Ls , X1 , Y , Z , Rs )         % - and recurse down
  .                                       %

replace_column( [_|Cs] , 0 , Z , [Z|Cs] ) .  % once we find the specified offset, just make the substitution and finish up.
replace_column( [C|Cs] , Y , Z , [C|Rs] ) :- % otherwise,
  Y > 0 ,                                    % - assuming that the column offset is positive,
  Y1 is Y-1 ,                                % - we decrement it
  replace_column( Cs , Y1 , Z , Rs )         % - and recurse down.
  . 