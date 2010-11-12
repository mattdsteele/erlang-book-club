-module('echo').
-export([start/0, print/1, exec/0, stop/0]).

start() ->
    register(listener, spawn(?MODULE, exec, [])),
    ok.

stop() ->
    listener ! stop.

print(Term) ->
    listener ! {print, Term},
    ok.


exec() ->
    receive
	stop -> ok;
	{print, Term} -> 
	    io:format("The dog says: ~w~n", [Term]),
	    exec()
    end.
