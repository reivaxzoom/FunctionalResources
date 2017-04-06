-module(reg2).

-compile(export_all).

run(A, B)->
    process_flag(trap_exit, true),
    Pid1 = spawn_link(?MODULE, proc3, [A, B]),
    register(proc3, Pid1), % reg
    Pid2 = spawn_link(?MODULE, proc2, []),
    receive
	{'EXIT', Pid1, R} when R /= normal ->
	    f(),
	    register(proc3,spawn_link(?MODULE, proc3, [A, B+1]))%,
	    %Pid2 ! ok
    end.

f()->
    case whereis(proc3) of
	undefined ->
	    ok;
	_ ->
	    f()
    end.

proc2()->
    receive 
	after 5000 -> ok
    end,
    io:format("sth: ~p~n", [whereis(proc3)]),
    proc3 ! ok.

proc3(A, B)->
    A / B,
    receive
	_ ->
	    io:format("Message received\n")
    end.
    


%% toth_m@pc4-15:~$ erl
%% Erlang R16B03 (erts-5.10.4) [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

%% Eshell V5.10.4  (abort with ^G)
%% 1> c(reg).
%% reg.erl:14: Warning: variable 'A' is unused
%% {ok,reg}
%% 2> c(reg).
%% {ok,reg}
%% 3> reg: 
%% module_info/0  module_info/1  proc2/1        proc3/0        run/0          

%% 3> reg:run().
%% Message received<0.48.0>
%% 4> c(reg).   
%% {ok,reg}
%% 5> reg:run().
%% Message received
%% <0.57.0>
%% 6> c(reg).   
%% {ok,reg}
%% 7> reg:run().
%% Message received
%% <0.66.0>
%% 8> flush().
%% Shell got {'EXIT',<0.66.0>,normal}
%% Shell got {'EXIT',<0.65.0>,normal}
%% ok
%% 9> c(reg).   
%% reg.erl:14: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% reg.erl:14: Warning: this expression will fail with a 'badarith' exception
%% {ok,reg}
%% 10> reg:run().
%% <0.76.0>
%% 11> 
%% =ERROR REPORT==== 12-Nov-2015::10:28:52 ===
%% Error in process <0.75.0> with exit value: {badarith,[{reg,proc3,0,[{file,"reg.erl"},{line,14}]}]}


%% 11> flush().  
%% Shell got {'EXIT',<0.75.0>,
%%                   {badarith,[{reg,proc3,0,[{file,"reg.erl"},{line,14}]}]}}
%% Shell got {'EXIT',<0.76.0>,normal}
%% ok
%% 12> c(reg).   
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 13> reg:run().
%% ** exception error: undefined function reg:run/0
%% 14> reg:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:33:27 ===
%% Error in process <0.87.0> with exit value: {badarith,[{reg,proc3,2,[{file,"reg.erl"},{line,18}]}]}

%% <0.89.0>
%% 15> flush().     
%% Shell got {'EXIT',<0.88.0>,normal}
%% ok
%% 16> processes().
%% [<0.0.0>,<0.3.0>,<0.6.0>,<0.7.0>,<0.9.0>,<0.10.0>,<0.11.0>,
%%  <0.12.0>,<0.13.0>,<0.14.0>,<0.15.0>,<0.16.0>,<0.18.0>,
%%  <0.19.0>,<0.20.0>,<0.21.0>,<0.22.0>,<0.23.0>,<0.24.0>,
%%  <0.25.0>,<0.26.0>,<0.27.0>,<0.28.0>,<0.29.0>,<0.85.0>,
%%  <0.89.0>]
%% 17> pid(0, 89, 0).
%% <0.89.0>
%% 18> pid(0, 89, 0) ! apple.
%% Message received
%% apple
%% 19> processes().          
%% [<0.0.0>,<0.3.0>,<0.6.0>,<0.7.0>,<0.9.0>,<0.10.0>,<0.11.0>,
%%  <0.12.0>,<0.13.0>,<0.14.0>,<0.15.0>,<0.16.0>,<0.18.0>,
%%  <0.19.0>,<0.20.0>,<0.21.0>,<0.22.0>,<0.23.0>,<0.24.0>,
%%  <0.25.0>,<0.26.0>,<0.27.0>,<0.28.0>,<0.29.0>,<0.85.0>]
%% 20> c(reg).               
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 21> c(reg2).
%% reg2.erl:10: Warning: variable 'Pid1' is unused
%% reg2.erl:14: Warning: variable 'Pid' is unused
%% reg2.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 22> c(reg2).
%% reg2.erl:19: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 23> reg2:run(1,0).        

%% =ERROR REPORT==== 12-Nov-2015::10:40:15 ===
%% Error in process <0.114.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:40:15 ===
%% Error in process <0.115.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 24> apple ! ok.
%% ** exception error: bad argument
%%      in operator  !/2
%%         called as apple ! ok
%% 25> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 26> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:43:31 ===
%% Error in process <0.126.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:43:31 ===
%% Error in process <0.127.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 27> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 28> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.136.0>)
%%      in call from reg2:run/2 (reg2.erl, line 7)
%% 29> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 30> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:45:06 ===
%% Error in process <0.145.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:45:06 ===
%% Error in process <0.146.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 31> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 32> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.155.0>)
%%      in call from reg2:run/2 (reg2.erl, line 7)
%% 33> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 34> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:45:47 ===
%% Error in process <0.164.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:45:47 ===
%% Error in process <0.165.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 35> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 36> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.174.0>)
%%      in call from reg2:run/2 (reg2.erl, line 7)
%% 37> register(apple, self()).
%% true
%% 38> unregister(apple, self()).
%% ** exception error: undefined shell command unregister/2
%% 39> register(apple, self()).  
%% true
%% 40> unregister(apple).      
%% true
%% 41> register(apple, self()).
%% true
%% 42> 1/0.
%% ** exception error: an error occurred when evaluating an arithmetic expression
%%      in operator  '/'/2
%%         called as 1 / 0
%% 43> unregister(apple).      
%% ** exception error: bad argument
%%      in function  unregister/1
%%         called as unregister(apple)
%% 44> whereis(apple).
%% undefined
%% 45> c(reg).                   
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 46> reg2:run(1,0).            

