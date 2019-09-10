train(ottawa,toronto).
train(ottawa,montreal).
train(ottawa,sudbury).
train(toronto,kingston).
train(toronto,ottawa).
train(toronto,windsor).
train(montreal,quebec).
train(montreal,kingston).
train(montreal,ste-adele).
train(kingston,cornwall).

path([C]).
path([C1,C2|L]):-train(C1,C2),path([C2|L]).

stop(X,Y,Z):-train(X,Y),train(Y,Z),X\=Z.
    
% Queries
% path([ottawa,V,kingston,cornwall]).
% setof(X,stop(toronto,ottawa,X),L).
% findall(X,stop(toronto,E,X),L).
% setof(X,stop(Y,kingston,X),L).