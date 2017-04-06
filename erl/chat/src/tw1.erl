%% @author Xavier
%% @doc @todo Add description to tw1.


-module(tw1).

%% ====================================================================
%% API functions
%% ====================================================================
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
	 after
        1000000 -> io:format("timeout")
end,
%% 	main(0,LPid,0,TTwit),
%% 	main(length(CheckList), [], CheckList,Twits).
    done;
main(N, LPid, [HChkL|TChk],Twits) when is_integer(N), N > 0 ->
%% 	 process_flag(trap_exit, true),
    Pid=spawn(?MODULE, validate,[HChkL]),
	M=lists:append(LPid, [Pid]),
    main(N - 1,M,TChk,Twits).

validate(Pattern) ->
	receive
		{_,[],_,_,X,Y,MainPid} -> io:format("finish Pid list\n"),
			io:format("PidMain ~p",[MainPid]),					  
			MainPid ! {X, Y};
		{[],_,_,_,X,Y,MainPid} -> io:format("finish Twit\n " ),
			io:format("PidMain ~p",[MainPid]),					  
			MainPid ! {X, Y};
		
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
			end
	end.

