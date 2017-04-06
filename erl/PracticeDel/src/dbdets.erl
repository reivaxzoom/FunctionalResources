%% @author Xavier
%% @doc @todo Add description to foo.


-module(dbdets).
-compile(export_all).

main() ->
	dets:open_file(mytable,[]),
	dets:insert(mytable,{xavier,vxavier}),
	dets:insert(mytable,{juan,vjuan}),
	dets:insert(mytable,{pedro,vpedro}),
	dets:lookup(mytable, juan).


show_next_key( ChatDB, '$end_of_table' ) -> [];
show_next_key( ChatDB,  Key) ->
        Next = dets:next( ChatDB, Key ),
		NextValue =dets:lookup(ChatDB, Next),
		[NextValue|show_next_key( ChatDB, Next )].
	
show_all(ChatDB) ->
	FirstKey=dets:first(ChatDB),
	FirstVal=dets:lookup(mytable, FirstKey),
	All=show_next_key(ChatDB,FirstKey),
	lists:flatten(lists:append([FirstVal], All)).



