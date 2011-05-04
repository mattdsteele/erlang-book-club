%% Author: Steve
%% Created: Mar 18, 2011
%% Description: TODO: Add description to game
-module(game).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([new/0,roll/2,score/1]).

%%
%% API Functions
%%

new() -> [].

roll(Pins, GameData) -> GameData ++ [Pins].

score([Roll|[SecondRoll|[ThirdRoll|[]]]]) 
  when Roll == 10 ->
	io:format("score([~p | [~p | [~p | GameData]]])~n",
			  [Roll, SecondRoll, ThirdRoll]),
	10 + SecondRoll + ThirdRoll;
score([Roll|[SecondRoll|[ThirdRoll|GameData]]]) 
  when Roll == 10 ->
	io:format("score([~p | [~p | [~p | GameData]]])~n",
			  [Roll, SecondRoll, ThirdRoll]),
	10 + SecondRoll + ThirdRoll 
		+ score([SecondRoll|[ThirdRoll|GameData]]);

score([FirstRoll|[SecondRoll | [NextRoll| []]]]) 
  when FirstRoll + SecondRoll == 10 -> 
	io:format("score([~p | [~p | [~p | GameData]]])~n",
			  [FirstRoll, SecondRoll, NextRoll]),
	10 + NextRoll;  %%SPARE
  
score([FirstRoll|[SecondRoll | [NextRoll| GameData]]]) 
  when FirstRoll + SecondRoll == 10 -> 
	io:format("score([~p | [~p | [~p | GameData]]])~n",
			  [FirstRoll, SecondRoll, NextRoll]),
	10 + NextRoll + score([NextRoll|GameData]);  %%SPARE


score([FirstRoll|[SecondRoll | [NextRoll| GameData]]]) ->
    io:format("score([~p | [~p | [~p | GameData]]])~n",
			  [FirstRoll, SecondRoll, NextRoll]),
	 FirstRoll + SecondRoll + score([NextRoll|GameData]);

score([FirstRoll|[SecondRoll|[]]]) ->
	io:format("score([~p | [~p | []]])~n",
			  [FirstRoll, SecondRoll]),
	FirstRoll+SecondRoll;
score([Roll|[]]) -> 
	io:format("score([~p ])~n",
			  [Roll]),
	Roll;
score([]) ->
	io:format("score([])~n",[]),
	0.
%%
%% Local Functions
%%

