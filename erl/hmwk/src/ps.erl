%% @author Xavier
%% @doc @todo Add description to ps.


-module(ps).
-compile(export_all).

%% Prime search
%% Implement the prime_search/0 function with the following behaviour:
%% 
%% read a number from the user (X)
%% if X is a number then check weather it is a prime number or not
%% if X is prime then say hello to the user
%% if X is not prime then calculate the closest prime to X and 
%% tell the user weather it is lesser or greater than X and ask 
%% the user to guess which is is the closest prime
%% continue from step 1 (read a number...) until the user provides a prime
%% Examples:
%% 
%% 1> mod:prime_search().
%% Provide a number:
%% --> 5.
%% 5 is a prime number, thank you!
%% 
%% 2> mod:prime_search().
%% Provide a number:
%% --> 35.
%% 35 is not a prime number. The closest prime is greater than 35.
%% Provide a number:
%% --> 38.
%% 38 is not a prime number. The closest prime is lesser than 38.
%% Provide a number:
%% --> 36.
%% 36 is not a prime number. The closest prime is greater than 36.
%% Provide a number:
%% --> 37.
%% 37 is a prime number, thank you!




%% ====================================================================
%%  functions
%% ====================================================================

prime_search()->
    case io:read("Provide a number: ") of
	{ok,A} when is_integer(A) -> 
		case is_prime(A) of
			true -> io:fwrite("~p is a prime number, thank you! \n",[A]);
			false -> 
					P =lists:sort([A| computePrimes(A*2)]),		
					U=hd(lists:filter(fun(X)-> X>A end, P)),
					M=lists:filter(fun(X)-> X<A end, P),
					L=lists:nth(length(M), M),
		
					
					if abs(A-U) < abs(A-L) ->
					io:fwrite("~p is not a prime number. The closest prime is greater than it ~p \n ",[A,A]),
					   prime_search();
					   
						%%U; %% Upper prime true statement
						true-> 	
						io:fwrite("~p is not a prime number. The closest prime is lesser than it ~p \n ",[A,A]),
					   prime_search()
						%% L  %%Lower prime else statement
					end
		
			end;
			
		
	{ok,_}  -> throw({error, {non_integer}})
    end.


is_prime(A)->
	length([X || X<-lists:seq(2,trunc(A/2) ),(A rem X ==0)  ])=:=0.

computePrimes(L) ->
	[X|| X<-lists:seq(2,L), is_prime(X)==true  ].




%% ====================================================================
%%  Logs
%% ====================================================================
%% (BeadAssigments@Xavier-pc)21> ps:prime_search().
%% Provide a number: 5.
%% 5 is a prime number, thank you! 
%% ok
%% (BeadAssigments@Xavier-pc)22> ps:prime_search().
%% Provide a number: 35.
%% 35 is not a prime number. The closest prime is greater than it 35 
%%  Provide a number: 38.
%% 38 is not a prime number. The closest prime is lesser than it 38 
%%  Provide a number: 36.
%% 36 is not a prime number. The closest prime is greater than it 36 
%%  Provide a number: 37.
%% 37 is a prime number, thank you! 
%% ok
%% (BeadAssigments@Xavier-pc)23> 
