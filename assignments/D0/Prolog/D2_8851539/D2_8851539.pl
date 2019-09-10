%%CSI 2520 Devoir 2 PROLOG%%
%%Maxime Côté-Gagné  #8851539%%

city(ottawa,ontario).
city(guelph,ontario).
city(kingston,ontario).
city(gatineau,quebec).
city(montreal,quebec).
team(ravens,ottawa).
team(ggs,ottawa).
team(gryphons,guelph).
team(queens,kingston).
team(torrents,gatineau).
team(stingers,montreal).
sport(annie,lacrosse).
sport(paul,crosscountry).
sport(suzy,ski).
sport(robert,basketball).
sport(tom,lacrosse).
sport(tim,ski).
sport(annie,ski).
sport(joe,basketball).
sport(robert,basketball).
sport(jane,basketball).
sport(marie,crosscountry).
sport(suzy,crosscountry).
sport(jack,ski).
sport(simon,lacrosse).
player(annie,gryphons).
player(tom,torrents).
player(jane,stingers).
player(marie,ggs).
player(joe,ravens).
player(jack,queens).
player(simon,ravens).
player(suzy,torrents).
player(paul,ggs).
player(marie,ggs).
player(simon,gryphons).

%1.a)
a(A):-
	setof(X,sport(X,basketball),A).
	
	
%1.b)
b(B):-
	setof(X,Y^(team(X,Y),city(Y,ontario)),B).

	
%1.c)
c(C):-
	setof(X,Y^Z^(sport(X,Y),sport(X,Z),Y\=Z),C).
	
%1.d)
d(D):-
	findall((X,Y),(sport(X,Y),player(X,Z),team(Z,ottawa)),D).


%1.e)
e(E):-
	setof((X,Y),T^(sport(X,Y),player(X,T),team(T,ottawa)),E).

myAnswer():-
	a(A),
	b(B),
	c(C),
	d(D),
	e(E),
	write(A),
	write("\n"),
	write(B),
	write("\n"),
	write(C),
	write("\n"),
	write(D),
	write("\n"),
	write(E).
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%2.%Réponse dans D2Q2_8851539.jpeg
interest(X):-
	sport(X, ski).
interest(X):-
	sport(X,S),
	S \= ski,
	player(X, T),
	team(T, C),
	city(C, quebec). 
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%3.
area([[Ax,Ay],[Bx,By],[Cx,Cy]], A):-
	A is 0.5*((Ax-Cx)*(By-Ay) - (Ax-Bx)*(Cy - Ay)).

	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%4. a)
donotskip([], _, []).
donotskip([H|T], L, [H|Q]):-
	member(H, L), 
	doaskip(T, L, Q).
donotskip([H|T], L, [H|Q]):-
	donotskip(T, L, Q).
	
doaskip([], _, []).
doaskip([H|T], L, Q):-
	member(H, L), 
	donotskip(T, L, Q).
doaskip([_|T], L, Q):-
	doaskip(T, L, Q).
	
skip(Ll, Lo, Q):-
	doaskip(Ll, Lo, Q), !.

%4.  b)
rev2([], _, []).
rev2([H|T], L, [H|Q]):-
	member(H, L), 
	rev1(T, L, Q).
rev2([H|T], L, [H|Q]):-
	rev2(T, L, Q).
	
rev1([], _, []).
rev1([H|T], L, [Q|H]):-
	member(H, L),
	rev2(T, L, Q).
rev1([H|T], L, [Q|H]):-
	rev1(T, L, Q).
	
flatten4([[[H|Ttt]|Tt]|T], Q):-
	flatten([Ttt, Tt, T, H], Q).
turn(Ll, Lo, L):-
	rev1(Ll, Lo, Q),
	flatten4(Q,L),!.

	
	
	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
%5. a)
treeEx(X):-
	X = t(73,t(31,t(5,nil,nil),nil),t(101,t(83,nil,t(97,nil,nil)),nil)). 

single(t(_,nil,nil), []).
single(t(E, nil, R), [E|ER]) :- 
	single(R, ER),!.
single(t(E, L, nil), [E|EL]) :- 
	single(L, EL),!.
single(t(_, L, R), X) :- 
	single(L, EL), 
	single(R, ER), 
	append(EL, ER, X).

	
	
%5. b) singlefill
single(nil, New, t(New, nil, nil)).
single(t(E, nil, nil), _, t(E, nil, nil)) :- !.
single(t(E, Left, Right), New, t(E, NewLeft, NewRight)) :-
    single(Left, New, NewLeft),
    single(Right, New, NewRight).



















