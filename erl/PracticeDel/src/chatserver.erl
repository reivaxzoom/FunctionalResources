%% @author Xavier
%% @doc @todo Add description to chatserver.



-module(chatserver).
-export([start/1]).
-export([init/1,loop/1,accepter/2,client/2,client_loop/2]).
 
-record(chat,{socket,accepter,clients}).
-record(client,{socket,name,pid}).
 
start(Port) -> spawn(?MODULE, init, [Port]).
 
init(Port) ->
    {ok,S} = gen_tcp:listen(Port, [{packet,0},{active,false}]),
    A = spawn_link(?MODULE, accepter, [S, self()]),
    loop(#chat{socket=S, accepter=A, clients=[]}).
 
loop(Chat=#chat{accepter=A,clients=Cs}) ->
    receive
        {'new client', Client} ->
            erlang:monitor(process,Client#client.pid),
            Cs1 = [Client|Cs],
            broadcast(Cs1,["new connection from ~s\r\n",
                          Client#client.name]),
            loop(Chat#chat{clients=Cs1});
        {'DOWN', _, process, Pid, _Info} ->
            case lists:keysearch(Pid, #client.pid, Cs) of
                false -> loop(Chat);
                {value,Client} -> 
                    self() ! {'lost client', Client},
                    loop(Chat)
            end;
        {'lost client', Client} ->
            broadcast(Cs,["lost connection from ~s\r\n",
                          Client#client.name]),
            gen_tcp:close(Client#client.socket),
            loop(Chat#chat{clients=lists:delete(Client,Cs)});
        {message,Client,Msg} ->
            broadcast(Cs,["<~s> ~s\r\n", Client#client.name, Msg]),
            loop(Chat);
        refresh ->
            A ! refresh,
            lists:foreach(fun (#client{pid=CP}) -> CP ! refresh end, Cs),
            ?MODULE:loop(Chat)
    end.
 
accepter(Sock, Server) ->
    {ok, Client} = gen_tcp:accept(Sock),
    spawn(?MODULE, client, [Client, Server]),
    receive
        refresh -> ?MODULE:accepter(Sock, Server)
    after 0 -> accepter(Sock, Server)
    end.
 
client(Sock, Server) ->
    gen_tcp:send(Sock, "Please respond with a sensible name.\r\n"),
    {ok,N} = gen_tcp:recv(Sock,0),
    case string:tokens(N,"\r\n") of
        [Name] ->
            Client = #client{socket=Sock, name=Name, pid=self()},
            Server ! {'new client', Client},
            client_loop(Client, Server);
        _ ->
            gen_tcp:send(Sock, "That wasn't sensible, sorry."),
            gen_tcp:close(Sock)
    end.
 
client_loop(Client, Server) ->
    {ok,Recv} = gen_tcp:recv(Client#client.socket,0),
    lists:foreach(fun (S) -> Server ! {message,Client,S} end,
                  string:tokens(Recv,"\r\n")),
    receive
        refresh -> ?MODULE:client_loop(Client, Server)
    after 0 -> client_loop(Client, Server)
    end.
 
broadcast(Clients, [Fmt|Args]) ->
    S = lists:flatten(io_lib:fwrite(Fmt,Args)),
    lists:foreach(fun (#client{socket=Sock}) ->
                          gen_tcp:send(Sock,S)
                  end, Clients).

