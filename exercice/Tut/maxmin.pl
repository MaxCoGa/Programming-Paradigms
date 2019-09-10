maxmin( [H|T], Max, Min ) :- maxmin( T, H, H, Max, Min ), !.


maxmin( [], Max, Min, Max, Min ) :- !.

maxmin( [H|T], X, Y, Max, Min ) :- H @> X,
				   maxmin( T, H, Y, Max, Min ).

maxmin( [H|T], X, Y, Max, Min ) :- H @< Y,
				   maxmin( T, X, H, Max, Min ).

maxmin( [H|T], X, Y, Max, Min ) :- H @=< X, H @>= Y,
				   maxmin( T, X, Y, Max, Min ).
/Users/danywilson/Desktop/CSI_2520/CSI_2520/Lab_4_true/lab04/secondLast.pl