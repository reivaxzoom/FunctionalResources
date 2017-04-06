-module(seventh).

-compile(export_all).

read()->
    try  	
	{ok, A} = io:read("Provide a module name --> "),
%% 	true = is_atom(A),
	Exports = A:module_info(exports),
	{ok, B} =  io:read("Provide a function name --> "),
	{B, Arity} = lists:keyfind(B, 1, Exports), 

	Params = read_par(Arity),
	{A, B, Params}
    of
	{M, F, P} ->
	    apply(M, F, P)
    catch
	error:badarg -> "Not an atom";
	error:{badmatch, false} -> "Function does not exist";
	error:{badmatch, {error, _}} ->  "Do not proper parameter";
	error:undef  -> "Module does not exist"
    end.

test ->(arg1)
test ->(arg1,arg2)
test ->(arg1,arg2,arg3)
test ->(arg1,arg2,arg3,arg4)


read_par(0) ->
    [];
read_par(A)->
    {ok, P} = io:read("Provide a parameter --> "), %% element (2, ...)
    [ P | read_par(A-1)].


search(K, [{ K, V} | T])->
    [{K, V} | search(K, T)];
search(K, [_ | T]) ->
    search(K, T);
search(_, []) ->
    [].

check({{K, V}, Key}) ->
    K == Key.

search4(K, L) ->
    lists:map( fun({A, _B}) -> A end, 
	            lists:filter(fun check/1, lists:zip(L, [K || _ <- L]))).

search3(K, L) ->
    lists:filter(fun({Key, _Val})  -> Key ==  K end, L).

search2(K, L) ->
    Fun = 
	fun
	    ({Key, _Val})  when Key ==  K -> true;
	    (_) -> false
	end,
    filter(Fun, L).
   
filter(_, [])->
    [];
filter(F, [H | T])-> 
    case F(H) of
	true ->
	    [H | filter(F, T)];
	false ->
	    filter(F, T)
    end.

%% melinda@mwork:~$ erl
%% Erlang/OTP 17 [erts-6.2] [source-aaaefb3] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

