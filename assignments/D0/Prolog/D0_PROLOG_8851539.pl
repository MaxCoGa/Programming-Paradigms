%%CSI 2520 Devoir 0 PROLOG%%
%%Maxime Côté-Gagné  #8851539%%

% lire la valeur à la position(X,Y) donnée
index(M, X, Y, E):-
	nth0(X, M, R),
	nth0(Y, R, E).
	
%lire %nth0 prédéfinie
%elementAt(M,(X,Y),E):- 
%	nth0(X,M,R),
%	nth0(Y,R,E).

%liste de tous les chemins possible avec une cellule vide ou a 0
circuit(_, _, [], []).
circuit(D, S, [[X,Y]|T], [L|R]):-
	horizontale(S, X, 0, Y, [], RouteH),
	check([X, Y], S, RouteH, RouteV),%regarde pour voir si le verticale est disponible
	circuit(RouteV, RouteF),%ne pas tenir compte des resultats redundant
	circuit(D, S, T, R),
	fin(S, RouteF, L).
circuit([], []).
circuit([H|T], [H|Q]):-
	length(H, 3),
	circuit(T, Q).
circuit([_|T], Q):-
	circuit(T, Q).
	
%HINT: circuit(M,[(X0,Y0),(X0,Y1),(X2,Y1), (X2,Y0)])

%Renvoie la liste de route avec une fin
fin(_, [], []).
fin(F, [[[X, Y]|[HH,[XX, YY]]]|T], [Route|R]):-
	fin(F, T, R),
	index(F, XX,YY, E),
	atom_number(E, V),
	V > 0,
	Route = [[X, Y], HH, [XX, YY], [XX, Y]].

%Renvoie la liste des routes verticales en regardant au préalable si une telle route existe avec une cellule vide ou 0
check(_, _, [], []).
check(Position, S, [[X,Y]|T], [Route|R]):-
	check(Position, S, T, R),
	verticale(S, 0, Y, X, [], P),
	append([Position], [[X,Y]], P1), 
	append(P1, P, Route).
	
verticale(F, X, Y, XX, LL, L):-
	X == XX,
	XXX is XX + 1,
	verticale(F, XXX, Y, X, LL, L).
	
verticale(F, X, Y, XX, LL, L):-
	length(F, Len),
	X < (Len-1) -> (
		index(F, X, Y, E),
		atom_number(E, V),
		V > 0,
		LLL=[X,Y],
		XXX is X + 1, 
		verticale(F, XXX, Y, XX, [LLL|LL], L)
	); L=LL, !.
	
verticale(F, X, Y, XX, LL, L):-
	length(F, Len),
	X < (Len-1),
	XXX is X + 1, 
	verticale(F, XXX, Y, XX, LL, L).
	
%Permet d'effectuer une route en horizontale même strcuture que la verticale
horizontale(H, X, Y, YY, LL, L):-
	Y == YY,
	YYY is YY + 1,
	horizontale(H, X, YYY, Y, LL, L). %verticale(F, XXX, Y, X, LL, L).
	
horizontale([H|T], X, Y, YY, LL, L):-
	length(H, Len),
	Y < (Len-1) -> (
		index([H|T], X, Y, E),
		atom_number(E, V),
		V > 0,
		LLL=[X,Y],
		YYY is Y + 1, 
		horizontale([H|T], X, YYY, YY, [LLL|LL], L)
	); L=LL, !.
	
horizontale([H|T], X, Y, YY, LL, L):-
	length(H, Len),
	Y < (Len-1),
	YYY is Y + 1, 
	horizontale([H|T], X, YYY, YY, LL, L).
	
%%%%%%%%%%%%%%%%%%%%%
%nsoliH(M,[],0).
%nsoliH(M,[T|Q],L):-
%	elementAt(M,T,E),
%	E1 is E+1,
%	getXY(T,X,Y),
%	replace(M,X,Y,E1,L),write(L),write("\n"),
%	nsoliV(L,Q,L1).	
%nsoliV(M,[],0).
%nsoliV(M,[T|Q],L):-
%	elementAt(M,T,E),
%	E1 is E-1,
%	getXY(T,X,Y),
%	replace(M,X,Y,E1,L),write(L),write("\n"),
%	nsoliH(L,Q,L1).
%%%%%%%%%%%%%%%%%%%%%%



	
		
