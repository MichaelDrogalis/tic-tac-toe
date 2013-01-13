-module(core).
-export([player_a/0, player_b/0, player_a_game_loop/0, player_b_game_loop/0, main/1, update_board/4]).

update_board (Board, X, Y, "X") ->
    lists:sublist(Board, X) ++ [["x", "y", "z"]] ++ lists:sublist(Board, 2 + X, 3).

player_a () ->
    spawn(core, player_a_game_loop, []).

player_a_game_loop () ->
    receive
        {next_move, Board, Pid} ->
            Move = string:strip(io:get_line("Player A character: "), both, $\n),
            X = io:fread("Player A X: ", "~d"),
            Y  = io:fread("Player A Y: ", "~d"),
            Pid ! {next_move, Board, self()},
            player_a_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

player_b () ->
    spawn(core, player_b_game_loop, []).

player_b_game_loop () ->
    receive
        {next_move, Board, Pid} ->
            string:strip(io:get_line("Player B character: "), both, $\n),
            X = io:fread("Player B X: ", "~d"),
            Y  = io:fread("Player B Y: ", "~d"),
            Pid ! {next_move, Board, self()},
            player_b_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

main(_) ->
%%    Board = [[], [], []],
%%    A = player_a(),
%%    B = player_b(),
%%    A ! {next_move, Board, B},
%%    io:get_line("").
    update_board([[], [], []], 0, 2, "X").
    
