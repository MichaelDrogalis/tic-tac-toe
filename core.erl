-module(core).
-export([player_a/0, player_b/0, player_a_game_loop/0, player_b_game_loop/0, main/1]).

player_a () ->
    spawn(core, player_a_game_loop, []).

player_a_game_loop () ->
    receive
        {next_move, Pid} ->
            io:get_line("Player A: "),
            Pid ! {next_move, self()},
            player_a_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

player_b () ->
    spawn(core, player_b_game_loop, []).

player_b_game_loop () ->
    receive
        {next_move, Pid} ->
            io:get_line("Player B: "),
            Pid ! {next_move, self()},
            player_b_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

main(_) ->
    A = player_a(),
    B = player_b(),
    A ! {next_move, B},
    io:get_line("").
    
