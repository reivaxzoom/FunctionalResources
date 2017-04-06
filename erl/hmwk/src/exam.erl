%% @author Xavier
%% @doc @todo Add description to exam.


-module(exam).
-compile(export_all).

%% What is the scope of the Erlang variables?
%%if:variables bound outside of the if expression can be used
%% if the variable bound in every clause it can be used outside
%% of the if expression

%%Case: variables bound outside of the case expression can be used
%% if the variable bound in every clause it can be used outside
%% of the case expression

%% Explicit fun Expressions: variables bound outside of the fun expression can be used
%% variables bound in the patterns of the fun expression hide
%% the variables bound outside of the fun expression


%% Consider the following expression:
%% A=
%% 	case foo(B) of 
%% 		{ok, lesser} ->	result;
%% 			 {ok, C} -> C; 
%% 		  {error, D} -> D 
%% 	end.
%% 
%% What will A will bound to, if B = '123' and foo/1 is the following:
%% 	foo(X) when X < 1000 -> {ok, lesser}; 
%% 	foo(X) when is_atom(X) -> {ok, atom}; 
%% 	foo(X) -> {error, X}.
%% R: atom


%% Consider the following function:
 foo(1, X) -> length(X); 
	foo(2, X) -> throw({throw, X}); 
	foo(3, X) -> error({error, X}).
%% What will be the result of calling:
%% 
%%    catch foo(1, []).
%% 		0 
%%    catch foo(1, [1,2,3]) .
%% 		3
%%    catch foo(1, 1).
%% 		{'EXIT',{badarg,[{erlang,length,[1],[]},
%%                  {exam,foo,2,
%%                        [{file,"c:/Users/Xavier/workspaceDel/Bead/src/exam.erl"},
%%                         {line,43}]},
%%                  {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,661}]},
%%                  {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,434}]},
%%                  {shell,exprs,7,[{file,"shell.erl"},{line,684}]},
%%                  {shell,eval_exprs,7,[{file,"shell.erl"},{line,639}]},
%%                  {shell,eval_loop,3,[{file,"shell.erl"},{line,624}]}]}} 
%%    catch foo(2, []) 
%% 		{throw,[]}
%%    catch foo(3, [])
%% 		{'EXIT',{{error,[]},
%%          [{exam,foo,2,
%%                 [{file,"c:/Users/Xavier/workspaceDel/Bead/src/exam.erl"},
%%                  {line,45}]},
%%           {erl_eval,do_apply,6,[{file,"erl_eval.erl"},{line,661}]},
%%           {erl_eval,expr,5,[{file,"erl_eval.erl"},{line,434}]},
%%           {shell,exprs,7,[{file,"shell.erl"},{line,684}]},
%%           {shell,eval_exprs,7,[{file,"shell.erl"},{line,639}]},
%%           {shell,eval_loop,3,[{file,"shell.erl"},{line,624}]}]}}
 
%% What are the correct function names is Erlang? Underline the legal function names from the given list!
%% foo, foo1, foo_1, foo-1, 1foo, 'foo, 'foo1', '1foo', 'Foo1', Foo
%% A:foo, foo1,foo_1,'foo1','1foo','Foo1'


%% What is the result of the following list comprehension?
%% [X*2 || X <- lists:seq(1,20), (X rem 2 /= 0), X <10].
%% [2,6,10,14,18] 


%% What will happen with the following pattern matchings? If it succeed then what the values of the variables are.
%% [H1, H2 | [H3 | T]] = [1,2,3,4,5,6]
%% H1=1
%% H2=2
%% H3=3
%% T=[4,5,6]

%% [a1, a2 | Tail] = [1,2,3,4,5,6]
%% error: no match of right hand side value
 
%% [A1 | [A2 | B2]] = [1,2]
%% A1=1
%% A2=2
%% B2=[]

%% [A1 | [A2 | [B2]]] = [1,2,3]
%% ** exception error: no match of right hand side value
 
%% [A1 | [A2 | [B2]]] = [1,2,3,4,5]
%% ** exception error: no match of right hand side value [1,2,3,4,5]
%% 
%% List the rules of building a proper guard expression!
%% Underline the legal guard expressions! The variable A is already bound.
%% 
%% true, false, apple, 1+2, 1+2 > 3, is_atom(A), B = 3, A = 3, A == 3, length(A), lists:max(A), list_to_atom(A), A and B, (A > 3) and (A < 12)
%%A:true,false, 1+2 > 3,is_atom(A),A == 3, A == 3, (A > 3) and (A < 12)

%% Which value does the Erlang term 2#11 have?
%% 3
%% 
%% Implement the prodL/1 function that calculates the product of a list! prodL([3,3,3]) = 27
prodL([]) ->1;
prodL([H|T])-> H * prodL(T).

%% 10.Implement the prodN/1 function that calculates the product from 1 to N! prodN(3) = 6 (123)
prodN(N) -> prodL(lists:seq(1, N)).