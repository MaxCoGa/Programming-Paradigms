tree(X) :- X =
	t(4, 
	  t(3, 
	    nil,
	    t(1, 
	      t(0, nil, nil), 
	      t(2, nil, nil))),
	  t(7,
	    t(5, nil, nil), 
	    t(8, nil, 
	      t(9, nil, nil)))).

traverse(nil).
traverse(t(X,L,R)) :-
    traverse(L),
    traverse(R),
    write(X),
    write(' ').

traverseSum(nil,0).
traverseSum(t(X,L,R),S) :-
    traverseSum(L,SL),
    traverseSum(R,SR),
    S is SL + SR + X.