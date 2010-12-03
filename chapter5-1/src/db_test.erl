%% Author: Steve
%% Created: Nov 5, 2010
%% Description: TODO: Add description to db_test
-module(db_test).

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
new_test() ->
	Db = db:new(),
	?assertEqual([], Db).

destory_test() ->
	Db = db:new(),
	Ret = db:destroy(Db),
	?assertEqual(ok, Ret).

write_test() ->
	Db = db:new(),
	NewDb1 = db:write(key1, element1, Db),
	?assertEqual([{key1, element1}], NewDb1),
	
	NewDb2 = db:write(key2, element2, NewDb1),
	?assertEqual([{key2,element2},{key1, element1}], NewDb2).

read_test() ->
	Db = db:new(),
	Result = db:read(key, Db),
	?assertEqual({error, instance}, Result),
	
	NewDb1 = db:write(key1, element1, Db),
	
	Result1 = db:read(key1, NewDb1),
	?assertEqual({ok, element1}, Result1),


	NewDb2 = db:write(key2, element2, NewDb1),
	?assertEqual([{key2,element2},{key1, element1}], NewDb2),

	Result2 = db:read(key2, NewDb2),
	?assertEqual({ok, element2}, Result2),
	Result3 = db:read(key1, NewDb2),
	?assertEqual({ok, element1}, Result3),


	Result4 = db:read(doesnt_exist, NewDb2),
	?assertEqual({error, instance}, Result4).


delete_test() ->
	Db = db:new(),
	
	NewDb1 = db:write(key1, element1, Db),
	NewDb2 = db:write(key2, element2, NewDb1),
	
	DelDb = db:delete(key1, NewDb2),
	Result1 = db:read(key1, DelDb),
	?assertEqual({error, instance}, Result1),

	DelDb1 = db:delete(anything, DelDb),
	?assertEqual(DelDb1, DelDb).

match_test() ->
	Db = db:new(),
	
	NewDb1 = db:write(key1, element1, Db),
	NewDb2 = db:write(key2, element2, NewDb1),
	NewDb3 = db:write(key3, element2, NewDb2),
	
	Matches = db:match(element2, NewDb3),
	?assertEqual([key2,key3], Matches).
