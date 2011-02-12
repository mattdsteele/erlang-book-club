% Description: this is the NEW db.erl from chapter 8

-module(db).
-export([new/0, destroy/1, write/3, delete/2, read/2, convert/2, upgrade/1, upgrade/2, match/2]).
-vsn(1.2).

new() ->
     gb_trees:empty().

write(Key, Data, Db) ->
     gb_trees:insert(Key, Data, Db).

read(Key, Db) ->
    
  case gb_trees:lookup(Key, Db) of
    none         ->
	  {error, instance};
          {value, Data} -> {ok, Data}
  end.

destroy(_Db) -> ok.

delete(Key, Db) -> gb_trees:delete(Key, Db).

convert(dict,Dict) ->
  dict(dict:fetch_keys(Dict), Dict, new());
convert(_, Data) ->
  Data.

dict([Key|Tail], Dict, GbTree) ->
  Data = dict:fetch(Key, Dict),
  NewGbTree  = gb_trees:insert(Key, Data, GbTree),
  dict(Tail, Dict, NewGbTree);
dict([], _, GbTree) -> GbTree.

upgrade(ListDb) ->
    upgrade(ListDb, new()).
upgrade([{K,V}|T], NewDb) ->
    upgrade(T, write(K, V, NewDb));
upgrade([], NewDb) ->
    NewDb.

match(Element, Db) ->
    match(Element, [], gb_trees:next(gb_trees:iterator(Db))).

match(V, FoundItems, {K,V,Next}) ->
    match(V,[K|FoundItems], gb_trees:next(Next));
match(V, FoundItems, {_K,_NotFound,Next}) ->
    match(V,FoundItems, gb_trees:next(Next));
match(_V, FoundItems, none) ->
    FoundItems.
