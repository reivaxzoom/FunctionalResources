%% @author Xavier
%% @doc @todo Add description to hor.


-module(horf).
%% Higher order functions in module lists
%% Solve the following assignment using only fun-expressions and higher order functions 
%% from the module list (using list comprehensions or recursive functions is not allowed now).
%% Check the following functions in the documentation (http://www.erlang.org/doc/man/lists.html) 
%% as a help: map/2, fold/l2, foldr/2, filter/2, foreach/2, all/2, any/2, zip/2, zipwith/3, partition/2, 
%% takewhile/2, dropwhile/2, unzip/2, and possible read all others as well.
%% 
%% implement the function divisors/1 that calculates the divisors of a number N
%% 1> mymod:divisors(12). [1,2,3,4,6,12]
%% 
%% implement the function divisorsL/1 that calculates the divisors of every element of a list (L)
%% 2> mymod:divisorsL([12,4,2]). [[1,2,3,4,6,12], [1,2,4], [1,2]]
%% 
%% implement the function pairs/1 that produces the pairs of a number and its divisors
%% for every element of a given list L
%% 3> mymod:pairs([12,4,2]). [{12, [1,2,3,4,6,12]}, {4, [1,2,4]}, {2, [1,2]}]
%% 
%% define the function cd/1 that calculates the common divisors of 
%% the element of a list L (reuse the function pairs/1)
%% 4> mymod:cd([12,4,2]). [1,2]
%% 
%% define the function gcd/1 that calculates the greatest common divisor of the element of a list L
%% 5> mymod:gcd([12,4,2]). 2
%% 
%% define the function primes/1 that filters the primes from a list L
%% 6> mymod:primes([12,4,2]). [2]
%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).



divisors(N) ->
	A = horf:sequence(N),
	B= lists:map(fun(X) -> N rem X==0 end, A),
	C = lists:zip(A, B), 
	element(1,lists:unzip(lists:filter(fun({X,Y}) -> Y==true end ,C ))).
%% lists:filter(fun(X) -> N rem X ==0  end, lists:seq(1, N));

%% mymod:divisorsL([12,4,2]). [[1,2,3,4,6,12], [1,2,4], [1,2]]
divisorsL(N) ->
	lists:map(fun(X)-> horf:divisors(X) end, N).
%% 	lists:map(fun divisors/1, List)
%% mymod:divisorsL([12,4,2]). [[1,2,3,4,6,12], [1,2,4], [1,2]]
	
sequence(Max) ->
    Incr = fun(F, X) when X > Max -> [];
             (F, X) -> [X |F(F, X+1)]
          end,
    Incr(Incr, 1).

pairs(N) ->
	lists:zip(N, divisorsL(N)).

is_divisor(N,M) ->
	case N>M of
		true -> N rem M ==0;
		false ->M rem N ==0
	end.

%% lists:subtract(lists:subtract(lists:nth(1, B),lists:nth(2, B)), lists:nth(3, B)).
%% lists:sort(horf:nonDup(lists:flatten(B))).
%% lists:sort(fun(A, B) -> A >= B end, hd(B), tl(B)).
%% lists:sort(fun(X, Y) -> length(X) >= length(Y) end, B).
%% lists:foldl(fun(X,Y)-> X--Y end, hd(F), tl(F)).
%% lists:sort(horf:nonDup(lists:flatten(horf:divisorsL([20,15,6,3])))).
%% lists:filter(fun(X) -> X==hd(L) end, L)
%% lists:foreach(fun(I) -> io:format("~w",[horf:lf(I,[1,2,4,5,10,20,1,3,5,15,1,2,3,6,1,3] ) ]) end, lists:sort(horf:nonDup([1,2,4,5,10,20,1,3,5,15,1,2,3,6,1,3]))).

%% lists:map(fun(I) -> [I,horf:lf(I,[1,2,4,5,10,20,1,3,5,15,1,2,3,6,1,3] )] end, lists:sort(horf:nonDup([1,2,4,5,10,20,1,3,5,15,1,2,3,6,1,3]))).
%% lists:filter(fun(X) -> element(2,X)==4 end, J).
%% element(1,lists:unzip(lists:filter(fun(X) -> element(2,X)==4 end, J))).

nonDup(L) ->
    Set = sets:from_list(L),
    sets:to_list(Set).


create_list(N) ->
    lists:foldl ( fun(X,Prev) -> lists:append(Prev,[X+1]) end, [] , lists:seq(1,N)).


lf(Y,L) ->
	length(lists:filter(fun(X) -> X==Y end, L)).

cd(M) ->
	L=lists:flatten(horf:divisorsL(M)),
  	J=lists:map(fun(I) -> [I,horf:lf(I,L)] end, lists:sort(horf:nonDup(L))),
 	K=lists:filter(fun(X) -> lists:nth(2,X)==length(M) end, J),
	N=(lists:filter(fun(X) -> lists:nth(2,X)==length(M) end, K)),
	lists:map(fun(X) -> lists:nth(1, X) end,N).

gcd(L) ->
	lists:max(cd(L)).

primes(L) ->
	M=horf:pairs(L),
	Q=lists:map(fun(X) -> [element(1,X),length(element(2,X))] end, M),
	horf:nonDup(lists:map(fun(X) -> lists:nth(1, X) end,lists:filter(fun(X)-> lists:nth(2,X)==2 end, Q))).