%Permet d'aller a la prochaine liste parmit celles initilisés avec le fichier en entrés
utilise([H|T], X, Y, LL, L):-
	length(H, Len),
	Y >= Len,
	XX is X+1,
	utilise([H|T], XX, 0, LL, L).
	
%Regarder si le cell et regarde si il est a "0"
utilise(S, X, Y, LL, L):-
	length(S, Len),
	X < Len -> (
		YY is Y+1,
		index(S, X, Y, V),
		V == "0",
		utilise(S, X, YY, [[X, Y]|LL], L)); L = [[X, Y]|LL], !.
	
%Permet d'aller au prochain cell
utilise(S, X, Y, LL, L):-
	length(S, Len),
	X < Len,
	YY is Y+1,
	utilise(S, X, YY, LL, L).

%Passer le premier element d'une liste
skipFirst([_|T], T).

%Calculer le cout marginal d'un chemin en trouver le maximum a enlever
coutMarginal(D, S, [[I1,J1], [I2,J2], [I3,J3], [I4, J4]], R):-
	%maximum a enlever en regarder seulement les position 2 et 4 pour l'instant
	index(S, I2, J2, Nm2), 
	index(S, I4, J4, Nm4),
	atom_number(Nm2, Xm2),
	atom_number(Nm4, Xm4),
	min_list([Xm2, Xm4], Min),
	
	%cout du chemin
	index(D, I1, J1, V1), 
	index(D, I2, J2, V2), 
	index(D, I3, J3, V3), 
	index(D, I4, J4, V4),
	atom_number(V1, X1),
	atom_number(V2, X2),
	atom_number(V3, X3),
	atom_number(V4, X4),
	R is (X1 - X2 + X3 - X4) * Min.

%trouver le cout minimal pour tous les chemins, donc trouver le minimalpathcost
minimalPathCost(_, _, [], _, 0).
minimalPathCost(D, S, [[R|_]|T], Route, NewMin):-
	minimalPathCost(D, S, T, Route, Min),
	coutMarginal(D, S, R, Cost),
	Cost < Min,
	NewMin = Cost,
	Route = R.

	
%Utiliser pour convertir les degenerates en nombres
conversion(V, V1):-
	not(number(V)) -> (
		V == "0" -> (V1 is 0); (atom_number(V, V1))
	); V1 is V.

%trouver le cout sur une ligne
lineCost([_|[]], _, C, C).
lineCost([H|T], [H1|T1], C, Cost):-
	conversion(H, N), conversion(H1, N1), %atom_number() ne fonctionne pas directement
	C1 is C + (N * N1),
	lineCost(T, T1, C1, Cost).
	
%trouver le cout total	
totalCost([_|[]], _, C, C).
totalCost([H1|T1], [H2|T2], C1, Cost):-
	lineCost(H1, H2, 0, C),
	C2 is C1 + C,
	totalCost(T1, T2, C2, Cost), !.
	
%Trouver les index des elements a changer et les remplacé par les nouveaux
findReplace(S1, [[I1,J1], [I2,J2], [I3,J3], [I4, J4]], L):-
	%trouver les index de chaque parcours
	index(S1, I1, J1, V1), 
	index(S1, I2, J2, V2), 
	index(S1, I3, J3, V3), 
	index(S1, I4, J4, V4),
	
	%Conversion de string a nombre
	atom_number(V1, X1), 
	atom_number(V2, X2),
	atom_number(V3, X3), 
	atom_number(V4, X4),
	
	%transferer le minimum
	min_list([X2, X4], Min),
	XX1 is X1 + Min, 
	XX2 is X2 - Min,
	XX3 is X3 + Min, 
	XX4 is X4 - Min,
	
	%trouver la bonne position de chaque element dans la liste existante
	find(S1, I1, J1, XX1, S2), 
	find(S2, I2, J2, XX2, S3),
	find(S3, I3, J3, XX3, S4), 
	find(S4, I4, J4, XX4, L).
	
% Remplace les element à l'index(Y) donné -  fait a partir de l'Exemple en bas de ce fichier
remplace([], _, _, []).
remplace([_|T], Y, Elem, [Elem|T]):-
	Y == 0.
remplace([H|T], Y, Elem, [H|R]):-
	Y > 0,
	YY is Y - 1,
	remplace(T, YY, Elem, R).
	
