-module(multire).

-compile(export_all).

multire([],_) ->
    nomatch;
multire([RE|RegExps],String) ->
    case re:run(String,RE,[{capture,none}]) of
    match ->
        RE;
    nomatch ->
        multire(RegExps,String)
    end.


test(Foo) ->
    test2(multire(["^Hello","world$","^....$","a-z"],Foo),Foo).

test2("^Hello",Foo) ->
    io:format("~p matched the hello pattern~n",[Foo]);
test2("world$",Foo) ->
    io:format("~p matched the world pattern~n",[Foo]);
test2("^....$",Foo) ->
    io:format("~p matched the four chars pattern~n",[Foo]);
test2(match,Foo) ->
    io:format("~p matched the four chars pattern~n",[Foo]);
test2(nomatch,Foo) ->
    io:format("~p failed to match~n",[Foo]).
