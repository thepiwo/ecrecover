-module(nifecrecover).

%% API
-export([ecrecover/1,
	 ecrecover_hex/1,
	 bin_to_hexstr/1,
	 hexstr_to_bin/1,
	 time_taken_to_execute/1
]).

%% Native library support
-export([load/0]).
-on_load(load/0).

ecrecover(_Input) ->
    not_loaded(?LINE).

ecrecover_hex(Input) ->
    Decoded = hexstr_to_bin(Input),
    {ok, PubKey} = ecrecover(Decoded),
    Encoded = bin_to_hexstr(PubKey),
    Encoded.


load() ->
    erlang:display(file:get_cwd()),
    Dir = case code:priv_dir(nifecrecover) of
              {error, bad_name} ->
                  filename:join(
                    filename:dirname(
                      filename:dirname(
                        code:which(?MODULE))), "priv");
              D -> D
          end,
    SoName = filename:join(Dir, atom_to_list(?MODULE)),
    ok = erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    erlang:nif_error({error, {not_loaded, [{module, ?MODULE}, {line, Line}]}}).

priv()->
  case code:priv_dir(?MODULE) of
      {error, _} ->
          EbinDir = filename:dirname(code:which(?MODULE)),
          AppPath = filename:dirname(EbinDir),
          filename:join(AppPath, "priv");
      Path ->
          Path
  end.

%%
time_taken_to_execute(F) -> Start = os:timestamp(),
  F(),
  io:format("total time taken ~f seconds~n", [timer:now_diff(os:timestamp(), Start) / 1000000]).

%%
bin_to_hexstr(Bin) ->
  lists:flatten([io_lib:format("~2.16.0B", [X]) ||
    X <- binary_to_list(Bin)]).

hexstr_to_bin(S) ->
  hexstr_to_bin(S, []).
hexstr_to_bin([], Acc) ->
  list_to_binary(lists:reverse(Acc));
hexstr_to_bin([X,Y|T], Acc) ->
  {ok, [V], []} = io_lib:fread("~16u", [X,Y]),
  hexstr_to_bin(T, [V | Acc]);
hexstr_to_bin([X|T], Acc) ->
  {ok, [V], []} = io_lib:fread("~16u", lists:flatten([X,"0"])),
  hexstr_to_bin(T, [V | Acc]).
