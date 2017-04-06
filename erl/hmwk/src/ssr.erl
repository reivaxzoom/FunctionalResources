%% @author Xavier
%% @doc @todo Add description to 'Spawn-send-receive'.

%% Spawn-send-receive
-module('ssr').

-compile(export_all).

run(Token) ->
	MPid = self(), %%Pid of the run
	Pid= spawn(?MODULE,processA,[MPid]),

	io:format("I'm process ~p and I've sent: ~p\n",[MPid,Token]),
	Pid ! Token, %%sending to procA

	receive 
 		Token -> 
			io:format("I'm process ~p and I've recieved ~p\n",[self(),Token])
	after
		50000 -> "end of execution 5 seg timeout\n" 
	end.

processA(MPid) ->
	receive 
		Token ->
	     io:format("I'm process ~p and I've recieved ~p \n",[self(),Token]),
 		 io:format("I'm process ~p and I've sent: ~p \n",[self(),Token]),
		 Pid= spawn(?MODULE,processB,[MPid]),
	     Pid ! Token %%sending to processB
end.
			
	
processB(MPid) ->
	receive 
		Token ->
	     io:format("I'm process ~p and I've recieved ~p\n",[self(),Token]),
 		 io:format("I'm process ~p and I've sent: ~p\n",[self(),Token]),
		 MPid ! Token  %%sending back to run
end.