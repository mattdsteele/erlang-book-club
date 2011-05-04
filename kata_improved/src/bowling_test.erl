%% Author: 
%% Created: Mar 18, 2011
%% Description: TODO: Add description to bowling_test
-module(bowling_test).

%%
%% Include files
%%
-include_lib("eunit/include/eunit.hrl").

%%
%% Exported Functions
%%
-export([]).


%%
%% Local Functions
%%

gutter_game_test() ->
	GameData = rollMany(20, 0, game:new()),
	Score = game:score(GameData), 
	?assertEqual(0, Score).

all_ones_test() ->
	GameData = rollMany(20, 1, game:new()),
	Score = game:score(GameData), 
	?assertEqual(20, Score).

one_spare_test() ->
	GameData = rollMany(2, 5, game:new()),
	GameData2 = game:roll(3, GameData),
	GameData3 = rollMany(17,0, GameData2),
	Score = game:score(GameData3), 
	?assertEqual(16, Score).

one_strike_test() ->
	GameData = game:roll(10, game:new()),
	GameData2 = game:roll(4, GameData),
	GameData3 = game:roll(3, GameData2),
	GameData4 = rollMany(16,0, GameData3),
	Score = game:score(GameData4),
	?assertEqual(24, Score).

perfect_game_test() ->
	GameData = rollMany(12,10, game:new()),
	?assertEqual(300, game:score(GameData)).

all_spares_test() ->
	GameData = rollMany(21, 5, game:new()),
	?assertEqual(150, game:score(GameData)).

heartbreaker_test() ->
	GameData = rollMany(11, 10, game:new()),
	GameData2 = game:roll(9, GameData),
	?assertEqual(299, game:score(GameData2)).

rollMany(Qty, _Pins, GameData) when Qty == 0 ->
	GameData;
rollMany(Qty, Pins, GameData) ->
	rollMany(Qty-1, Pins, game:roll(Pins, GameData)).

