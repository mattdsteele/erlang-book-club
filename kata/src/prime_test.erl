%% Author: Steve
%% Created: Mar 11, 2011
%% Description: TODO: Add description to prime_test
-module(prime_test).

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

factors_of_one_test() ->
	?assertMatch([],primes:factors_of(1)).

