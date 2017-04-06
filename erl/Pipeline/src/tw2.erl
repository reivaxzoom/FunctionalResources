%% @author Xavier
%% @doc @todo Add description to tw1.


-module(tw2).

%% Implement a pipeline in Erlang. You can find the pipeline specified on the lecture on slide_14.pfd (in Canvas) [https://canvas.elte.hu/files/2428/download?download_frd=1]
%% 
%% The problem you have to solve with a pipeline is: "Classifying twitter messages!"
%% The story is: "There was a new film premier yesterday evening. There are millions of twitter messages 
%% describing the audience's feels about the movie and the actors. Classify the messages whether its 
%% writer like or dislike the movie. "
%% There is an input file (checklist.txt) that contains a number at the beginning (K) and 2xK words. 
%% The first K words express bad feelings about the film, the next K words express good feeling about the film. 
%% You have to count the occurrences of these words in a twitter messages.

%% We have a main process who reads the content of checklist.txt. The main process starts 2xK processes 
%% and sends one word to each of them from checklist.txt. So, a started processes has to decide whether 
%% its word is part of a twitter message or not.
%% The main process communicates only with the firstly started task. The main process reads the twitter 
%% messages from an input file (input.txt) and sends the twitter messages to the first task one-by-one. 
%% A twitter message is one line in the input file. Then, the main process waits for messages from the 
%% last task. The message from the last task should contain the number of bad (Y) and good (X) words in a 
%% twitter message. Based on this numbers the main process decides whether it was good (X/2 > Y), 
%% bad (Y/2 > X) or neutral (otherwise). If the main process found that a message was good, then it prints'
%%  a 1 into an output file (output.txt),, if the message is bad, then it prints -1, if the message is good,
%%  then it prints 0.
%% According to the pipeline theory a process in the pipeline communicates only with its neighbors. 
%% It gets messages from the previous process and sends messages to the next process only. 
%% The first process gets messages from the main process, and the last process sends messages to the 
%% main process.
%% 
%% You have to solve the Pid distribution between processes. For example the main process can send 
%% the process ids of the neighbors to a processes.
%% 
%% Example checklist.txt:
%%  10 bad garbage terrible horrible boring poor weak nok awful second-rate good great amazing interesting wonderful valuable super excellent admirable awesome
%% 
%% Example input.txt:
%% 
%% ... his performance in the movie was amazing!
%% 
%% His performance in the movie was amazing, but the story is boring...
%% 
%% it's horrible :(
%% 
%% Example output.txt:
%% 
%% 1
%% 
%% 0
%% 
%% -1


-compile(export_all).
%%TestCase send message from no autorized process
%% {LPid, Bad, Good} =tw2:setup().
%% HPid=lists:nth(7, LPid).
%% HPid ! {["hola"],[], Bad,Good, 0, 0, self(),[],self()}.
%% lists:nth(7, LPid) ! {["hola"],[], Bad,Good, 0, 0, self(),[],self()}.

%%Normal Start
%%  {LPid, Bad, Good} =tw2:setup().
%%  tw2:start(rw:readTwits(),LPid, Bad, Good).
%%  tw2:shutdown(LPid).
start([],_,_,_) ->
	done;

start([HTwit|TTwit],LPid=[HPid|TPid], Bad, Good) ->
  
	HPid ! {HTwit,TPid, Bad,Good, 0, 0, self(),LPid,self()},
	io:format("\nTwit ~p \n ",[HTwit]),
	timer:sleep(2000),
	start(TTwit,LPid, Bad, Good),
	
	receive
		{X,Y,PidLast} when is_number(X), is_number(Y)-> 
			case lists:last(LPid)==PidLast of
				false ->notAllowed;
				true ->
				
					io:format("Arrive Main Pid ~p  X ~p Y ~p \n ",[self(),X,Y]),
						G= X > 2* Y,
						B =Y > 2* X,
							case {G,B} of
								{true, false} ->io:format("good\n" ),
									rw:wr(1);
								{false, true} ->io:format(" bad\n " ),
									rw:wr(-1);			
								{false, false} ->io:format("neutral\n" ),
									rw:wr(0);
						 		A ->io:format("A\n ~p ",[A] )
				end
			end;
	{A} -> io:format("Unrecognized object ~p\n",[A]);
	A -> io:format("Unrecognized object ~p\n",[A])
	
end,
    done.


setup() ->
	[_|CheckList]=rw:rChklist(),
main(length(CheckList), [], CheckList).

main(0,[],0)-> io:format("finish Pid on main  list\n");
main(0,_,0)-> io:format("finish Twit on main  list\n");


main(0,LPid,_) ->
	[P|Q]=rw:rChklist(),%%extract the number in front of the line to split good and bad
	Bad =element(1,lists:split(element(1,string:to_integer(P)), Q)),
	Good =element(2,lists:split(element(1,string:to_integer(P)), Q)),
	{LPid, Bad, Good};

main(N, LPid, [HChkL|TChk]) when is_integer(N), N > 0 ->
	 process_flag(trap_exit, true),
    Pid=spawn_link(?MODULE, validate,[HChkL]),
	M=lists:append(LPid, [Pid]),
    main(N - 1,M,TChk).

%% shutdown(LPid)
shutdown([]) ->
	done;
shutdown([HPid|TPid]) ->
	HPid ! {shutdown},
	shutdown(TPid).


validate(Pattern) ->
	receive
		{_,[],_,_,X,Y,MainPid,_, _} -> 
				MainPid ! {X, Y,self()},
				validate(Pattern);

		{Twit,LPid=[HPid|TPid],Bad,Good, X, Y,MainPid,AllPid, PrevPid} -> 
			
			LX =lists:subtract(AllPid, LPid),
			if(length(LX)>1) ->
				PreListPid=lists:last(element(1,lists:split(string:str(AllPid, [HPid])-2, AllPid)));
			  true ->
				  PreListPid =MainPid
			end,

			if(PrevPid ==PreListPid orelse MainPid==PrevPid ) ->
				  case lists:member(Pattern, Good) of
					false ->
							case lists:member(Pattern, Twit) of 
								false ->
								HPid ! {Twit,TPid,Bad,Good,X,Y,MainPid,AllPid, self()},
								io:format("sending ~p False Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X,Y]),
								validate(Pattern);
								
							   true ->
								  HPid ! {Twit,TPid,Bad,Good,X,Y+1,MainPid,AllPid,self()},
								  io:format("sending ~p False Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X,Y+1]),
								  validate(Pattern)
							end;
					true ->
						   case lists:member(Pattern, Twit) of 
								false ->
								HPid ! {Twit,TPid,Bad,Good,X,Y,MainPid,AllPid,self()},
								io:format("sending ~p True Pattern ~p Value ~p X ~p Y ~p \n ",[HPid, Pattern, lists:member(Pattern, Twit),X,Y]),
								validate(Pattern);
							   true ->
								  HPid ! {Twit,TPid,Bad,Good,X+1,Y,MainPid,AllPid,self()},
								io:format("sending ~p True Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X+1,Y]),
								validate(Pattern)
							end
				     end;
				  
				  true ->
					  io:format("Not allowed to process from the sender"),
					notallowed,
					validate(Pattern)
				
				end;
		{'EXIT', _, normal} -> 
			validate(Pattern);
		{shutdown} -> % manual termination
			io:format("shutting down process ~p\n",[self()]);
		{A} -> io:format("Unrecognized object ~p\n",[A]),
			 validate(Pattern);
		A -> io:format("Unrecognized object ~p\n",[A]),
			 validate(Pattern)
end.

