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
    io:format("locked~n", []),
    signal(self()).

wait(Pid) ->
  mutex ! {wait, Pid},
  receive ok -> ok end.

signal(Pid) ->
  mutex ! {signal, Pid}, ok.

init() ->
  free().

free() ->
  receive
    {wait, Pid} ->
      Pid ! ok,
      busy(Pid);
    stop ->
      terminate()
  end.

busy(Pid) ->
  receive
    {signal, Pid} ->
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
