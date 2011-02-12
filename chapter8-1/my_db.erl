%% Author: Steve
%% Created: Nov 12, 2010
%% Description: TODO: Add description to echo
-module(my_db).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/0,stop/0,write/2,delete/1,read/1,match/1,code_upgrade/0]).
-export([server/1]).

%%
%% API Functions
%%
start() -> 
	Db = db:new(),
	register(my_db_server, spawn(?MODULE, server, [Db])),
	ok.

stop() -> 
	my_db_server ! {stop, self()},
	receive
  		{reply, Msg} -> Msg
	end.

write(Key, Element) ->
	my_db_server ! {write, Key, Element, self()},	
	receive
  		{reply, Msg} -> Msg
	end.

delete(Key) ->
	my_db_server ! {delete, Key, self()},	
	receive
  		{reply, Msg} -> Msg
	end.

read(Key) ->
	my_db_server ! {read, Key, self()},	
	receive
  		{reply, Msg} -> Msg
	end.

match(Element) ->
	my_db_server ! {match, Element, self()},	
	receive
  		{reply, Msg} -> Msg
	end.

code_upgrade() ->
    my_db_server ! {upgrade, self()},
    receive
	{reply, Msg} -> Msg
    end.

server(Db) -> 
	receive
		{write, Key, Element, Source} ->
			NewDB = db:write(Key, Element, Db),
			Source ! {reply, ok},
			server(NewDB);
		{delete, Key, Source} ->
			NewDb = db:delete(Key, Db),
			Source ! {reply, ok},
			server(NewDb);
		{read, Key, Source} ->
			Response = db:read(Key, Db),
			Source ! {reply, Response},
			server(Db);
		{match, Element, Source} ->
			Response = db:match(Element, Db),
			Source ! {reply, Response},
			server(Db);
	        {upgrade, Source} ->
		        code:load_file(db),
		        NewDb = db:upgrade(Db),
		        Source ! {reply, ok},
		        server(NewDb);
		{stop, Source} ->
			Source ! {reply, ok}
	end.


%%
%% Local Functions
%%

