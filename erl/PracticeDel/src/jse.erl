-module(jse).
-include("s.hrl").

-export([f/1,setup/0,server/0,inf/0]).

setup() ->
    spawn(node(),?MODULE,server,[]).

server() ->
    register(facserver,self()),
    facLoop().

facLoop() ->
    receive
	{Pid, N} ->
	    Pid ! {ok, fac(N)}
    end,
    facLoop().

f(N) -> 
		case is_prime(random:uniform(10)) of 
			true -> Node=?Nodea;
			false -> Node=?Nodeb
		end,
		
	{facserver, Node} ! {self(), N},
    receive
	{ok, Res} ->
	    Val = Res,
    io:format("Factorial of ~p is ~p.~n", [N,Val]),
    io:format("Provided by ~p~n", [Node])

	after
	5000 -> "Timeout try again"
    end.

fac(N) when N==0 ->
    1;
fac(N) ->
    N * fac(N-1).

inf()->
	 erlang:process_info(whereis(facserver), memory),
erlang:process_info(whereis(facserver),registered_name ),
erlang:process_info(whereis(facserver),stack_size ),
erlang:process_info(whereis(facserver),status ).


%% conNod(N)  ->
%%     case net_adm:ping(?Node) of
%% 	pong ->
%% 	    lists:delete(Elem, List1)
%% 		_ -> "Try it later"
%% 	    end;
%% 	pang -> "Try it later"
%%     end;



is_prime(N) ->
	case N of
		0-> false;
		1->false;
		2->true;
		N -> divisors(N)==[1,N]
end.
divisors(N) ->
	[X || X<-lists:seq(1, N), N rem X==0].



