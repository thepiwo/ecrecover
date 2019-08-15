-module(ecrecover_util).

-export([ recover_from_hex/1
        , bin_to_hex/1
        , hex_to_bin/1
        ]).

%%=============================================================================
%% External API

recover_from_hex(Input) ->
    <<Hash:32/binary, _:31/binary, Sig:65/binary>> = hex_to_bin(Input),
    PubKey = ecrecover:recover(Hash, Sig),
    bin_to_hex(PubKey).

bin_to_hex(Bin) ->
    lists:flatten([io_lib:format("~2.16.0B", [X]) || X <- binary_to_list(Bin)]).

hex_to_bin(S) ->
    hex_to_bin(S, []).
hex_to_bin([], Acc) ->
    list_to_binary(lists:reverse(Acc));
hex_to_bin([X,Y|T], Acc) ->
    {ok, [V], []} = io_lib:fread("~16u", [X,Y]),
    hex_to_bin(T, [V | Acc]);
hex_to_bin([X|T], Acc) ->
    {ok, [V], []} = io_lib:fread("~16u", lists:flatten([X,"0"])),
    hex_to_bin(T, [V | Acc]).
