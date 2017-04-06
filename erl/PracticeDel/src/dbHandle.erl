-module(dbHandle).
-compile(export_all).

%% start() -> start( l ).


start() ->
	register(dbchat, spawn(fun() -> init() end)),
	 global:register_name(dbchat, whereis(dbchat)).


init() ->
    process_flag(trap_exit, true),
	 ChatDB = ets:new( 'chatDB',  [] ).
	 
main() ->
        ChatDB = ets:new( 'chatDB',  [] ),
        io:format( " dbName ~w ~n ", [ ChatDB ] ),
		
        % note: table is not square
%%         populate( ChatDB, [{xavier,l}, {bugs,l}, {goofy,o}, {taz,o}, {duffy,o}, {taz,o}] ),
        populate( ChatDB, [{xavier,l}] ),
        Member = ets:member( ChatDB, xavier ),
        io:format( " member ~w ~n ", [ Member ] ),
%%         show_next_key( ChatDB, xavier ),
%%         find_chatState( ChatDB, ChatState ),
		show_all(ChatDB).



show_next_key( _ChatDB, '$end_of_table' ) -> [];
show_next_key( ChatDB,  Key) ->
	
        Next = ets:next( ChatDB, Key ),
%%         io:format( " next ~w ~n ", [ Next ] ),
        [Key|show_next_key( ChatDB, Next )].

populate( _ChatDB, [] ) -> {done,start};
populate( ChatDB, [H | T] ) ->
                ets:insert( ChatDB, H ),
                populate( ChatDB, T ).
        
find_chatState( ChatDB, ChatState ) ->
        ets:match( ChatDB, { '$1', chatState } ).

show_all(ChatDB) ->
	First=ets:first(ChatDB),
	All=show_next_key(ChatDB,First).
%%     io:format( " All ~p ~n ", All ).