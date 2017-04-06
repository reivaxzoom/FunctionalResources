%% @author Xavier
%% @doc @todo Add description to reg2.


-module(reg2).

-compile(export_all).

run(A, B)->
    process_flag(trap_exit, true),
    Pid1 = spawn_link(?MODULE, proc3, [A, B]),
    register(proc3, Pid1), % reg
    Pid2 = spawn_link(?MODULE, proc2, []),
    receive
	{'EXIT', Pid1, R} when R /= normal ->
	    f(),
	    register(proc3,spawn_link(?MODULE, proc3, [A, B+1]))%,
	    %Pid2 ! ok
    end.

f()->
    case whereis(proc3) of
	undefined ->
	    ok;
	_ ->
	    f()
    end.

proc2()->
    receive 
	after 5000 -> ok
    end,
    io:format("sth: ~p~n", [whereis(proc3)]),
    proc3 ! ok.

proc3(A, B)->
    A / B,
    receive
	_ ->
	    io:format("Message received\n")
    end.
    