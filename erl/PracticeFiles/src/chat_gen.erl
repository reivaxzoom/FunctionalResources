-module(chat_gen).

%% server interface
-export([start/1, stop/0, dump/0]).

%% server callbacks
-export([handle_info/2, handle_call/3, handle_cast/2, 
	 init/1, terminate/2, code_change/3]).

%% client interface
-export([log_in/1, send/1]).
-behaviour(gen_server).

-include("a.hrl").

start(Max) ->
    gen_server:start(?Name, ?MODULE, Max, []).

stop()->
    gen_server:call(?Name, please_stop).

log_in(Nick)->
    gen_server:call(?Name, {log_in, self(), Nick}).

send(Msg) ->
    gen_server:cast(?Name, {msg, self(), Msg}).

dump() ->
    gen_server:cast(?Name, dump).


init(Arg) ->
    process_flag(trap_exit, true),
    InitState = init_state(Arg),
    {ok, InitState}.

handle_call({log_in, Pid, Nick}, _From, State = #state{users = U}) -> 
    if length(U) == State#state.max -> 
	    {reply, deny, State};
       true -> 
	    link(Pid),
	    {reply, ok, State#state{users = [{Pid, Nick} | U]}}
    end;%;
handle_call(please_stop, _From, State) ->
    {stop, normal, State, State}.

%handle_call(_, _, _) -> 
%    {reply, Reply, NewState}.

handle_cast({msg, Pid, Msg}, State = #state{users = U})->
    case lists:keyfind(Pid, 1, U) of
	{Pid, Nick} ->
	    NewMsg = atom_to_list(Nick) ++ ":  " ++ Msg,
	    lists:foreach(fun({P, _}) -> 
				  P ! {msg, NewMsg},
				  P ! {msg, NewMsg},
				  P ! {msg, NewMsg}
			  end, U);
	false -> io:format("Not logged in! ~p~n ", [Pid])
    end,
    {noreply, State};
handle_cast(dump, State) ->
    io:format("State: ~p \n", [State]),
    {noreply, State}.

handle_info({'EXIT', Pid, _Reason}, State = #state{users = U}) ->
    NewUsers = lists:keydelete(Pid,1,U),
    io:format("Somebody left the chat\n"),
    {noreply, State#state{users = NewUsers}};
handle_info(_Msg, State) ->
    {noreply, State}.

code_change(_, State, _) ->
    {ok, State}.

terminate(normal, State)->
    io:format("That was the state when I've terminated : ~p \n", [State]).

init_state(Max) ->
    #state{max = Max, users = []}.
