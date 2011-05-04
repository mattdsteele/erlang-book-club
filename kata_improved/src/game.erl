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

roll(Pins, [{Roll1} | MoreData]) when Roll1 < 10  -> [{Roll1, Pins}|MoreData];
roll(Pins, GameData) -> [{Pins}|GameData].

score(GameData) -> scoreGame(1, lists:reverse(GameData)).
	

%%
%% Local Functions
%%
scoreGame(FrameNumber, _) when FrameNumber > 10 -> 0;  %%Additional frames only added to 10th frame
scoreGame(FrameNumber, [Frame|GameData]) ->
	case Frame of 
		{10} -> 10 + getRoll(1, GameData) + getRoll(2, GameData) + scoreGame(FrameNumber + 1, GameData);
		{Roll1, Roll2} when Roll1 + Roll2 == 10 -> 10 + getRoll(1, GameData) + scoreGame(FrameNumber + 1, GameData);
		{Roll1, Roll2} -> Roll1 + Roll2 + scoreGame(FrameNumber + 1, GameData)
	end.


getRoll(_Position, []) -> 0;
getRoll(Position, [Frame| GameData]) -> 
	if 
		Position > tuple_size(Frame) -> getRoll(Position - tuple_size(Frame), GameData);
	    true -> element(Position, Frame)
	end.
	
	