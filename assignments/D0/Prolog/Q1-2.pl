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


%Question 1
%a) La liste de tous les joueurs de basketball
%sport(L,basketball).
%findall(X,sport(X,basketball),L).
%distinct(sport(X,basketball)).

%b)

%c)


%d)
%?- findall((X,Y),(sport(X,Y),player(X,Z),team(Z,ottawa)),L).
% L = [(paul, crosscountry), (joe, basketball), (marie, crosscountry),
% (marie, crosscountry), (simon, lacrosse)].


%e)