%% Eshell V6.2  (abort with ^G)
%% 1> do:module_info().
%% ** exception error: undefined function do:module_info/0
%% 2> c(seventh).
%% seventh.erl:12: syntax error before: 'of'
%% seventh.erl:19: Warning: variable 'A' is unused
%% error
%% 3> c(seventh).
%% seventh.erl:17: syntax error before: 'end'
%% seventh.erl:19: Warning: variable 'A' is unused
%% error
%% 4> c(seventh).
%% seventh.erl:14: variable 'A' unsafe in 'try' (line 6)
%% seventh.erl:14: variable 'B' unsafe in 'try' (line 6)
%% seventh.erl:14: variable 'Params' unsafe in 'try' (line 6)
%% seventh.erl:19: Warning: variable 'A' is unused
%% error
%% 5> c(seventh).
%% seventh.erl:14: variable 'A' unsafe in 'try' (line 6)
%% seventh.erl:14: variable 'B' unsafe in 'try' (line 6)
%% seventh.erl:14: variable 'Params' unsafe in 'try' (line 6)
%% seventh.erl:20: Warning: variable 'A' is unused
%% error
%% 6> c(seventh).
%% seventh.erl:20: Warning: variable 'A' is unused
%% {ok,seventh}
%% 7> c(seventh).
%% {ok,seventh}
%% 8> seventh:read().
%% Provide a module name --> lists.
%% Provide a function name --> nth.
%% Provide a parameter --> 2.
%% Provide a parameter --> [2,3,4,5].
%% 3
%% 9> seventh:read().
%% Provide a module name --> erlang.
%% Provide a function name --> length.
%% Provide a parameter --> ok.
%% ** exception error: bad argument
%%      in function  length/1
%%         called as length(ok)
%% 10> length(ok).
%% ** exception error: bad argument
%%      in function  length/1
%%         called as length(ok)
%% 11> catch do:module_info().
%% {'EXIT',{undef,[{do,module_info,[],[]},
%%                 {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,661}]},
%%                 {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,434}]},
%%                 {shell,exprs,7,[{file,"shell.erl"},{line,684}]},
%%                 {shell,eval_exprs,7,[{file,"shell.erl"},{line,639}]},
%%                 {shell,eval_loop,3,[{file,"shell.erl"},{line,624}]}]}}
%% 12> catch 1:module_info(). 
%% {'EXIT',{badarg,[{erlang,apply,[1,module_info,[]],[]},
%%                  {shell,apply_fun,3,[{file,"shell.erl"},{line,895}]},
%%                  {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,661}]},
%%                  {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,434}]},
%%                  {shell,exprs,7,[{file,"shell.erl"},{line,684}]},
%%                  {shell,eval_exprs,7,[{file,"shell.erl"},{line,639}]},
%%                  {shell,eval_loop,3,[{file,"shell.erl"},{line,624}]}]}}
%% 13> seventh:read().        
%% Provide a module name --> '+.
%% Provide a module name --> '.
%% ok
%% 14> c(seventh).            
%% {ok,seventh}
%% 15> seventh:read().        
%% Provide a module name --> 1+.
%% "Do not proper parameter"
%% 16> seventh:read().
%% Provide a module name --> '+'.
%% ** exception error: undefined function '+':module_info/1
%%      in function  seventh:read/0 (seventh.erl, line 8)
%% 17> seventh:read().
%% Provide a module name --> 1+.
%% "Do not proper parameter"
%% 18> c(seventh).    
%% {ok,seventh}
%% 19> seventh:read().
%% Provide a module name --> '+'.
%% "Module does not exist"
%% 20> seventh:read().
%% Provide a module name --> lists.
%% Provide a function name --> maxxxx.
%% "Do not proper parameter"
%% 21> c(seventh).    
%% {ok,seventh}
%% 22> seventh:read().
%% Provide a module name --> lists.
%% Provide a function name --> maxxx.
%% "Function does not exist"
%% 23> seventh:read().
%% Provide a module name --> 1.   
%% ** exception error: bad argument
%%      in function  apply/3
%%         called as apply(1,module_info,[])
%%      in call from seventh:read/0 (seventh.erl, line 8)
%% 24> seventh:read().
%% Provide a module name --> lists.
%% Provide a function name --> 1.
%% "Function does not exist"
%% 25> c(seventh).    
%% seventh.erl:19: syntax error before: error
%% error
%% 26> c(seventh).
%% {ok,seventh}
%% 27> seventh:read().
%% Provide a module name --> 1.
%% "Not an atom"
%% 28> c(seventh).    
%% seventh.erl:32: Warning: variable 'T' is unused
%% {ok,seventh}
%% 29> seventh:search(2, [{2,3}].
%% * 1: syntax error before: '.'
%% 29> seventh:search(2, [{2,3}]).
%% {2,3}
%% 30> seventh:search(2, [{2,3}, {2,4}]).
%% {2,3}
%% 31> seventh:search(2, [{2,2, 3}, {2,4}]).
%% ** exception error: no function clause matching 
%%                     seventh:search(2,[{2,2,3},{2,4}]) (seventh.erl, line 32)
%% 32> c(seventh).                          
%% seventh.erl:32: Warning: variable 'T' is unused
%% {ok,seventh}
%% 33> seventh:search(2, [{2,2, 3}, {2,4}]).
%% {2,4}
%% 34> c(seventh).                          
%% {ok,seventh}
%% 35> seventh:search(2, [{2, 3}, {2,4}]).  
%% [{2,3},{2,4}|false]
%% 36> c(seventh).                        
%% {ok,seventh}
%% 37> seventh:search(2, [{2, 3}, {2,4}]).
%% [{2,3},{2,4}]
%% 38> c(seventh).                        
%% seventh.erl:39: function search/2 already defined
%% seventh.erl:42: Warning: variable 'Val' is unused
%% error
%% 39> c(seventh).
%% seventh.erl:42: Warning: variable 'Val' is unused
%% {ok,seventh}
%% 40> c(seventh).
%% {ok,seventh}
%% 41> seventh:search2(2, [{2, 3}, {2,4}]).
%% ** exception error: no function clause matching 
%%                     seventh:filter(#Fun<seventh.0.104526190>,[]) (seventh.erl, line 47)
%%      in function  seventh:filter/2 (seventh.erl, line 50)
%%      in call from seventh:filter/2 (seventh.erl, line 50)
%% 42> c(seventh).                         
%% {ok,seventh}
%% 43> seventh:search2(2, [{2, 3}, {2,4}]).
%% ** exception error: no function clause matching 
%%                     seventh:filter(#Fun<seventh.0.104526190>,[]) (seventh.erl, line 47)
%%      in function  seventh:filter/2 (seventh.erl, line 50)
%%      in call from seventh:filter/2 (seventh.erl, line 50)
%% 44> c(seventh).                         
%% {ok,seventh}
%% 45> seventh:search2(2, [{2, 3}, {2,4}]).
%% [{2,3},{2,4}]
%% 46> c(seventh).                         
%% *** ERROR: Shell process terminated! ***
%% Eshell V6.2  (abort with ^G)
%% 1> c(seventh).
%% {ok,seventh}
%% 2> seventh:search3(2, [{2, 3}, {2,4}]).
%% [{2,3},{2,4}]
%% 3> c(seventh).                         
%% seventh.erl:40: Warning: variable 'A' is unused
%% {ok,seventh}
%% 4> seventh:search3(2, [{2, 3}, {2,4}]).
%% ** exception error: no function clause matching 
%%                     seventh:'-search3/2-fun-0-'({2,3}) (seventh.erl, line 40)
%%      in function  lists:'-filter/2-lc$^0/1-0-'/2 (lists.erl, line 1284)
%% 5> seventh:module_info().
%% [{exports,[{search3,2},
%%            {search2,2},
%%            {filter,2},
%%            {search,2},
%%            {read,0},
%%            {read_par,1},
%%            {module_info,0},
%%            {module_info,1}]},
%%  {imports,[]},
%%  {attributes,[{vsn,[152797669228585599763041094020090223060]}]},
%%  {compile,[{options,[]},
%%            {version,"5.0.2"},
%%            {time,{2015,10,22,9,27,13}},
%%            {source,"/home/melinda/seventh.erl"}]}]
%% 6> 
%% 6> lists:zip([1,2], [2,3]).
%% [{1,2},{2,3}]
%% 7> c(seventh).                         
%% seventh.erl:39: Warning: variable 'V' is unused
%% {ok,seventh}
%% 8> seventh:search4(2, [{2, 3}, {2,4}]).
%% ** exception error: undefined function seventh:search4/2
%% 9> c(seventh).                         
%% seventh.erl:39: Warning: variable 'V' is unused
%% {ok,seventh}
%% 10> seventh:search4(2, [{2, 3}, {2,4}]).
%% [{{2,3},2},{{2,4},2}]
%% 11> c(seventh).                         
%% seventh.erl:39: Warning: variable 'V' is unused
%% {ok,seventh}
%% 12> seventh:search4(2, [{2, 3}, {2,4}]).
%% [{2,3},{2,4}]
%% 13> 