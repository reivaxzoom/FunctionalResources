%% @author Xavier
%% @doc @todo Add description to reg.


-module(reg).

-compile(export_all).

run(A, B)->
    process_flag(trap_exit, true),
    Pid1 = spawn_link(?MODULE, proc3, [A, B]), % reg
    spawn_link(?MODULE, proc2, [Pid1]),
    receive
	{'EXIT', Pid1, R} when R /= normal ->
	    spawn_link(?MODULE, proc3, [A, B+1])
    end.

proc2(Pid)->
    Pid ! ok.

proc3(A, B)->
    A / B,
    receive
	_ ->
	    io:format("Message received\n")
    end.
    

