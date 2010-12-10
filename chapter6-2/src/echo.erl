%% Author: igen356
%% Created: Nov 9, 2010
%% Description: Chapter 4 Exercise 1
-module(echo).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/0,print/1,stop/0,server/0]).

%%
%% API Functions
%%
start() -> 
    Pid = spawn_link(echo, server, []),
    register(echo_server, Pid),
	ok.

print(Term) ->
	echo_server ! {print, self(), Term},
	receive
		{reply, Msg} -> Msg
	end.

stop() ->
        exit(dead).

server() -> 
	receive
		{print, Source, Msg} ->
			io:format("~w~n", [Msg]),
		Source ! {reply, ok};
	    
		        

		{stop, Source} ->
			Source ! {reply, ok}
	end.

%%
%% Local Functions
%%

