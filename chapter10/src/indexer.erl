%% Author: Steve
%% Created: Apr 1, 2011
%% Description: TODO: Add description to indexer
-module(indexer).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([index/1]).
-define(Punctuation, "(\\ |\\,|\\.|\\n)+").
%%
%% API Functions
%%

index(File) ->
	ets:new(indexTable, [ordered_set, named_table]),
	processFile(File),
    prettyIndex().

%%
%% Local Functions
%%

processFile(File) -> 
	{ok, IoDevice} = file:open(File, [read]),
	processLines(IoDevice,1).

processLines(IoDevice, N) -> 
	case io:get_line(IoDevice, "") of
		eof -> 
			ok;
		Line ->
			%io:format("Found Line: ~p~n",[Line]),
			processLine(Line, N),
			processLines(IoDevice, N+1)
	end.

processLine(Line, N) ->
	case regexp:split(Line, ?Punctuation) of
		{ok, Words} ->
			%io:format("Found Words: ~p~n",[Words]),
			processWords(Words, N);
		_ -> []
	end.

processWords(Words, N) ->
	case Words of 
		[] -> ok;
		[Word | Rest] ->
			if 
				length(Word) > 3 ->
					%io:format("Found a Word: ~p~n",[Word]),
					Normalise = string:to_lower(Word),
					ets:insert(indexTable, {{Normalise, N}});
				true -> ok
			end,
			processWords(Rest, N)
	end.

prettyIndex() -> 
	case ets:first(indexTable) of 
		'$end_of_table' ->
			ok;
		First ->
			case First of
				{Word, N} ->
					IndexEntry = {Word, [N]}
			end,
			prettyIndexNext(First, IndexEntry)
	end.

prettyIndexNext(Entry, {Word, Lines} = IndexEntry) ->
	Next = ets:next(indexTable, Entry),
	case Next of 
		'$end_of_table' ->
			prettyEntry(IndexEntry);
		{NextWord, M} ->
			if 
				NextWord == Word ->
					prettyIndexNext(Next, {Word, [M|Lines]});
				true ->
					prettyEntry(IndexEntry),
					prettyIndexNext(Next,{NextWord, [M]})
			end
	end.

prettyEntry(IndexEntry) -> ok.
	