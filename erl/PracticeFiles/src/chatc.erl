-module(chatc).

-export([start/1]).
-include("a.hrl").


start(N) when is_atom(N) ->
    case net_adm:ping(?Node) of
	pong ->
	    case ?Srv:log_in(N) of
		ok -> 
		    Pid = self(),
		    spawn(fun()-> io(Pid) end),
		    loop();
		_ -> "Try it later"
	    end;
	pang -> "Try it later"
    end;
start(N) ->
    "Please provide an atom".

loop()->
    receive
	stop -> 
	    "Hello";
	{read, S} ->
	    ?Srv:send(S),
	    loop();
	{msg, Msg} ->
	    io:format("~p~n", [Msg]),
	    loop()
    end.

io(Pid)->
    case io:get_line("-->  ") of
	"q\n" -> 
	    Pid ! stop;
	S -> 
	    Pid ! {read, S},
	    io(Pid)
    end.

%% toth_m@pc4-15:~$ erl
%% Erlang R16B03 (erts-5.10.4) [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

%% Eshell V5.10.4  (abort with ^G)
%% 1> c(chat
%% 1> ).
%% chat.erl:6: bad record declaration
%% chat.erl:35: record state undefined
%% chat.erl:34: Warning: variable 'Max' is unused
%% error
%% 2> c(chat).
%% {ok,chat}
%% 3> chat:st
%% start/1  stop/0   
%% 3> chat:start(15).
%% true
%% 4> registered().  
%% [user_drv,standard_error,global_group,chatserver,
%%  error_logger,standard_error_sup,erl_prim_loader,rex,
%%  kernel_sup,inet_db,global_name_server,code_server,init,user,
%%  kernel_safe_sup,file_server_2,application_controller]
%% 5> chat:stop().   
%% stop
%% 6> registered().
%% [user_drv,standard_error,global_group,error_logger,
%%  standard_error_sup,erl_prim_loader,rex,kernel_sup,inet_db,
%%  global_name_server,code_server,init,user,kernel_safe_sup,
%%  file_server_2,application_controller]
%% 7> c(chat).       
%% chat.erl:14: Warning: function log_in/1 is unused
%% chat.erl:38: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 8> c(chat).
%% chat.erl:42: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 9> chat:st
%% start/1  stop/0   
%% 9> chat:start(15).
%% true
%% 10> chat:log_in('melinda' 
%% 10> ).
%% {log_in,<0.33.0>,melinda}
%% 11> chat:stop().         
%% stop
%% 12> c(chat).             
%% chat.erl:42: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 13> chat:start(15).      
%% true
%% 14> chat:log_in('melinda').
%% {log_in,<0.33.0>,melinda}
%% 15> chat:stop().           
%% State: {state,15,[{<0.33.0>,melinda}]} 
%% stop
%% 16> 
%% 16> rr(chat).
%% [state]
%% 17> #state{}.
%% #state{max = 10,users = undefined}
%% 18> #state{ users = 1. max = 2}.
%% * 1: syntax error before: '.'
%% 18> max = 2}.
%% * 1: syntax error before: '}'
%% 18> #state{ users = 1, max = 2}.
%% #state{max = 2,users = 1}
%% 19> {A, B, C} = #state{ users = 1, max = 2}.
%% #state{max = 2,users = 1}
%% 20> A.
%% state
%% 21> B.
%% 2
%% 22> C.
%% 1
%% 23> chat:start(15).                         
%% true
%% 24> chat:log_in('melinda').                 
%% {log_in,<0.33.0>,melinda}
%% 25> chat:stop().                            
%% State: {state,15,[{<0.33.0>,melinda}]} 
%% stop
%% 26> c(chat).    
%% chat.erl:46: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 27> chat:start(15).        
%% true
%% 28> chat:log_in('melinda').
%% {log_in,<0.33.0>,melinda}
%% 29> chat:stop().           
%% State: {state,15,[{<0.33.0>,melinda}]} 
%% #state{max = 15,users = [{<0.33.0>,melinda}]}
%% 30> c(chat).               
%% chat.erl:24: Warning: function send/1 is unused
%% chat.erl:54: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 31> c(chat).
%% chat.erl:54: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 32> chat:start(15).        
%% true
%% 33> chat:log_in('melinda').
%% {log_in,<0.33.0>,melinda}
%% 34> chat:stop().           
%% State: {state,15,[{<0.33.0>,melinda}]} 
%% #state{max = 15,users = [{<0.33.0>,melinda}]}
%% 35> c(chat).               
%% chat.erl:54: Warning: function handle_msg/1 is unused
%% {ok,chat}
%% 36> chat:start(15).        
%% true
%% 37> chat:log_in('melinda').
%% {log_in,<0.33.0>,melinda}
%% 38> chat:send("sdjfhsdkjfh ").
%% {msg,<0.33.0>,"sdjfhsdkjfh "}
%% 39> flush().
%% Shell got "melinda:  sdjfhsdkjfh "
%% ok
%% 40> chat:log_in('melindaaaaa').
%% {log_in,<0.33.0>,melindaaaaa}
%% 41> chat:send("sdjfhsdkjfh "). 
%% {msg,<0.33.0>,"sdjfhsdkjfh "}
%% 42> flush().                   
%% Shell got "melindaaaaa:  sdjfhsdkjfh "
%% Shell got "melindaaaaa:  sdjfhsdkjfh "
%% ok
