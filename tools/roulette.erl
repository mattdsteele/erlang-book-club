-module(roulette).

-export([choose/1]).

choose([]) -> {error, "Not so fast!" };
	      
choose(People) ->
    RandomItem = random:uniform(length(People)),
    io:fwrite("The unlucky individual: ~w~n", [lists:nth(RandomItem, People)]),
    ok.