%% =ERROR REPORT==== 12-Nov-2015::10:50:16 ===
%% Error in process <0.194.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:50:16 ===
%% Error in process <0.195.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 47> flush().
%% Shell got {'EXIT',<0.195.0>,
%%                   {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}}
%% ok
%% 48> self().
%% <0.185.0>
%% 49> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 50> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.206.0>)
%%      in call from reg2:run/2 (reg2.erl, line 7)
%% 51> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 52> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:55:26 ===
%% Error in process <0.215.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:55:26 ===
%% Error in process <0.216.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 53> flush().
%% Shell got {'EXIT',<0.216.0>,
%%                   {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}}
%% ok
%% 54> c(reg).       
%% reg.erl:18: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg}
%% 55> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.226.0>)
%%      in call from reg2:run/2 (reg2.erl, line 7)
%% 56> c(reg2).      
%% reg2.erl:22: syntax error before: '>'
%% error
%% 57> c(reg2).
%% reg2.erl:28: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 58> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:58:30 ===
%% Error in process <0.240.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,28}]}]}

%% sth: <0.242.0>
%% Message received
%% ok
%% 59> c(reg2).      
%% reg2.erl:24: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 60> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:58:48 ===
%% Error in process <0.250.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,24}]}]}

%% sth: <0.252.0>
%% Message received
%% ok
%% 61> c(reg2).      
%% reg2.erl:9: Warning: variable 'Pid2' is unused
%% reg2.erl:19: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 62> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::10:59:09 ===
%% Error in process <0.260.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,19}]}]}


%% =ERROR REPORT==== 12-Nov-2015::10:59:09 ===
%% Error in process <0.261.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,16}]}]}

%% true
%% 63> c(reg2).      
%% reg2.erl:24: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 64> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.270.0>)
%%      in call from reg2:run/2 (reg2.erl, line 8)
%% 65> c(reg2).      
%% reg2.erl:28: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 66> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::11:00:16 ===
%% Error in process <0.279.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,28}]}]}

%% sth: <0.281.0>
%% Message received
%% ok
%% 67> c(reg2).      
%% reg2.erl:18: syntax error before: 'end'
%% error
%% 68> c(reg2).      
%% reg2.erl:9: Warning: variable 'Pid2' is unused
%% reg2.erl:28: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 69> reg2:run(1,0).
%% sth: undefined

%% =ERROR REPORT==== 12-Nov-2015::11:00:51 ===
%% Error in process <0.294.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,28}]}]}


%% =ERROR REPORT==== 12-Nov-2015::11:00:51 ===
%% Error in process <0.295.0> with exit value: {badarg,[{reg2,proc2,0,[{file,"reg2.erl"},{line,25}]}]}

