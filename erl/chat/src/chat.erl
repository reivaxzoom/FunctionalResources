-module(chat).

%% Improve the chat server implemented on the lesson.

%% Add a log_out functionality. When the user typed q, the server deletes it from the users list.
%% Implement a user registration: the user has to register at first. The log_in is successful when
%%  the user is registered, and denied otherwise.
%% Offline messages: registered users receive the offline messages after logging in 
%% (the messages arrived after the log_out).
%% Implement a fix registration: the server stores the user registration data 
%% (in a file, in a dets table or in a database), so when the server is stopped and 
%% restarted the registration data is kept. There is no need to reregister.
%% Implement a supervisor process that monitors the chat server. 
%% When the server unexpectedly terminates the supervisor process restarts it.


%% -compile(export_all).

%% server interface
-export([start/1, shutdown/0, save/0, recover/0,start/0]).

%% not public interface
-export([loop/1]).

%% client interface
-export([log_in/1, send/1,logout/1,reg/1]).

-include("a.hrl").

%%Start with supervisor restarter
start() ->
    spawn(?MODULE, restarter, []).
%%Start without supervision
start(Max) ->
    register(?Name, spawn(fun() -> init(Max) end)).


	
shutdown()->
    ?Name ! {shutdown, self()},
    receive
	A -> A
    end.

reg(User) ->
{?Name,?Node} ! {reg,User,self()},
receive
	ok ->
	io:format("Registering: \n"),
		ok
after
	5000 -> notreg
end.

log_in(Nick)->
    {?Name, ?Node} ! {log_in, self(), Nick},
    receive 
	A -> A
    after
	5000 -> timeout
    end.

logout(Pid)->
    {?Name, ?Node} ! {log_out, Pid}.

send(Msg) ->
    {?Name, ?Node} ! {msg, self(), Msg}.


save() ->
    {?Name, ?Node} ! {save, self()}.


recover() ->
    {?Name, ?Node} ! {recover, self()}.


init(Arg) ->
    process_flag(trap_exit, true),
    InitState = init_state(Arg),
    ?MODULE:loop(InitState).
init() ->
    process_flag(trap_exit, true),
    InitState = init_state(10),
    ?MODULE:loop(InitState).

