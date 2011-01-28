-module(mutex).
-export([start/0, stop/0]).
-export([wait/1, signal/1, construct/0]).
-export([init/0]).

start() ->
  Pid = spawn(?MODULE, init, []),
  link(Pid),
  register(mutex, Pid).

stop() ->
  mutex ! stop.

construct() ->
    wait(self()),
    io:format("locked~n", []).
    %%signal(self()).

wait(Pid) ->
  mutex ! {wait, Pid},
  receive ok -> ok end.

signal(Pid) ->
  mutex ! {signal, Pid}, ok.

init() ->
  process_flag(trap_exit, true),
  free().

free() ->
  receive
    {wait, Pid} ->
	  try 
		link(Pid),
  	    Pid ! ok,
        busy(Pid)
	  catch 
		_:_ -> free()
	  end;
    stop ->
      terminate()
  end.

busy(Pid) ->
  receive		
    {signal, Pid} ->
      free();
	{'EXIT', Pid, _Reason} ->
	  io:format("killed~n", []),
	  free()
  end.

terminate() ->
  receive
    {wait, Pid} ->
      exit(Pid, kill),
      terminate()
  after
    0 -> ok
  end.
