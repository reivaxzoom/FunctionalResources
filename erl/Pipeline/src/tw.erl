%% @author Xavier
%% @doc @todo Add description to tw.


-module(tw).

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

start() ->
	[_|CheckList]=rw:rChklist(),
	Twits=rw:readTwits(),
	
	main(length(CheckList), [], CheckList,Twits).

main(0,[],0,_)-> io:format("finish Pid on main  list\n");
main(0,_,0,[])-> io:format("finish Twit on main  list\n");


main(0,LPid=[HPid|TPid],_,[HTwit|TTwit]) ->
	[P|Q]=rw:rChklist(),%%extract the number in front of the line to split good and bad
	Bad =element(1,lists:split(element(1,string:to_integer(P)), Q)),
	Good =element(2,lists:split(element(1,string:to_integer(P)), Q)),

	io:format("\nTwit ~p \n ",[HTwit]),
	io:format("Pid First ~p \n",[HPid]),
	HPid ! {HTwit,TPid, Bad,Good, 0, 0, self()},

	receive
		{X,Y} -> io:format("Arrive Main Pid ~p  X ~p Y ~p \n ",[self(),X,Y]),
				G= X > 2* Y,
				B =Y > 2* X,
					case {G,B} of
						{true, false} ->io:format("good\n\n " ),
							rw:wr(1),
						main(0,LPid,0,TTwit);
						{false, true} ->io:format(" bad\n\n " ),
							rw:wr(-1),			
						main(0,LPid,0,TTwit);
						{false, false} ->io:format("neutral\n\n" ),
							rw:wr(0),
						main(0,LPid,0,TTwit);
				 		A ->io:format("A\n ~p ",[A] )

	end
%% 	 after 5000 ->
%%         exit(reason)
end,
%% 	main(0,LPid,0,TTwit),
%% 	main(length(CheckList), [], CheckList,Twits).
    done;
main(N, LPid, [HChkL|TChk],Twits) when is_integer(N), N > 0 ->
	 process_flag(trap_exit, true),
    Pid=spawn_link(?MODULE, validate,[HChkL]),
%% 	 link(Pid),
	M=lists:append(LPid, [Pid]),
    main(N - 1,M,TChk,Twits).

validate(Pattern) ->
	receive
		{_,[],_,_,X,Y,MainPid} -> io:format("finish Pid list\n"),
			io:format("PidMain ~p",[MainPid]),					  
			MainPid ! {X, Y},
			validate(Pattern);
		{[],_,_,_,X,Y,MainPid} -> io:format("finish Twit\n " ),
			io:format("PidMain ~p",[MainPid]),					  
			MainPid ! {X, Y},
			validate(Pattern);
		
		{Twit,[HPid|TPid],Bad,Good, X, Y,MainPid} -> 
			case lists:member(Pattern, Good) of
				false ->
						case lists:member(Pattern, Twit) of 
							false ->
							HPid ! {Twit,TPid,Bad,Good,X,Y,MainPid},
							io:format("sending ~p False Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X,Y]),
							validate(Pattern);
							
						   true ->
							  HPid ! {Twit,TPid,Bad,Good,X,Y+1,MainPid},
							  io:format("sending ~p False Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X,Y+1]),
							  validate(Pattern)
						end;
				true ->
					   case lists:member(Pattern, Twit) of 
							false ->
							HPid ! {Twit,TPid,Bad,Good,X,Y,MainPid},
							io:format("sending ~p True Pattern ~p Value ~p X ~p Y ~p \n ",[HPid, Pattern, lists:member(Pattern, Twit),X,Y]),
							validate(Pattern);
						   true ->
							  HPid ! {Twit,TPid,Bad,Good,X+1,Y,MainPid},
							io:format("sending ~p True Pattern ~p Value ~p X ~p Y ~p \n",[HPid,Pattern, lists:member(Pattern, Twit),X+1,Y]),
							validate(Pattern)
						end
			end;
		
		{'EXIT', Pid, normal} -> % normal termination
			ok;
		{'EXIT', Pid, shutdown} -> % manual termination
			ok;
		{'EXIT', Pid, _} ->
			notOk
%% 	after 100000->
%% 		exit(reason)
	end.

