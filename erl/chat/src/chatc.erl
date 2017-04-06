-module(chatc).

-export([start/1,regc/1]).
-include("a.hrl").


start(N) when is_atom(N) ->
    case net_adm:ping(?Node) of
	pong ->
	    case ?Srv:log_in(N) of
		ok-> 
		    Pid = self(),
		    spawn(fun()-> io(Pid) end),
		    loop();
		deny ->	
			io:format("Access denied, Try to register first\n");
		Msg ->
			io:format("Offline Messages \n"++Msg),
			Pid = self(),	
		    spawn(fun()-> io(Pid) end),
		    loop()
	    end;
	pang -> "Try it later"
    end;
start(N) ->
    io:format("~p is not a valid name,Please provide an atom",[N]).

loop()->
    receive
	stop -> 
	    io:format("logging out"),
	    ?Srv:logout(self());
	{read, S} ->
	    ?Srv:send(S),
	    loop();
	{msg, Msg} ->
	    io:format("~p~n", [Msg]),
	    loop();
	hist ->
		?Srv:history(self()),
	    loop()
    end.

io(Pid)->
    case io:get_line("-->  ") of
	"q\n" -> 
	    Pid ! stop;
	S -> 
	    Pid ! {read, S},
	    io(Pid)	
    end.

regc(User) when is_atom(User) ->
	 case net_adm:ping(?Node) of
	pong -> 
	    case ?Srv:reg(User) of
		ok -> "Registration successful";
		_ -> "Register it later"
	    end;
	pang -> "not ping"
    end.
