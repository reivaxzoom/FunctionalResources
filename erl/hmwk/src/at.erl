%% @author Xavier
%% @doc @todo Add description to my_is_atom.

-module(at).
-compile(export_all).

%% Define a function that reads the standard input until it gets a legal atom expression.
%% You have to use io:get_line/1 to read the input.
%% Example:
%% 1> mymod:atom_read("Give me an atom: ").
%% Give me an atom: 1.
%% Not an atom.
%% Give me an atom: {apple, 2}.
%% Not an atom.
%% Give me an atom: apple.
%% Thanks
%% 
%% 2> mymod:atom_read("Give me an atom: ").
%% Give me an atom: pear.
%% Thanks.
%% 
%% So you ask the user to type an atom. The user types something and you check it. 
%% If it is an atom, you stop the execution. If it is not an atom then you ask the 
%% user to type an atom again.
%% 
%% If you use io:get_line then you get a string as a result. In this case you should check 
%% the elements of the string one by one. For example: when the user types ap2ple, 
%% you get the following string: "ap2ple". It is a valid atom, because the first 
%% element is a lowercase letter and the others are alphanumerical.
%% 
%% "Apple" - is not valid, because the first element is an uppercase.
%% " 'Apple' " - is valid, because the first and the last element is a (single) quote.
%% Further help: a string is a list of integers, which is the ASCII code of the contained characters:
%% "ala"==[$a, $l, $a] == [97,108,97].
%% 1> $'. 39 2> $A. 65 3> $a. 97


 -define (AtomEx, "^[a-z\'\@](((?!__)[a-zA-Z0-9_@])*[a-zA-Z0-9\'])?$").

atom_read(N)->
 case io:get_line(N) of
    eof -> eof; %%empty
    Line ->	 
		Word=lists:sublist(Line, length(Line)-1), 
	 	evalEx(?AtomEx,Word,N) 
  end.

evalEx([],_,_) ->
    nomatch;
evalEx(RegAtEx,Text,N) ->
    case re:run(Text,RegAtEx,[{capture,none}]) of
    match ->
           io:format("~p It is an Atom, Thanks.~n",[Text]);
    nomatch ->
        io:format("~p  Not an atom. ~n",[Text]),
		atom_read(N)
    end.


%% ========================================================================================
%% Logs
%% ========================================================================================
%% 1> at:atom_read("Give me an atom: ").
%% Give me an atom: 1.
%% "1."  Not an atom.
%% Give me an atom: {apple,2}.
%% "{apple,2}."  Not an atom.
%% Give me an atom: apple
%% "apple"It is an Atom, Thanks.
%% ok
%% 2> at:atom_read("Give me an atom: ").
%% Give me an atom: ap2ple
%% "ap2ple"It is an Atom, Thanks.
%% ok
%% 3> at:atom_read("Give me an atom: ").
%% Give me an atom: "Apple"
%% "\"Apple\""  Not an atom.
%% Give me an atom: Apple
%% "Apple"  Not an atom.
%% Give me an atom: 'Apple'
%% "'Apple'"It is an Atom, Thanks.
%% ok





%% ========================================================================================
%% Helper functions
%% ========================================================================================
%% processFirstLetter(Word) ->
%% 	case Word of 
%% 		[] -> ok;
%% 		Word ->
%% 			if
%% 				((hd(Word)>65) and (hd(Word)<90)) -> io:fwrite("It is not an atom, First letter uppercase"), %% no uppercase A...Z
%% 				atom_read();
%% 				true ->processWords(Word)
%% 	  		end;
%% 	_->[]	
%% end.

%% processWords(Words) ->
%%   case Words of
%%     [] -> ok;
%% 	[Word] ->
%% 		processFirstLetter(Word);
%%     [W|Rest]->
%% 	if
%%        (W>97)and (W<122) -> processWords(Rest);
%%         true -> io:fwrite("It is not an atom, special caracter"),
%% 		atom_read()
%%       end;
%% 	_ -> []      
%% %% 	processWords(Rest)
%%   end.

