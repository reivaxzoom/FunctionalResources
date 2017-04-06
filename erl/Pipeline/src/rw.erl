%% @author Xavier
%% @doc @todo Add description to lines.

-define(Input, "C:/Users/Xavier/WorkspaceErlang/Pipeline/src/input.txt").
-define(Output, "C:/Users/Xavier/WorkspaceErlang/Pipeline/src/output.txt").
-define(Checklist, "C:/Users/Xavier/WorkspaceErlang/Pipeline/src/checklist.txt").

-module(rw).
-export([readTwits/0,rChklist/0, wr/1]).


readfile(FileName) ->
    {ok, Device} = file:open(FileName, [read]),
	A=get_all_lines(Device, []),
	string:tokens(lists:flatten(A), " ").

readTwits()->
	{ok, Device} = file:open(?Input, [read]),
	A=get_all_lines_twit(Device, []),
	B=lists:map(fun(Y)-> re:replace(Y, "[^a-zA-Z ]", " ", [global,{return,list}]) end , A),
	lists:map(fun(X) ->string:tokens(lists:flatten(X), " ") end, B).

rChklist() ->
	readfile(?Checklist).
	
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [Line])
    end.



get_all_lines_twit(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> %%Remove breaklines
			Twit =re:replace(re:replace(Line, "\\s+$", "", [global,{return,list}]), "^\\s+", "", [global,{return,list}]),
			get_all_lines(Device, lists:append(Accum ,[[Twit]]))
    end.
wr(Msg)->
	file:write_file(?Output, io_lib:fwrite("~p.\n", [Msg]),[append]).
