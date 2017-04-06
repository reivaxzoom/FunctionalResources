	%% @author Xavier
%% @doc @todo Add description to pattern.


-module(pattern).

-compile(export_all).

my_length4(L)->
    case is_proplist(L) of
	 A when A == true ->
	    my_length(L);
	A when A == false  ->
	    not_a_proplist;
	A when true ->
	    not_a_proplist
    end.

my_length3(L)->
    A = is_proplist(L), 
    if  
	L /=[] -> 0;
	A ->   my_length(L);
	true ->  not_a_proplist %% A /= true
    end.

my_length2(L)->
    case is_proplist(L) of
	true ->
	    my_length(L);
	false ->
	    not_a_proplist
    end.

my_length1([_H | T] =L) ->
    case {L, is_proplist(L)} of
	{L, true} -> 1 + my_length1(T);
	_ -> not_a_proplist
    end;
my_length1([]) ->
    0.

is_proplist([H | T]) when is_tuple(H) ->
    is_proplist(T);
is_proplist([]) ->
    true;
is_proplist(_) ->
    false.


my_length([H | T]) when is_tuple(H) ->
    1 + my_length(T);
my_length([]) ->
    0;
my_length(List)  when is_list(List) ->
    throw(not_a_proplist). %% throw(), exit(), error()

f(_A, _A) ->
    equal;
f(_, _) ->
    not_equal.

g(_, _) ->
    not_equal;
g(_A, _A) ->
    equal.


%% melinda@mwork:~$ erl
%% Erlang/OTP 17 [erts-6.2] [source-aaaefb3] [64-bit] [smp:4:4] [async-threads:10] [hipe] [kernel-poll:false]

