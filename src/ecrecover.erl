-module(ecrecover).

%% API
-export([recover/2]).

%% NIF
-export([load/0]).
-on_load(load/0).

%%=============================================================================
%% NIF API

load() ->
    % Prefer locally built NIF (good for testing and exotic platforms) over
    % prebuilt binaries.
    case load_local_nif() of
        ok ->
            ok;
        {error, _} ->
            load_prebuilt_nif()
    end.

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

load_local_nif() ->
    EbinDir = filename:dirname(code:which(?MODULE)),
    AppDir = filename:dirname(EbinDir),
    PrivDir = filename:join(AppDir, "priv"),
    SoName = filename:join(PrivDir, atom_to_list(?MODULE)),
    erlang:load_nif(SoName, 0).

load_prebuilt_nif() ->
    case code:priv_dir(ecrecoverprebuilt) of
        {error, _} ->
            {error, prebuilt_priv_dir_not_found};
        PrivDir ->
            SoName = filename:join(PrivDir, atom_to_list(?MODULE)),
            erlang:load_nif(SoName, 0)
    end.

recover_(_Input) ->
    not_loaded(?LINE).
