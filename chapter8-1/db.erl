%% Author: Steve
%% Created: Nov 5, 2010
%% Description: This is the ORIGINAL db.erl file from chapter 3.
-module(db).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([new/0, destroy/1, write/3, read/2, delete/2, match/2]).

%%
%% API Functions
%%
new() -> [].

destroy(_Db) -> ok.

write(Key, Element, Db) ->
	[{Key, Element}|Db].

read(Key, [{Key,Element}|_T]) -> 
	{ok, Element};
read(_Key, []) ->
	{error, instance};
read(Key, [_H|T]) ->
	read(Key, T).

delete(Key, [{Key,_Element}|T]) -> T;
delete(Key, [H|T]) ->
	[H|delete(Key, T)];
delete(_Key, []) -> [].

match(Element, Db) ->
	find(Element, Db, []).
	
%%
%% Local Functions
%%
find(Element, [{Key,Element}|T], Found) ->
	find(Element, T, [Key|Found]);
find(Element, [_H|T], Found) ->
	find(Element, T, Found);
find(_Element, [], Found) -> Found.
	