%% true
%% 70> c(reg2).      
%% reg2.erl:9: Warning: variable 'Pid2' is unused
%% reg2.erl:28: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 71> reg2:run(1,0).
%% ** exception error: bad argument
%%      in function  register/2
%%         called as register(proc3,<0.304.0>)
%%      in call from reg2:run/2 (reg2.erl, line 8)
%% 72> c(reg2).      
%% reg2.erl:9: Warning: variable 'Pid2' is unused
%% reg2.erl:28: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 73> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::11:01:29 ===
%% Error in process <0.313.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,28}]}]}

%% true
%% sth: <0.315.0>
%% Message received
%% 74> c(reg2).      
%% reg2.erl:9: Warning: variable 'Pid2' is unused
%% reg2.erl:33: Warning: the result of the expression is ignored (suppress the warning by assigning the expression to the _ variable)
%% {ok,reg2}
%% 75> reg2:run(1,0).

%% =ERROR REPORT==== 12-Nov-2015::11:03:23 ===
%% Error in process <0.323.0> with exit value: {badarith,[{reg2,proc3,2,[{file,"reg2.erl"},{line,33}]}]}

%% true
%% sth: <0.325.0>
%% Message received
%% 76> node().
%% nonode@nohost
%% 77> q().
%% ok
%% 78> toth_m@pc4-15:~$ 
%% toth_m@pc4-15:~$ 
%% toth_m@pc4-15:~$ ifconfig 
%% eth0      Link encap:Ethernet  HWaddr 44:8a:5b:54:cc:e5  
%%           inet addr:157.181.163.68  Bcast:157.181.163.255  Mask:255.255.255.0
%%           inet6 addr: fe80::468a:5bff:fe54:cce5/64 Scope:Link
%%           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
%%           RX packets:99805 errors:0 dropped:0 overruns:0 frame:0
%%           TX packets:69378 errors:0 dropped:0 overruns:0 carrier:0
%%           collisions:0 txqueuelen:1000 
%%           RX bytes:73426999 (73.4 MB)  TX bytes:72258610 (72.2 MB)

%% lo        Link encap:Local Loopback  
%%           inet addr:127.0.0.1  Mask:255.0.0.0
%%           inet6 addr: ::1/128 Scope:Host
%%           UP LOOPBACK RUNNING  MTU:65536  Metric:1
%%           RX packets:0 errors:0 dropped:0 overruns:0 frame:0
%%           TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
%%           collisions:0 txqueuelen:0 
%%           RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

%% toth_m@pc4-15:~$ erl -name melinda@157.181.163.68
%% Erlang R16B03 (erts-5.10.4) [source] [64-bit] [smp:4:4] [async-threads:10] [kernel-poll:false]

%% Eshell V5.10.4  (abort with ^G)
%% (melinda@157.181.163.68)1> net_adm:ping('melinda@157.181.163.68').
%% pong
%% (melinda@157.181.163.68)2> nodes().
%% []
%% (melinda@157.181.163.68)3> erlang:get_cookie  
%% (melinda@157.181.163.68)3> ().
%% 'FCZNSNDTIZXEPBJLNXSI'
%% (melinda@157.181.163.68)4> erlang:set_cookie(node(),apple ).
%% true
%% (melinda@157.181.163.68)5> erlang:get_cookie().             
%% apple
%% (melinda@157.181.163.68)6> nodes().                               
%% []
%% (melinda@157.181.163.68)7> node().
%% 'melinda@157.181.163.68'
%% (melinda@157.181.163.68)8> nodes().            
%% ['anna@157.181.163.67']
%% (melinda@157.181.163.68)9> 
%% =ERROR REPORT==== 12-Nov-2015::11:22:30 ===
%% ** Connection attempt from disallowed node 'marija@157.181.163.236' ** 

%% (melinda@157.181.163.68)9> nodes().
%% ['anna@157.181.163.67','peter@157.181.163.63']
%% (melinda@157.181.163.68)10> register(apple, self()).
%% true
%% (melinda@157.181.163.68)11> {apple, 'melinda@157.181.163.68'} ! asdfd.
%% asdfd
%% (melinda@157.181.163.68)12> flush().
%% Shell got asdfd
%% ok
%% (melinda@157.181.163.68)13> flush().                                  
%% Shell got hello
%% ok
%% (melinda@157.181.163.68)14> nodes().                                  
%% ['anna@157.181.163.67','peter@157.181.163.63',
%%  'marija@157.181.163.236']
%% (melinda@157.181.163.68)15> 