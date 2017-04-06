-module(sixth).
-compile(export_all).

%% sql(N,M) ->
	
%% 	Res ={
%% 		  begin
%% 			  Sq = x*x
%% 		  
%% 		  }
%% 	N*M.	

%% 	Res=[ X*X || X <- lists:seq(N,M)]; 
%% 	io:format("N: ~p, \nM : ~p, \n~p\n", [N,M,Res]);

ntimes(N) ->
%% 	X =2,
%% 	Res= [X || X <-lists:seq(1, N)],
%% 	[X || X <-lists:seq(1, N)].
%% 	[{X,Y} || X<- lists:seq(1, N),Y <-lists:seq(1, X) ].
	[{X,Y} || X<- lists:seq(1, N),Y <-lists:seq(1, X), ((X+Y)>1) or (length(X)<5) ].
%% lists:keyfind(Key, N, TupleList)