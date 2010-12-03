%% Author: arungiri
%% Created: Nov 19, 2010
%% Description: TODO: Add description to whatever_I_want
-module(sort_test).

%%
%% Include files
%%
-include_lib("eunit/include/eunit.hrl").

%%
%% Exported Functions
%%
-export([]).

%%
%% API Functions
%%

sort_empty_lists_test() ->
	?assertEqual([],merge_sort:sort([])).

sort_one_element_list_test() ->
	?assertEqual([2],merge_sort:sort([2])).

sort_two_out_of_order_elements_test() ->
	?assertEqual([2,3],merge_sort:sort([3,2])).

sort_four_elements_test() ->
	?assertEqual([1,2,3,4],merge_sort:sort([4,2,3,1])).




%%
%% Local Functions
%%

