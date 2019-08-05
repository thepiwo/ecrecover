-module(nifecrecover).

%% API
-export([ecrecover/2]).

%% Native library support
-export([load/0]).
-on_load(load/0).

ecrecover(_Input, _Output) ->
    not_loaded(?LINE).

load() ->
    ok = erlang:load_nif("/home/newby/projects/ethereum/ecrecover/target/debug/libecrecover", 0).

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
