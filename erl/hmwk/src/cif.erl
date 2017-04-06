%% @author Xavier
%% @doc @todo Add description to 'Function clause - Case - If'.

%% Function clause - Case - If
-module('cif').

%% Define the function split_by/2 that splits a list based on some integer numbers.
%% The split_by function has two arguments. The first argument is a list of integers (Ints). The second argument is the list that has to processed (List). 
%% The output is a list of lists (Result).
%% The function operates as the following: - takes the first integer from Ints: 'N' - takes the first 'N' elements from List: SubList 
%% - puts SubList into the result list - recursively continues with the next integer from Ints and the rest of List.
%% You have to solve this in three different ways: 1. using function clauses 2. using case expressions 3. using if expressions
%% An example:
%% split_by([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]) = [[apple1, apple2, apple3], [apple4], [apple5, apple6]]

%% ====================================================================
%% API functions
%% ====================================================================
-compile(export_all).

split_by([],[]) -> [];
split_by(Y, H) -> 
	L= length(H),
	[(lists:sublist(H, 1,hd(Y))) | split_by(tl(Y), lists:sublist(H, (hd(Y)+1),L))].

%% cif:split_by([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]

split_by_case(A,B) ->
	case A of
		A when A ==[], B==[] -> [];
		Y=[H|T] when length(Y)>0 ->
			[lists:sublist(B,1,H) | split_by_case(T, lists:sublist(B, H+1,length(B)))]
		end.

%% cif:split_by_case([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]



split_by_if(A, B) ->
    if
       A=:=[] , B=:=[] ->[];
        true -> % works as an 'else' branch
            [(lists:sublist(B, 1,hd(A))) | split_by(tl(A), lists:sublist(B, (hd(A)+1),length(B)))]
    end.
%% cif:split_by_if([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]


%% ====================================================================
%% Logs
%% ====================================================================

%% (BeadAssigments@Xavier-pc)22> cif:split_by([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]
%% (BeadAssigments@Xavier-pc)23> cif:split_by_case([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]
%% (BeadAssigments@Xavier-pc)24> cif:split_by_if([3,1,2],[apple1, apple2, apple3, apple4, apple5, apple6]).
%% [[apple1,apple2,apple3],[apple4],[apple5,apple6]]
