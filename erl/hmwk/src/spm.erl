%% @author Xavier
%% @doc @todo Add description to spm.
-module(spm).

%% Define the functions fst/1 and snd/1. 
%% The function fst/1 returns the first element of a Ytwo-tuple. 
%% The function snd/1 returns the second element of a two-tuple. 
%% For example: fst({foo, bar}) = foo and snd({foo, bar}) = bar. 
%% You must use pattern matching, using the element function is not allowed!
%% 
%% Define the functions head/1 and tail/1 for lists to extract 
%% the head/first element from the list and the tail of the original list. 
%% You have to use pattern matching, using the built in functions tl and hd is not allowed. 
%% The 'tail' of a list refers to the rest of the list after the head: taill([1,2,3,4,5]) = [2,3,4,5]. 
%% The head of the list is the first element of the list: hd([2,3,4]) = 2.

%% ====================================================================
%% API functions
%% ====================================================================
-export([]).
-compile(export_all).

fst({X,_Y}) ->X.
snd({_X,Y}) ->Y.

head([H|_T]) -> H.
tail([_H|T])-> T.

%% ====================================================================
%% Logs
%% ====================================================================
%% 248> G={foo, bar}.
%% {foo,bar}
%% 253> spm:fst(G).
%% foo
%% 254> spm:snd(G).
%% bar
%% 259> spm:head([2,3,4]).
%% 2
%% 260> spm:tail([1,2,3,4,5]).
%% [2,3,4,5]
%% 261>

