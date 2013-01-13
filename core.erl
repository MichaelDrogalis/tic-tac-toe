-module(core).
-export([player_a/0, player_b/0, player_a_game_loop/0, player_b_game_loop/0, main/1, update_board/4]).

update_row (Row, Position, Move) ->
    Place = lists:nth(1, Row),
    [lists:sublist(Place, Position) ++ [Move] ++ lists:sublist(Place, Position + 2, 3)].

update_board (Board, X, Y, Move) ->
    lists:sublist(Board, X) ++
        update_row(lists:sublist(Board, X + 1, 1), Y, Move) ++
        lists:sublist(Board, X + 2, 3).

player_a () ->
    spawn(core, player_a_game_loop, []).

player_a_game_loop () ->
    receive
        {next_move, Board, Pid} ->
            io:format("Player A's turn. The board is:~n"),
            io:format("~p~n------~n", [Board]),
            Move = string:strip(io:get_line("Player A character: "), both, $\n),
            {ok, X} = io:fread("Player A X: ", "~d"),
            {ok, Y}  = io:fread("Player A Y: ", "~d"),
            Pid ! {next_move, update_board(Board, lists:nth(1, X), lists:nth(1, Y), Move), self()},
            player_a_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

player_b () ->
    spawn(core, player_b_game_loop, []).

player_b_game_loop () ->
    receive
        {next_move, Board, Pid} ->
            io:format("Player B's turn. The board is:~n"),
            io:format("~p~n------~n", [Board]),
            Move = string:strip(io:get_line("Player B character: "), both, $\n),
            {ok,X} = io:fread("Player B X: ", "~d"),
            {ok,Y}  = io:fread("Player B Y: ", "~d"),
            Pid ! {next_move, update_board(Board, lists:nth(1, X), lists:nth(1, Y), Move), self()},
            player_b_game_loop();
        _ ->
            io:format("Invalid signal.")
    end.

main(_) ->
    Board = [["-", "-", "-"], ["-", "-", "-"], ["-", "-", "-"]],
    A = player_a(),
    B = player_b(),
    A ! {next_move, Board, B},
    io:get_line("").
    