loop(State = #state{users = U}) -> 
    receive
	{reg,User,Pid} ->
		io:format("Registering ~p \n",[User]),
	    NewState = handle_reg(State, User),
		Pid ! ok,
		loop(NewState);
		
	{log_in, Pid,Nick} ->
	    NewState = handle_login(State, Pid,Nick),
	    ?MODULE:loop(NewState);

	{log_out, Pid} ->
	    NewState = handle_logout(State, Pid),
		io:format("log!! ~p~n ", [Pid]),
	    ?MODULE:loop(NewState);
		
	{msg, Pid, Msg}->
		NewState =handle_Msg(State, Pid, Msg),
		?MODULE:loop(NewState);
	
	crash ->  %%Raising badmatch to test monitor
		error(simulated_error);
	{'EXIT', Pid, Reason} ->
	    NewUsers = lists:keydelete(Pid,1,U),
	    io:format("Somebody left the chat\n ~p",[Reason]),
	    loop(State#state{users = NewUsers});
	dump ->
	    io:format("State: ~p \n", [State]),
	    loop(State);
	{shutdown, Pid} ->
		io:format("Shutting down ~p ",[Pid]),
		terminate(State),
		Pid ! ok;
	{save, Pid} ->
		io:format("Saving State in det table ~p ",[Pid]),
		NewState=handle_save(State),
		loop(NewState);

	{recover, Pid} ->
		io:format("Recovering State in det table ~p \n ",[Pid]),
		NewState= State#state{users = show_all(chatOnlineUser),regUser=show_all(chatRegUser), hist=show_all(chatHistorial)},
		loop(NewState)
end.


handle_login(State= #state{users = U,regUser=R, hist=H},Pid,Nick) ->
    if length(State#state.users) == State#state.max -> 
			Pid ! deny,
			State;
		   true -> 
			   case lists:keyfind(Nick, 1, R)  of 
				    false -> Pid ! deny,State;
					{Name, _St } ->
						io:format("User ~p is registered\n",[Name]),
						case lists:keyfind(Nick, 1, H) of
							false -> Pid ! ok ,State;
							{Name , Hist }-> 
								Pid ! lists:flatten(Hist),
								Reg=lists:keydelete(Nick, 1, R),
								His=lists:keydelete(Nick, 1, H),
								State#state{users = [{Pid, Nick} | U], regUser=[{Nick,on}|Reg],hist=His}
							end
						end
					end.



handle_Msg(State= #state{users = U,  hist=H}, Pid, Msg) ->
	case lists:keyfind(Pid, 1, U) of
		{Pid, Nick} ->
		    NewMsg = atom_to_list(Nick) ++ ":  " ++ Msg,
		    lists:foreach(fun({P, _}) -> P ! {msg, NewMsg} end, U),

			Hist=lists:map(fun(X) -> {element(1, X),lists:append(element(2, X) ,[NewMsg])} end, H),
			NewState=State#state{hist=Hist},
	    ?MODULE:loop(NewState);
		false -> 
		Pid ! deny, State
	    end.
	

handle_logout(State= #state{users = U, regUser=R, hist=H},Pid) ->
						{_, Nick}=lists:keyfind(Pid, 1, U),
						L = lists:keydelete(Pid,1, U),
						Reg=lists:keydelete(Nick, 1, R),
						State#state{users = L ,regUser=[{Nick,off}|Reg],hist=[{Nick,[]}|H] }.

handle_reg(State= #state{regUser=R, hist=H},User) ->
	State#state{regUser = [{User,off} | R], hist=[{User,[]}|H]}.

handle_save(State) ->
		dets:open_file(chatRegUser,[]),
		lists:foreach(fun(X) -> dets:insert(chatRegUser, X)end , State#state.regUser),
		dets:close(chatRegUser),
	
		dets:open_file(chatOnlineUser,[]),
		lists:foreach(fun(X) -> dets:insert(chatOnlineUser, X)end , State#state.users),
		dets:close(chatOnlineUser),

		dets:open_file(chatHistorial,[]),
		lists:foreach(fun(X) -> dets:insert(chatHistorial, X)end , State#state.hist),
		dets:close(chatHistorial),
		State.


terminate(State)->
	unregister(?Name),
    io:format("Shutting down Server State: ~p \n", [State]).


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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%LOGS
%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Loging out

%%Server
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name server -setcookie appl
%% e
%% Eshell V6.4  (abort with ^G)
%% (server@xavierpc.teteny.elte.hu)1> c(chat).
%% {ok,chat}
%% (server@xavierpc.teteny.elte.hu)2> chat:start(10).
%% true
%% (server@xavierpc.teteny.elte.hu)3> Registering xavier
%% (server@xavierpc.teteny.elte.hu)3> User xavier is registered
%% (server@xavierpc.teteny.elte.hu)4> chatserver ! dump.
%% State: {state,10,[{xavier,on}],[{<9976.37.0>,xavier}],[]}
%% dump
%% (server@xavierpc.teteny.elte.hu)5> log!! <9976.37.0>
%%  (server@xavierpc.teteny.elte.hu)5> chatserver ! dump.
%% State: {state,10,[{xavier,off}],[],[{xavier,[]}]}
%% dump
%% (server@xavierpc.teteny.elte.hu)6>

%%Client
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name client -setcookie apple
%% Eshell V6.4  (abort with ^G)
%% (client@xavierpc.teteny.elte.hu)1> chatc:regc(xavier).
%% Registering:
%% "Registration successful"
%% (client@xavierpc.teteny.elte.hu)2> chatc:start(xavier).
%% Offline Messages
%% -->  Hola a todos
%% -->  "xavier:  Hola a todos\n"
%% -->  este es un mensaje de prueba
%% -->  "xavier:  este es un mensaje de prueba\n"
%% -->  q
%% logging out{log_out,<0.37.0>}
%% (client@xavierpc.teteny.elte.hu)3> chatc:start(melinda).
%% Access denied, Try to register first
%% ok
%% (client@xavierpc.teteny.elte.hu)4> chatc:start(csilla).
%% Access denied, Try to register first
%% ok
%% (client@xavierpc.teteny.elte.hu)5>


%%OFFLINE MESSAGE

%%SERVER
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name server -setcookie apple
%% Eshell V6.4  (abort with ^G)
%% (server@xavierpc.teteny.elte.hu)1> c(chat).
%% {ok,chat}
%% (server@xavierpc.teteny.elte.hu)2> chat:start(10).
%% true
%% (server@xavierpc.teteny.elte.hu)3> Registering anna
%% (server@xavierpc.teteny.elte.hu)3> Registering dizzy
%% (server@xavierpc.teteny.elte.hu)3> User dizzy is registered
%% (server@xavierpc.teteny.elte.hu)3> chatserver ! dump.
%% State: {state,10,
%%               [{dizzy,on},{anna,off}],
%%               [{<9978.37.0>,dizzy}],
%%               [{anna,["dizzy:  Hola a todos\n","dizzy:  esta es una prueba\n",
%%                       "dizzy:  de mensajes fuera de linea\n"]}]}
%% dump
%% (server@xavierpc.teteny.elte.hu)4> User anna is registered

%%CLIENT 1(Online Client)
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name client2 -setcookie apple
%% Eshell V6.4  (abort with ^G)
%% (client2@xavierpc.teteny.elte.hu)1> c(chatc).
%% {ok,chatc}
%% (client2@xavierpc.teteny.elte.hu)2> chatc:regc(dizzy).
%% Registering:
%% "Registration successful"
%% (client2@xavierpc.teteny.elte.hu)3> chatc:start(dizzy).
%% -->  Hola a todos
%% -->  "dizzy:  Hola a todos\n"
%% -->  esta es una prueba
%% -->  "dizzy:  esta es una prueba\n"
%% -->  de mensajes fuera de linea
%% -->  "dizzy:  de mensajes fuera de linea\n"
%% -->  "anna:  gracias, ya recibi los mensajes\n"
%% -->  "anna:  buen dia\n"
%% -->  ahora me voy a desconectar
%% -->  "dizzy:  ahora me voy a desconectar\n"
%% -->  "anna:  buen dia\n"
%% -->  q
%% logging out{log_out,<0.37.0>}
%% (client2@xavierpc.teteny.elte.hu)3> chatc:start(dizzy).
%% Offline Messages
%% anna:  me olvide de decirte que tienes examen
%% -->  Muchas gracias por avisarme
%% -->  "dizzy:  Muchas gracias por avisarme\n"
%% -->


%%CLIENT2(Offline client)
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name client -setcookie apple
%% Eshell V6.4  (abort with ^G)
%% (client@xavierpc.teteny.elte.hu)1> c(chatc).
%% {ok,chatc}
%% (client@xavierpc.teteny.elte.hu)4> chatc:regc(anna).
%% Registering:
%% "Registration successful"
%% (client@xavierpc.teteny.elte.hu)5> chatc:start(anna).
%% Offline Messages
%% dizzy:  Hola a todos
%% dizzy:  esta es una prueba
%% dizzy:  de mensajes fuera de linea
%% -->  gracias, ya recibi los mensajes
%% -->  "anna:  gracias, ya recibi los mensajes\n"
%% -->  buen dia
%% -->  "anna:  buen dia\n"
%% -->  me olvide de decirte que tienes examen
%% -->  "anna:  me olvide de decirte que tienes examen\n"
%% -->  "dizzy:  Muchas gracias por avisarme\n"


%%Server Storage
%% (server@xavierpc.teteny.elte.hu)3> chat:save().
%% Saving State in det table <0.37.0> {save,<0.37.0>}
%% (server@xavierpc.teteny.elte.hu)4> chat:shutdown().
%% Shutting down <0.37.0> Shutting down Server 
%% State: {state,10,
%%               [{dizzy,on},{anna,on},{dianita,off},{xavi,off}],
%%               [{<7656.37.0>,dizzy},
%%                {<7658.37.0>,dizzy},
%%                {<7658.37.0>,dizzy},
%%                {<7659.37.0>,anna}],
%%               [{dizzy,["busco a la rana rene","se fue con la galleta",
%%                        "dizzy:  fasdfasdfasdfasdfasdfasdf\n",
%%                        "dizzy:  sadfasdfadsf\n","dianita:  afsdfasdfa\n",
%%                        "dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                        "dizzy:  fanslijdfnalskjdf\n",
%%                        "dizzy:  fas;dkfnaslkdjf a\n",
%%                        "dizzy:  fasn;dkjfanskjdf\n",
%%                        "dizzy:  as;kdfjbnasldkjfan\n"]},
%%                {dianita,["dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                          "dizzy:  fanslijdfnalskjdf\n",
%%                          "dizzy:  fas;dkfnaslkdjf a\n",
%%                          "dizzy:  fasn;dkjfanskjdf\n",
%%                          "dizzy:  as;kdfjbnasldkjfan\n"]},
%%                {xavi,["xavi probando","hay alguien ahi","no encuentro",
%%                       "dizzy:  fasdfasdfasdfasdfasdfasdf\n",
%%                       "dizzy:  sadfasdfadsf\n","dianita:  afsdfasdfa\n",
%%                       "dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                       "dizzy:  fanslijdfnalskjdf\n",
%%                       "dizzy:  fas;dkfnaslkdjf a\n",
%%                       "dizzy:  fasn;dkjfanskjdf\n",
%%                       "dizzy:  as;kdfjbnasldkjfan\n"]}]}
%% 
%% (server@xavierpc.teteny.elte.hu)1> chat:start(10).
%% true
%% (server@xavierpc.teteny.elte.hu)2> chatserver ! dump.
%% State: {state,10,[],[],[]}
%% dump
%% (server@xavierpc.teteny.elte.hu)3> chat:recover().
%% Recovering State in det table <0.37.0>
%%  {recover,<0.37.0>}
%% (server@xavierpc.teteny.elte.hu)4> chatserver ! dump.
%% State: {state,10,
%%               [{dizzy,on},{anna,on},{dianita,off},{xavi,off}],
%%               [{<7656.37.0>,dizzy},
%%                {<7658.37.0>,dizzy},
%%                {<7658.37.0>,dizzy},
%%                {<7659.37.0>,anna}],
%%               [{dizzy,["busco a la rana rene","se fue con la galleta",
%%                        "dizzy:  fasdfasdfasdfasdfasdfasdf\n",
%%                        "dizzy:  sadfasdfadsf\n","dianita:  afsdfasdfa\n",
%%                        "dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                        "dizzy:  fanslijdfnalskjdf\n",
%%                        "dizzy:  fas;dkfnaslkdjf a\n",
%%                        "dizzy:  fasn;dkjfanskjdf\n",
%%                        "dizzy:  as;kdfjbnasldkjfan\n"]},
%%                {dianita,["dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                          "dizzy:  fanslijdfnalskjdf\n",
%%                          "dizzy:  fas;dkfnaslkdjf a\n",
%%                          "dizzy:  fasn;dkjfanskjdf\n",
%%                          "dizzy:  as;kdfjbnasldkjfan\n"]},
%%                {xavi,["xavi probando","hay alguien ahi","no encuentro",
%%                       "dizzy:  fasdfasdfasdfasdfasdfasdf\n",
%%                       "dizzy:  sadfasdfadsf\n","dianita:  afsdfasdfa\n",
%%                       "dizzy:  fnlaksjdfnalksjdnfalksjdfnalksjdfna;kjsdf\n",
%%                       "dizzy:  fanslijdfnalskjdf\n",
%%                       "dizzy:  fas;dkfnaslkdjf a\n",
%%                       "dizzy:  fasn;dkjfanskjdf\n",
%%                       "dizzy:  as;kdfjbnasldkjfan\n"]}]}
%% dump
%% (server@xavierpc.teteny.elte.hu)5>

%%MONITOR
%% C:\Users\Xavier\WorkspaceErlang\PracticeDel\src>erl -name server -setcookie apple
%% Eshell V6.4  (abort with ^G)
%% (server@xavierpc.teteny.elte.hu)1> c(chat).
%% {ok,chat}
%% (server@xavierpc.teteny.elte.hu)2> chat:start().
%% Restarter iniciated
%% <0.45.0>
%% (server@xavierpc.teteny.elte.hu)3> chatserver ! dump.
%% State: {state,10,[],[],[]}
%% dump
%% (server@xavierpc.teteny.elte.hu)4> chatserver ! crash.
%% Exit catched, restarting, reason:  {simulated_error,
%%                                     [{chat,loop,1,
%%                                       [{file,"chat.erl"},{line,119}]}]}
%% Restarted iniciated
%% crash
%% (server@xavierpc.teteny.elte.hu)5>
%% =ERROR REPORT==== 20-Dec-2015::15:40:45 ===
%% Error in process <0.46.0> on node 'server@xavierpc.teteny.elte.hu' with exit val
%% ue: {simulated_error,[{chat,loop,1,[{file,"chat.erl"},{line,119}]}]}
%% 
%% (server@xavierpc.teteny.elte.hu)5> chatserver ! dump.
%% State: {state,10,[],[],[]}
%% dump
%% (server@xavierpc.teteny.elte.hu)6>

