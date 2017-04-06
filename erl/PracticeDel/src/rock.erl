%% @author Xavier
%% @doc @todo Add description to rock.


 -module(rock).
 -behaviour(gen_server).
 % --------------------------------------------------------------- 
 % Example of a gen_server
 %  Purpose: a tutorial on gen_server
 %  Program: a program that plays "rock, paper, scissors" 
 %    in spanish and english 
 %  Topics covered:
 %     * starting a gen_server
 %    * stoping a gen_server 
 %    * using a gen_server to play a simple game 
 %    * make a call within a call
 %    * use calls and casts 
 %
 %
 % - for internal use 
 -export([init/1, handle_call/3, handle_cast/2]). 
 -export([handle_info/2, terminate/2, code_change/3]).
 
 % - quick halt (note: casts are Asynchronous)
 -export([stop/0]).
 
 % - for external use (note: calls are Synchronous)
 -export([start/0, translate/1, juego/1, list/0, play/1]).
 
  % @start the server
 start() ->             gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
 list()  ->             gen_server:call(?MODULE, {list}).
 translate(Word) ->     gen_server:call(?MODULE, {translate, Word}).
 %
 % use juego to play the game using spanish words
 juego(Word) ->         gen_server:call(?MODULE, {juego, Word}).
 
 % use play to play the game using english words 
 play(Word) ->        gen_server:call(?MODULE, {play, Word}).
 %
 % init
 init([]) -> Dictionary = dict:from_list(
   [{rock,roca},{paper,papel},{scissors,tijeras}]),
   {ok, Dictionary}.
 %
 % handle_call
 handle_call({list}, _From, Dictionary) ->
   Response = dict:to_list(Dictionary),
   {reply, Response, Dictionary};
 %
 % Here we make a call within a call
 handle_call({play, Word}, _From, Dictionary) ->
   Status = dict:is_key(Word, Dictionary),
   if
       Status == true ->
           SWord = dict:fetch(Word, Dictionary),
           {reply, Response, _} = 
               handle_call({juego, SWord}, _From, Dictionary);
       true -> 
           Response = your_word_is_not_valid
   end,
   {reply, Response, Dictionary};
 %   
 handle_call({juego, Word}, _From, Dictionary) ->
   List = dict:to_list(Dictionary),
   {_English, Spanish} = lists:unzip(List),
   Indexes = lists:seq(1, length(Spanish)),
   Enumerated = lists:zip(Spanish, Indexes),
   Enumerated_dictionary = dict:from_list(Enumerated),
   {_H,_M,S} = time(),
   N = (S rem length(Spanish)) + 1,
   Pick = lists:nth(N, Spanish),
   io:format("you play: ~w \n",[Word]),
   P = dict:fetch(Word, Enumerated_dictionary),
   Delta = ((N+3)-P) rem 3,
   Response = case Delta of
       0 -> {'I',picked,Pick,its_a,draw};
       1 -> {'I',picked,Pick,you,loose};
       2 -> {'I',picked,Pick,you,win};
       true -> {unknown, result}
   end,
   {reply, Response, Dictionary};
 %    
 handle_call({translate, Word}, _From, Dictionary) ->
   Response = case dict:is_key(Word, Dictionary) of
       true ->
           dict:fetch(Word, Dictionary);
       false ->
           {word_not_known, Word}
   end,
   {reply, Response, Dictionary};
 %
 handle_call(_Message, _From, Dictionary) -> {reply, error, Dictionary}.
 % - 
 stop() ->
   gen_server:cast(?MODULE, stop).
 %
 terminate(normal, _State) -> 
   ok.
 %
 handle_cast(stop, State) ->
   {stop, normal, State};
 %   
 % - lets keep the compiler quiet with all the call-backs
 handle_cast(_Message, Dictionary) -> {noreply, Dictionary}.
 handle_info(_Message, Dictionary) -> {noreply, Dictionary}.
 code_change(_OldVersion, Dictionary, _Extra) -> {ok, Dictionary}.
 
 % - sample output -----------------------------
 % c(rock).
 %   <compile is done>
 % rock:start().
 %   <server started>
 %
 % 67> rock:juego(tijeras).
 % you play: tijeras
 % {'I',picked,roca,you,loose}
 %
 % 68> rock:juego(tijeras).
 % you play: tijeras 
 % {'I',picked,papel,you,win} 
 %
 % 69> rock:juego(tijeras).
 % you play: tijeras  
 % {'I',picked,tijeras,its_a,draw}
 % ----------------------------------------------------