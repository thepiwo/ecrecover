-module(ecrecover).
-export([start/1, stop/0, init/1]).
-export([ecrecover/1]).
-export([time_taken_to_execute/1]).

time_taken_to_execute(F) -> Start = os:timestamp(),
  F(),
  io:format("total time taken ~f seconds~n", [timer:now_diff(os:timestamp(), Start) / 1000000]).

start(ExtPrg) ->
    spawn(?MODULE, init, [ExtPrg]).
stop() ->
    ecrecover ! stop.

ecrecover(X) ->
    call_port({ecrecover, X}).

call_port(Msg) ->
    ecrecover ! {call, self(), Msg},
    receive
	{ecrecover, Result} ->
	    Result
    end.

init(ExtPrg) ->
    register(ecrecover, self()),
    process_flag(trap_exit, true),
    Port = open_port({spawn, ExtPrg}, [{packet, 2}]),
    loop(Port).

loop(Port) ->
    receive
	{call, Caller, Msg} ->
	    Port ! {self(), {command, encode(Msg)}},
	    receive
		{Port, {data, Data}} ->
		    Caller ! {ecrecover, Data}
	    end,
	    loop(Port);
	stop ->
	    Port ! {self(), close},
	    receive
		{Port, closed} ->
		    exit(normal)
	    end;
	{'EXIT', Port, _} ->
	    exit(port_terminated)
    end.

encode({_, X}) -> [1, X].
