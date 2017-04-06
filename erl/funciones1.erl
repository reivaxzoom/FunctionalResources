-module(funciones1).
%% -export([hello_world/0,greet/2]).


-export([factorial/1, hello_world1/0, hello_world/1, doble/1, times/2,
    greet/2,
    anim/1, area/2,area/1]).

hello_world1() -> io:fwrite("hello, world\n").

hello_world(Name) -> io:fwrite("hello, world "++Name).


	factorial(0) -> 1;
	factorial(N) -> N * factorial(N-1).

	doble(X) ->
		times(X, 2).
	
	times(X, N) ->
		X * N.

	


%% function greet(Gender,Name)
%% 	if Gender == male ->
%% 	io:fwrite("Hello, Mr. %s!")
%% 	 if Gender == female then
%% 	print("Hello, Mrs. %s!", Name)
%% 	else
%% 	print("Hello, %s!", Name)
%% 	end

greet(male, Name) -> io:format("Hello, Mr. ~s!", [Name]);
greet(male, Name) -> io:format("Hello, Mr. ~s!", [Name]);
greet(female, Name) -> io:format("Hello, Mrs. ~s!", [Name]);
greet(undecided, Name) -> io:format("Hello ~s!", [Name]);
greet(_, Name) -> io:format("Hello, ~s!", [Name]).
%%hola:greet(male, "taz").

	area(Type, N) ->
			case Type of
				square -> N*N;
				circle -> math:pi() * N * N;
				tringle -> 0.5 * N * N
			end.
	%% 	hola:area(circle, 5).
	

area({cuadrado,N}) -> N*N;
area({circulo,R}) -> math:pi() * R * R;
area({triangulo,B, H}) -> 0.5 * B * H;
area({_}) -> {error, invalidObjec}.
%%hola:area({triangulo,5,5}).

anim(Animal) -> 
Talk = if 
Animal == cat  -> "meow";
Animal == beef -> "wow";
Animal == dog  -> "bark";
Animal == tree -> "bar";
Animal == taz  -> "grr";
true -> "fgdadfgna"
end, {Animal, "says " ++ Talk ++ "!"}.


	



	
