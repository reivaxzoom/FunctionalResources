%% @author Xavier
%% @doc @todo Add description to ch_sup.


-module(ch_sup).
-behaviour(supervisor).

-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(ch_sup, []).

init(_Args) ->
    {ok, {{one_for_one, 1, 60},
          [{chatserver, {chatserver, start_link, []},
            permanent, brutal_kill, worker, [chatserver]}]}}.

