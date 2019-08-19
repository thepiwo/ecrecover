-module(ecrecover).

%% API
-export([recover/2]).

%% NIF
-export([load/0]).
-on_load(load/0).

%%=============================================================================
%% NIF API

load() ->
    SoName = filename:join(priv(), atom_to_list(?MODULE)),
    ok = erlang:load_nif(SoName, 0).

not_loaded(Line) ->
    erlang:nif_error({error, {not_loaded, [{module, ?MODULE}, {line, Line}]}}).

%%=============================================================================
%% External API

-spec recover(<<_:(32*8)>>, <<_:(65*8)>>) -> <<_:(32*8)>>.
recover(<<_:32/binary>> = Hash, <<_:65/binary>> = Sig) ->
    Input = <<Hash/binary, 0:(8*31), Sig/binary>>,
    case recover_(Input) of
        {ok, []} ->
            <<0:256>>;
        {ok, Res} ->
            erlang:list_to_binary(Res);
        _Err ->
            <<0:256>>
    end.

%%=============================================================================
%% Internal Functions

priv()->
  case code:priv_dir(ecrecoverprebuilt) of
      {error, _} ->
          EbinDir = filename:dirname(code:which(?MODULE)),
          AppPath = filename:dirname(EbinDir),
          filename:join(AppPath, "priv");
      Path ->
          Path
  end.

recover_(_Input) ->
    not_loaded(?LINE).
