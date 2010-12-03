%% Author: arungiri
%% Created: Nov 19, 2010
%% Description: TODO: Add description to sample
-module(merge_sort).

%%
%% Include files
%%

%%
%% Exported Functions
%%
-export([sort/1]).

%%
%% API Functions
%%

sort([]) -> [];

sort([H|[]]) -> [H];

sort(List) ->
	{L,R} = lists:split(length(List) div 2,List),
	LSorted = sort(L),
	RSorted = sort(R),
	merge(LSorted,RSorted).


merge([],List) ->List;

merge(List,[]) -> List;

merge([LH|LT],[RH|RT]) ->
	case LH<RH of
		true -> [LH|merge(LT,[RH|RT])];
		false -> [RH|merge([LH|LT],RT)]
	end.


%%
%% Local Functions
%%

