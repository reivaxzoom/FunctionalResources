-module(chat).

%% server interface
-export([start/1, stop/0]).

%% client interface
-export([log_in/1, send/1]).

-include("a.hrl").

start(Max) ->
    register(?Name, spawn(fun() -> init(Max) end)).

stop()->
    ?Name ! {stop, self()},
    receive
	A -> A
    end.

log_in(Nick)->
    {?Name, ?Node} ! {log_in, self(), Nick},
    receive 
	A -> A
    after
	5000 -> timeout
    end.

send(Msg) ->
    {?Name, ?Node} ! {msg, self(), Msg}.

init(Arg) ->
    process_flag(trap_exit, true),
    InitState = init_state(Arg),
    loop(InitState).

loop(State = #state{users = U}) -> %% State = {state, _, U}
    receive
	{log_in, Pid, Nick} ->
	    %NewState = handle_msg(State),
	    NewState = 
		if length(U) == State#state.max -> 
			Pid ! deny,
			State;
		   true -> 
			Pid ! ok,
			State#state{users = [{Pid, Nick} | U]}
		end,
	    loop(NewState);
	{msg, Pid, Msg}->
	    {Pid, Nick} = lists:keyfind(Pid, 1, U),
	    NewMsg = atom_to_list(Nick) ++ ":  " ++ Msg,
	    lists:foreach(fun({P, _}) -> P ! {msg, NewMsg} end, U),
	    loop(State);
	{stop, Pid} ->
	    Pid ! State,
	    terminate(State)
    end.

handle_msg(_) ->
    ok.

terminate(State)->
    io:format("State: ~p \n", [State]).

init_state(Max) ->
    #state{max = Max, users = []}.
