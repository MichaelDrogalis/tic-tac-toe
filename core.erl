-module(core).
-export([player_a/0, player_b/0, main/1, update_board/4, game_loop/1]).

update_row (Row, Position, Move) ->
    Place = lists:nth(1, Row),
    [lists:sublist(Place, Position) ++ [Move] ++ lists:sublist(Place, Position + 2, 3)].

update_board (Board, X, Y, Move) ->
    lists:sublist(Board, X) ++
        update_row(lists:sublist(Board, X + 1, 1), Y, Move) ++
        lists:sublist(Board, X + 2, 3).

player_a () ->
    spawn(core, game_loop, ["A"]).

player_b () ->
    spawn(core, game_loop, ["B"]).

game_loop (Player) ->
    receive
        {next_move, Board, Pid} ->
            io:format("Player ~s's turn. The board is:~n", [Player]),
            io:format("~p~n------~n", [Board]),
            Move = string:strip(io:get_line("Character: "), both, $\n),
            {ok, X} = io:fread("X: ", "~d"),
            {ok, Y}  = io:fread("Y: ", "~d"),
            Pid ! {next_move, update_board(Board, lists:nth(1, X), lists:nth(1, Y), Move), self()},
            game_loop(Player);
        _ ->
            io:format("Invalid message.")
    end.

main(_) ->
    Board = [["-", "-", "-"], ["-", "-", "-"], ["-", "-", "-"]],
    A = player_a(),
    B = player_b(),
    A ! {next_move, Board, B},
    io:get_line("").
    
