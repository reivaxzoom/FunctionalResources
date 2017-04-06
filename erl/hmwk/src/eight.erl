%% @author Xavier
%% @doc @todo Add description to eight.


-module(eight).

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

run()->
		process_flag(trap_exit,true),
		Pid1 =spawn_link(?MODULE,proc3,[]),
		spawn(?MODULE,proc2,[Pid1]).

proc2(Pid)->
	Pid !ok.

proc3() ->
	1/0,
receive 
A-> io:format("Mesagge receive")
end.
		


%% ====================================================================
%% Internal functions
%% ====================================================================


