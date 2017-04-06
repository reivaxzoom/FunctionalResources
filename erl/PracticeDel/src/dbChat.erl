%% @author Xavier
%% @doc @todo Add description to foo.


-module(dbChat).
-compile(export_all).


start() -> 
    S = ets:new(test,[public]),
    Pid = spawn(fun() -> receive_data(S) end), 
	ets:give_away(test, Pid, gift),
	register(proc,Pid).

receive_data(S) ->
    receive
        {see,A} -> ets:insert(S,{cycle,A}) ;
        [[f,c],Fcd,Fca,_,_] -> ets:insert(S,{flag_c,Fcd,Fca});
        [[b],Bd,Ba,_,_] -> ets:insert(S,{ball,Bd,Ba})



    end,
    receive_data(S).

%% create_the_table(Pid) ->
%%     Table = ets:new(mytable, [public]),
%%     ets:insert(Table, {foo, bar}),
%%     Pid ! {the_table_is, Table},
%%     timer:sleep(infinity).
%% 
	%% use_the_table() ->
%%     receive {the_table_is, Table} -> ok end,
%%     io:format("~p~n", [ets:lookup(Table, foo)]).
