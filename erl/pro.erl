%% @author Xavier
%% @doc @todo Add description to pro.


-module(pro).

%% ====================================================================
%% Util functions
%% API functions
%% ====================================================================
-compile(export_all).

factorial(0) ->1;
factorial(N) when is_integer(N)->
	N * factorial(N-1).

divisors(N) ->
	[X || X<-lists:seq(1, N), N rem X==0].

primeList(N) ->
	[X|| X <-lists:seq(1, N), length(pro:divisors(X))==2 ].

primeList2(N) ->
  	lists:filter(fun is_prime/1,lists:seq(1, N)).


showSeq(N)->
	lists:foreach(fun(X) -> io:format("~p",[X]) end, N).

fib(1)  ->1;
fib(2)  ->1;
fib(N) when N>2->
	fib(N-2)+fib(N-1).

sum(0)->0;
sum(N) ->
	N+sum(N-1).

sumInt(N) ->
	lists:foldl(fun(X,Sum) ->X+Sum end , hd(N), tl(N)).

sumInt2([])  -> 0;
%% sumInt2(N) when not is_list(N) -> "error ingrese bien paramentro";
sumInt2(N)->
	try	 
		hd(N)+sumInt2(tl(N))
	catch
		error:badarg -> " no argumento";
		error:undefined -> "funcion no definida";
		error:function_clause -> " bad argument";
		error:badarith-> "Bad Arity";
		error:{connectionbad,V} ->"mala conexion";
		error:{badmatch,V}-> io:format("Esta mal sale ~p",[V])
	end.

quicksort([]) -> [];
quicksort(L) ->
	M=lists:min(L),
	[M|quicksort(lists:delete(M, L))].


sumGuards(N) ->
	case N of 
		[] -> 1;
		[H] when is_number(H) -> H;
		[H|T] when is_number(H)-> H+sumGuards(T)
	end.
sumIf(N) ->
	if 
		is_number(hd(N))-> hd(N)+ sumIf(tl(N));
		true -> 0
	end.

condition(X,L) ->
	A=length(X),
	if
		A>L -> "muchos elementos no muestro";
		A<L -> X;
		A==5 -> "justo el limite"
	end.

is_prime(N) ->
	case N of
		0-> false;
		1->false;
		2->true;
		N -> divisors(N)==[1,N]
end.

-record(date, {month, day, year}).
create() ->
	#date{month="January",day=2, year=1924},
	#date{month="December",day=10, year=1920}.

%% select(Year, [Rec = #date{year = Year} | Tail]) ->{month, Rec#date.month};
%% select(_Year, [_ | Tail] )-> select(Tail);
%% select(_Year, []) -> not_found.


next(Seq)-> fun()-> [Seq | next(Seq + 1)] end.
%% lists:foldl(fun(X,Sum)-> X+Sum, hd(L), tl(L))
%% ====================================================================
%% Internal functions
%% ====================================================================