%trouver la bonne position(X,Y) de l'index 
find([], _, _, _, []).
find([H|T], X, Y, Elem, [L|T]):-
	X == 0,
	remplace(H, Y, Elem, L).
find([H|T], X, Y, Elem, [H|R]):-
	X > 0,
	XX is X - 1,
	find(T, XX, Y, Elem, R).
	
%Permet d'écrire un fichier contenant la solution
write_file([], _, _, _).

write_file([H|T], N, M, S):-
	%write(N),
	flatten(H, F),
	write(S,N),
	write(S, " "),		
	atomic_list_concat(F, ' ', String),
	write(S, String),
	write(S, "\n"),
	N1 is N + 1,
	write_file(T, N1, M, S).

write_file(Size,Data):-
	open("solution.txt", write, S),
	write(S, Size), write(S, "\n"),
	length(Data, M),
	%write(M),
	write_file(Data, 0, M, S),
	close(S).
	
	
%skip permet de passer le premier string d'une liste, ici c'est pour passer les index donner par le fichier
skip([], []).

skip([[_|T]|Q], [T|L]):-
	skip(Q, L).
	
%skipLine permet de passer une ligne dans un fichier, ici on passe à la prochaine liste dans la liste.
skipLine([H|T], H, T).
	
%getInfo permet d'obtenir les differents string d'un fichier,
%avec le fichier en arg1 et retourne un arg2,une liste de notre description ou solution initiale.
getInfo([], []).

getInfo([H|T], [Q|L]):-
	split_string(H, "\s", "\s", Q),
	getInfo(T, L).

%Read_file permet de lire un fichier
read_file(Stream,[]) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_chars(X, Codes),
    read_file(Stream,L), !.
	
minimumTransportCost(D, I, Cost):-
	open(D, read, Str1),
    read_file(Str1, Text1),				%write("\n"),write(Text1),
    close(Str1),
	skipLine(Text1, _, Desc1),			%write("\n"),write(DH1),write("\n"),write(Desc1),
	skipLine(Desc1, _, Desc2),			%write("\n"),write(DH2),write("\n"),write(Desc2),
	getInfo(Desc2, Desc3),				%write("\n"),write(Desc3),
	skip(Desc3, Description),			%write("\n"),write(Description),
	
	
	open(I, read, Str2),
    read_file(Str2, Text2),				%write("\n"),write(Text2),
    close(Str2),
    skipLine(Text2, IH1, Init1),		%write("\n"),write(IH1),write("\n"),write(Init1),
	skipLine(Init1, IH2, Init2),		%write("\n"),write(IH2),write("\n"),write(Init2),
	getInfo(Init2, Init3),				%write("\n"),write(Init3),
	skip(Init3, Initial),				%write("\n"),write(Initial),
	
	
	utilise(Initial, 0, 0, [], Elem), 	%Regarde les chemins possible
	skipFirst(Elem, E), !,
	circuit(Description, Initial, E, R),%trouver la liste des chemins possible selon la desciption
	delete(R, [], Routes),
	minimalPathCost(Description, Initial, Routes, Route, _), !,
	findReplace(Initial, Route, Solution),
	
	
	write_file(IH1,[IH2|Solution]),
	totalCost(Description, Solution, 0, Cost), !.
	
	
%%%%%%%%%%
%%%TEST%%%
%%%%%%%%%%
cost(X):- 
	X =[[6,8,10],[7,11,11],[4,5,12]].
soli(X):- 
	X=[[0,10,20],[0,0,40],[40,10,0]].
% replace(M,X,Y,VALUE,L).
replace( [L|Ls] , 0 , Y , Z , [R|Ls] ) :-
  replace_column(L,Y,Z,R)                 
  .                                      
replace( [L|Ls] , X , Y , Z , [L|Rs] ) :- 
  X > 0 ,                                 
  X1 is X-1 ,                             
  replace( Ls , X1 , Y , Z , Rs )         
  .                                       

replace_column( [_|Cs] , 0 , Z , [Z|Cs] ) . 
replace_column( [C|Cs] , Y , Z , [C|Rs] ) :- 
  Y > 0 ,                                    
  Y1 is Y-1 ,                             
  replace_column( Cs , Y1 , Z , Rs ).