%% @author Xavier
%% @doc @todo Add description to 'Spawn-send-receive'.

%% Spawn-send-receive with registration
-module('ssr2').

-compile(export_all).

run(Token) ->
	MPid = self(), %%Pid of the run
	Pid = spawn_link(?MODULE, processA, [MPid]),
	register(procA, Pid),
	
	io:format("I'm process ~p and I've sent: ~p\n",[MPid,Token]),
	Pid ! Token,

	receive 
 		Token -> 
			io:format("I'm process ~p and I've recieved ~p\n",[self(),Token])
	after
		50000 -> "end of execution\n" 
	end.

processA(MPid) ->
	receive 
		Token ->
	     io:format("I'm process ~p and I've recieved ~p \n",[self(),Token]),
 		 io:format("I'm process ~p and I've sent: ~p \n",[self(),Token]),
		 Pid = spawn_link(?MODULE, processB, [MPid]),
		 register(procB, Pid),
	     Pid ! Token
end.
			
	
processB(MPid) ->
	receive 
		Token ->
	     io:format("I'm process ~p and I've recieved ~p\n",[self(),Token]),
 		 io:format("I'm process ~p and I've sent: ~p\n",[self(),Token]),
		 MPid ! Token
end.

%% For checking if the process name is already taken
%% f()->
%%     case whereis(procA) of
%% 	undefined ->
%% 		io:format("undefined"),
%% 	    ok;
%% 	{'Exit', _}
%% 		_ ->
%% 		io:format("it is already defined"),
%% 		catch unregister(procA),
%% 	    f()
%%     end.
