-define(Srv, chat).
%% -define(Node, 'server@192.168.0.100').
-define(Node, 'server@xavierpc.teteny.elte.hu').
-define(Name, chatserver).
-record(state, {max = 10, regUser,users,hist}).
-record(client, {name}).


