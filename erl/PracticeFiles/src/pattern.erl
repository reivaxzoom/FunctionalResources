-module(pattern).
-compile(export_all).

%% -export([my_lenght/1]).
 
my_lenght([H|T]) when is_tuple->
	1+ my_lenght(T);
my_lenght([]) -> 0.
  



  
f(_A,_A) ->
equal;

f(_,_) ->
not_equal.


