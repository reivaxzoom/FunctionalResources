-module(chat_gen).

%% Implement the former assignment using the gen_server behaviour.

%% -compile(export_all).

%% server interface
-export([start/1, dump/0 ]).

%% server callbacks
-export([handle_info/2, handle_call/3, handle_cast/2, 
	 init/1, terminate/2, code_change/3, reg/1,logout/1]).

%% client interface
-export([log_in/1, send/1]).
-behaviour(gen_server).

-include("a.hrl").

start(Max) ->
    gen_server:start({local,?Name}, ?MODULE, Max, []).
start() ->
	spawn_monitor(?MODULE,fun() -> restarter()end, []).

shutdown()->
    gen_server:call({?Name,?Node}, shutdown).

reg(User) ->
	gen_server:call({?Name,?Node}, {reg,User}).


log_in(Nick) ->
	gen_server:call({?Name,?Node}, {log_in,self(),Nick}).

logout(Pid)->
	gen_server:call({?Name,?Node}, {log_out, Pid}).

send(Msg) ->
    gen_server:cast({?Name,?Node}, {msg, self(), Msg}).

save() ->
	gen_server:cast({?Name,?Node}, save).

recover() ->
    gen_server:cast({?Name, ?Node} , recover).

dump() ->
    gen_server:cast({?Name,?Node}, dump).

crash() ->
	gen_server:cast({?Name,?Node}, crash).

init(Arg) ->
    process_flag(trap_exit, true),
    InitState = init_state(Arg),
    {ok, InitState}.

init() ->
    process_flag(trap_exit, true),
    InitState = init_state(10),
    ?MODULE:loop(InitState).

handle_call({reg,User}, _From, State) ->
		io:format("Registering ~p \n",[User]),
	    NewState = handle_reg(State, User),
		{reply, ok, NewState };

handle_call({log_in, Pid, Nick}, _From,State= #state{users = U,regUser=R, hist=H} ) ->
     if length(State#state.users) == State#state.max -> 
		{reply, deny, State};
		   true -> 
			   case lists:keyfind(Nick, 1, R)  of 
				    false -> {reply, deny, State};
					{Name, _St } ->
						io:format("User ~p is registered\n",[Name]),
						case lists:keyfind(Nick, 1, H) of
							false -> {reply, ok, State};
							{Name , Hist }-> 
								Reg=lists:keydelete(Nick, 1, R),
								His=lists:keydelete(Nick, 1, H),
								NewState=State#state{users = [{Pid, Nick} | U], regUser=[{Nick,on}|Reg],hist=His},
								{reply,lists:flatten(Hist), NewState}
							end
						end
					end;


handle_call({log_out, Pid}, _From, State= #state{users = U, regUser=R, hist=H}) ->
	   {_, Nick}=lists:keyfind(Pid, 1, U),
						L = lists:keydelete(Pid,1, U),
						Reg=lists:keydelete(Nick, 1, R),
						NewState=State#state{users = L ,regUser=[{Nick,off}|Reg],hist=[{Nick,[]}|H] },
						{reply, ok, NewState};

handle_call(shutdown, _From, State) ->
	unregister(?Name),
    io:format("Shutting down Server State: ~p \n", [State]),
    {shutdown, normal, State, State}.

handle_cast({msg, Pid, Msg}, State = #state{users = U,  hist=H})->
   case lists:keyfind(Pid, 1, U) of
		{Pid, Nick} ->
		    NewMsg = atom_to_list(Nick) ++ ":  " ++ Msg,
		    lists:foreach(fun({P, _}) -> P ! {msg, NewMsg} end, U),
			
			Hist=lists:map(fun(X) -> {element(1, X),lists:append(element(2, X) ,[NewMsg])} end, H),
			NewState=State#state{hist=Hist},
	   {noreply, NewState};
		false -> 
		{noreply, State}
%% 		Pid ! deny, State
	    end;

handle_cast(dump, State) ->
    io:format("State: ~p \n", [State]),
    {noreply, State};

handle_cast(save, State) ->
    io:format("Saving: ~p \n", [State]),
		dets:open_file(chatRegUser,[]),
		lists:foreach(fun(X) -> dets:insert(chatRegUser, X)end , State#state.regUser),
		dets:close(chatRegUser),
	
		dets:open_file(chatOnlineUser,[]),
		lists:foreach(fun(X) -> dets:insert(chatOnlineUser, X)end , State#state.users),
		dets:close(chatOnlineUser),

		dets:open_file(chatHistorial,[]),
		lists:foreach(fun(X) -> dets:insert(chatHistorial, X)end , State#state.hist),
		dets:close(chatHistorial),
    {noreply, State};

handle_cast(crash, State) ->
  error(simulated_error).

handle_info({'EXIT', Pid, _Reason}, State = #state{users = U}) ->
    NewUsers = lists:keydelete(Pid,1,U),
    io:format("Somebody left the chat\n"),
    {noreply, State#state{users = NewUsers}};

handle_info({'noproc', Pid, _Reason}, State = #state{users = U}) ->
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
#state{max = Max, users = [],regUser=[], hist=[]}.
%% #state{max = Max, users = [],regUser=[{xavi,off},{dizzy,off}], 
%% 	   hist=[{xavi,["xavi probando","hay alguien ahi","no encuentro"]},{dizzy,["busco a la rana rene","se fue con la galleta"]}]}.


restarter() ->
	io:format("Restarter iniciated\n"),
    process_flag(trap_exit, true),
    Pid = spawn_link(fun() -> init() end),
    register(?Name, Pid),
    receive
        {'EXIT', Pid, normal} -> % not a crash
			io:format("Shutting System normal, Pid ~p",[Pid]),
            ok;
        {'EXIT', Pid, shutdown} -> % manual shutdown, not a crash
			io:format("Exit system shutdown, Pid ~p",[Pid]),
            ok;
        {'EXIT', Pid, Reason} ->io:format("Exit catched, restarting, reason:  ~p \n",[Reason]),
            restarter();
		_ ->
			io:format("Error catched, restarting, \n")
    end.


%%SubHandle methods
handle_reg(State= #state{regUser=R, hist=H},User) ->
	State#state{regUser = [{User,off} | R], hist=[{User,[]}|H]}.


handle_logout(State= #state{users = U, regUser=R, hist=H},Pid) ->
						{_, Nick}=lists:keyfind(Pid, 1, U),
						L = lists:keydelete(Pid,1, U),
						Reg=lists:keydelete(Nick, 1, R),
						State#state{users = L ,regUser=[{Nick,off}|Reg],hist=[{Nick,[]}|H] }.




%%Database methods
show_next_key( ChatDB, '$end_of_table' ) ->dets:close(ChatDB), [];
show_next_key( ChatDB,  Key) ->
        Next = dets:next( ChatDB, Key ),
		NextValue =dets:lookup(ChatDB, Next),
		[NextValue|show_next_key( ChatDB, Next )].
	
show_all(ChatDB) ->
	dets:open_file(ChatDB,[]),
	FirstKey=dets:first(ChatDB),
	FirstVal=dets:lookup(ChatDB, FirstKey),
	All=show_next_key(ChatDB,FirstKey),
	lists:flatten(lists:append([FirstVal], All)).

