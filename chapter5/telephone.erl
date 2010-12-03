%% Author: Jessica
%% Created: Dec 1, 2010
%% Description: TODO: Add description to telephone
-module(telephone).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/0, pickUpPhone/1, call/2, answer/2, hangup/1]).
-export([idle/0]).

%%
%% API Functions
%%

start() ->
	spawn(telephone, idle, []).

pickUpPhone(OwnNumber) ->
	OwnNumber ! off_hook.

call(CallFrom, CallTo) ->
	CallFrom ! {CallTo, outgoing}.

answer(CallTo, CallFrom) ->
	CallTo ! {CallFrom, off_hook}.

hangup(OwnNumber) ->
	OwnNumber ! on_hook.

idle() ->
	io:format("~p has a phone in an idle state",[self()]),
	receive
		{Number, incoming} ->
			io:format("~p has a phone that is ringing with call from ~p~n",[self(),Number]),
			ringing(Number);
		off_hook ->
			io:format("~p is ready to dial a number~n",[self()]),
			dial()
	end.

ringing(Number) ->
	receive
		{Number, other_on_hook} ->
			io:format("The phone of ~p stops ringing with the call from ~p~n",[self(),Number]),
			idle();
		{Number, off_hook} ->
			io:format("~p answers call from ~p~n",[self(),Number]),
			Number ! other_off_hook,
			connected(Number)
	end.

dial() ->
	receive
		{Number, outgoing} ->
			io:format("~p is calling the number ~p~n", [self(), Number]),
			Number ! {self(), incoming},
			waitForConnection(Number);
		on_hook ->
			io:format("~p replaced the phone before dialing~n",[self()]),
			idle()
	end.

waitForConnection(Number) ->
	io:format("~p is waiting for a connection with ~p~n", [self(), Number]),
	receive
		other_off_hook ->
			connected(Number);
		on_hook ->
			io:format("~p gives up on trying to get ~p to answer",[self(),Number]),
			Number ! {self(),other_on_hook},
			idle()
	end.
		

connected(Number) ->
	io:format("Call connected between ~p and ~p~n", [self(), Number]),
	receive
		on_hook ->
			io:format("~p Hung up on the call~n", [self()]),
			Number ! other_on_hook,
			idle();
		other_on_hook ->
			disconnected()
	end.

disconnected() ->
	io:format("~p has been disconnected by the other user~n", [self()]),
	receive
		on_hook ->
			io:format("~p is hanging up their phone~n",[self()]),
			idle()
	end.



%%
%% Local Functions
%%