%% Hello Melinda!!!!Eshell V6.2  (abort with ^G)
%% 1> X = {1,2}.
%% {1,2}
%% 2> {A, B} = {1}.
%% ** exception error: no match of right hand side value {1}
%% 3> {A, B} = X.  
%% {1,2}
%% 4> A.
%% 1
%% 5> B.
%% 2
%% 6> {C, C} = X.
%% ** exception error: no match of right hand side value {1,2}
%% 7> {C, C} = {1,2}.
%% ** exception error: no match of right hand side value {1,2}
%% 8> {C, 1} = {1,2}.
%% ** exception error: no match of right hand side value {1,2}
%% 9> 1 =2.
%% ** exception error: no match of right hand side value 2
%% 10> [{A, A}, {B, A}, 3, [H | T], [H1, H2 | Tail]] = [{1,1}, {apple, 1}, 3, [apple, apple], [apple]].
%% ** exception error: no match of right hand side value 
%%                     [{1,1},{apple,1},3,[apple,apple],[apple]]
%% 11> [{A, A}, {B, A}, 3, [H | T], [H1, H2 | Tail]] = [{1,1}, {apple, 1}, 3, [apple, apple], [apple, 1,2,3,3]].
%% ** exception error: no match of right hand side value 
%%                     [{1,1},{apple,1},3,[apple,apple],[apple,1,2,3,3]]
%% 12> f(B).
%% ok
%% 13> f().
%% ok
%% 14> [{A, A}, {B, A}, 3, [H | T], [H1, H2 | Tail]] = [{1,1}, {apple, 1}, 3, [apple, apple], [apple, 1,2,3,3]].
%% [{1,1},{apple,1},3,[apple,apple],[apple,1,2,3,3]]
%% 15> Tail.
%% [2,3,3]
%% 16> pwd().
%% /home/melinda
%% ok
%% 17> c(pattern).
%% pattern.erl:7: Warning: variable 'A' is unused
%% pattern.erl:7: Warning: variable 'B' is unused
%% {ok,pattern}
%% 18> c(pattern).
%% {ok,pattern}
%% 19> pattern:f(1,1).
%% equal
%% 20> pattern:f(1,2).
%% not_equal
%% 21> c(pattern).    
%% {ok,pattern}
%% 22> pattern:f(1,1).
%% equal
%% 23> pattern:f(1,2).
%% ** exception error: no function clause matching pattern:f(1,2) (pattern.erl, line 5)
%% 24> c(pattern).    
%% pattern.erl:12: Warning: this clause cannot match because a previous clause at line 10 always matches
%% {ok,pattern}
%% 25> pattern:g(1,1).
%% not_equal
%% 26> c(pattern).    
%% pattern.erl:5: Warning: variable 'H' is unused
%% pattern.erl:15: Warning: this clause cannot match because a previous clause at line 13 always matches
%% {ok,pattern}
%% 27> pattern:my_length([1,23]).
%% ** exception error: no function clause matching pattern:my_length([]) (pattern.erl, line 5)
%%      in function  pattern:my_length/1 (pattern.erl, line 6)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%% 28> c(pattern).               
%% pattern.erl:5: Warning: variable 'H' is unused
%% pattern.erl:17: Warning: this clause cannot match because a previous clause at line 15 always matches
%% {ok,pattern}
%% 29> pattern:my_length([1,23]).
%% 2
%% 30> pattern:my_length([1,23]).
%% 2
%% 31> c(pattern).               
%% pattern.erl:17: Warning: this clause cannot match because a previous clause at line 15 always matches
%% {ok,pattern}
%% 32> c(pattern).               
%% pattern.erl:17: Warning: this clause cannot match because a previous clause at line 15 always matches
%% {ok,pattern}
%% 33> pattern:my_length([{1,2}, {2,3}]).
%% 2
%% 34> pattern:my_length([{1,2}, {2,3}, apple]).
%% ** exception error: no function clause matching pattern:my_length([apple]) (pattern.erl, line 5)
%%      in function  pattern:my_length/1 (pattern.erl, line 6)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%% 35> c(pattern).                              
%% pattern.erl:19: Warning: this clause cannot match because a previous clause at line 17 always matches
%% {ok,pattern}
%% 36> pattern:my_length([{1,2}, {2,3}, apple]).
%% ** exception error: an error occurred when evaluating an arithmetic expression
%%      in function  pattern:my_length/1 (pattern.erl, line 6)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%% 37> pattern:my_length([apple, {1,2}, {2,3}, apple]).
%% not_a_proplist
%% 38> pattern:my_length([{1,2}, {2,3}, apple]).       
%% ** exception error: an error occurred when evaluating an arithmetic expression
%%      in function  pattern:my_length/1 (pattern.erl, line 6)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%% 39> 1 + atom.
%% ** exception error: an error occurred when evaluating an arithmetic expression
%%      in operator  +/2
%%         called as 1 + atom
%% 40> c(pattern).                                     
%% pattern.erl:19: Warning: this clause cannot match because a previous clause at line 17 always matches
%% {ok,pattern}
%% 41> pattern:my_length([{1,2}, {2,3}, apple]).
%% ** exception throw: not_a_proplist
%%      in function  pattern:my_length/1 (pattern.erl, line 10)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%%      in call from pattern:my_length/1 (pattern.erl, line 6)
%% 42> catch pattern:my_length([{1,2}, {2,3}, apple]).
%% not_a_proplist
%% 43> catch 1/0.                                     
%% {'EXIT',{badarith,[{erlang,'/',[1,0],[]},
%%                    {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,661}]},
%%                    {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,434}]},
%%                    {shell,exprs,7,[{file,"shell.erl"},{line,684}]},
%%                    {shell,eval_exprs,7,[{file,"shell.erl"},{line,639}]},
%%                    {shell,eval_loop,3,[{file,"shell.erl"},{line,624}]}]}}
%% 44> tl([]).
%% ** exception error: bad argument
%%      in function  tl/1
%%         called as tl([])
%% 45> c(pattern).                                    
%% pattern.erl:5: illegal guard expression
%% pattern.erl:5: Warning: variable 'H' is unused
%% error
%% 46> c(pattern).
%% pattern.erl:5: call to local/imported function is_proplist/1 is illegal in guard 
%% pattern.erl:5: Warning: variable 'H' is unused
%% pattern.erl:10: Warning: variable 'L' is unused
%% error
%% 47> c(pattern).
%% pattern.erl:5: Warning: variable 'H' is unused
%% pattern.erl:13: Warning: variable 'L' is unused
%% pattern.erl:30: Warning: this clause cannot match because a previous clause at line 28 always matches
%% {ok,pattern}
%% 48> c(pattern).
%% pattern.erl:13: Warning: variable 'L' is unused
%% pattern.erl:30: Warning: this clause cannot match because a previous clause at line 28 always matches
%% {ok,pattern}
%% 49> c(pattern).
%% pattern.erl:30: Warning: this clause cannot match because a previous clause at line 28 always matches
%% {ok,pattern}
%% 50> pattern:my_length1([{1,2}, {2,3}, apple]).     
%% 3
%% 51> c(pattern).                               
%% pattern.erl:35: Warning: this clause cannot match because a previous clause at line 33 always matches
%% {ok,pattern}
%% 52> pattern:is_proplist([{1,2}, {2,3}, apple]). 
%% false
%% 53> pattern:is_proplist([{1,2}, {2,3}]).       
%% true
%% 54> pattern:is_proplist([{1,2}, apple, {2,3}]).
%% false
%% 55> pattern:is_proplist([]).                   
%% true
%% 56> pattern:my_length1([{1,2}, {2,3}, apple]). 
%% not_a_proplist
%% 57> c(pattern).                                
%% pattern.erl:43: Warning: this clause cannot match because a previous clause at line 41 always matches
%% {ok,pattern}
%% 58> pattern:my_length2([{1,2}, {2,3}, apple]).
%% not_a_proplist
%% 59> pattern:my_length2([{1,2}, {2,3}]).       
%% 2
%% 60> pattern:my_length2(apple).         
%% not_a_proplist
%% 61> c(pattern).                               
%% pattern.erl:49: Warning: this clause cannot match because a previous clause at line 47 always matches
%% {ok,pattern}
%% 62> pattern:my_length3(apple).
%% not_a_proplist
%% 63> pattern:my_length3([{1,2}, {2,3}]).
%% 2