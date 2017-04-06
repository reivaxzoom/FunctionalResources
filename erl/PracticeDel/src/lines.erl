%% @author Xavier
%% @doc @todo Add description to lines.


-module(lines).
-compile(export_all). 
readlines(FileName) ->
    {ok, Device} = file:open(FileName, [read]).
    
 
get_all_lines(Device, Accum) ->
    case io:get_line(Device, "") of
        eof  -> file:close(Device), Accum;
        Line -> get_all_lines(Device, Accum ++ [Line])
    end.

wr(Msg)->
	file:write_file("c:/Users/Xavier/WorkspaceErlang/PracticeDel/src/exa.txt", io_lib:fwrite("~p.\n", [Msg])).
