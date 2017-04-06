-define(Srv, chat).
-define(Node, 'server@157.181.163.68').
-define(Name, chatserver).
-record(state, {max = 10, users}).

