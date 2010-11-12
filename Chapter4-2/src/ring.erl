%% Author: igen356
%% Created: Nov 10, 2010
%% Description: Chapter 4 Exercise 2
-module(ring).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([start/3,start_member/4]).

%%
%% API Functions
%%
start(M, 1, Message) ->
	io:format("root * child~n"),
	Child = spawn(ring, start_member, [self(), M, 1, Message]),
	io:format("root -> child~n"),
	Child ! {message, root, Message},
	io:format("root waiting~n"),
	wait(root, Child, M);
start(M, N, Message) when N > 1 -> 
	io:format("root * child~n"),
	Child = spawn(ring, start_member, [self(), M, N - 1, Message]),
	io:format("root -> child~n"),
	Child ! {message, root, Message},
	io:format("root waiting~n"),
	wait(root, Child, M).

	
%%
%% Local Functions
%%
start_member(Root, M, 1, Message) ->
	io:format("final *~n"),
	io:format("final -> root~n"),
	Root ! {message, final, Message},
	io:format("final waiting~n"),
	wait(final, Root, M);
start_member(Root, M, N, Message) ->
	io:format("~w * child~n", [N]),
	Child = spawn(ring, start_member, [Root, M, N - 1, Message]),
	io:format("~w -> child~n", [N]),
	Child ! {message, N, Message},
	io:format("~w waiting~n", [N]),
	wait(N, Child, M).
		 
wait(Self, Child, 1) ->
	receive
		{message, Self, _Message} -> io:format("~w terminated~n", [Self]);
		{message, Other, Message} -> io:format("~w -> ~w, -> child~n", [Other, Self]),
									 Child ! {message, Other, Message},
									 wait(Self, Child, 1)
	end;
wait(Self, Child, Iterator) -> 
	receive
				{message, Self, Message} -> io:format("~w received message ~w, sending next~n", [Self,Iterator]),
									Child ! {message, Self, Message},
									wait(Self, Child, Iterator - 1);
		{message, Other, Message} -> io:format("~w -> ~w, -> child~n", [Other, Self]),
									 Child ! {message, Other, Message},
									 wait(Self, Child, Iterator)
	end.

	