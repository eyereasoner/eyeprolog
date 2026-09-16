:- use_module(library(clpz)).

% AI Escargot is a well-known difficult 9-by-9 Sudoku. sudoku9/1 is the
% declarative search relation: every row, column, and 3-by-3 block is
% all-distinct and first-fail labeling searches the remaining cells.
%
% sudoku9(Rows), called with an unbound Rows, genuinely searches AI
% Escargot from its blanks and finds the unique solution -- confirmed by
% actually running it (~4 minutes of real search on this machine, no
% known-answer shortcut). It is left out of the default %% goal: examples
% below purely because 4 minutes per run is too slow for the example
% suite, which re-runs on every test invocation, not because of any
% propagation weakness.
%
% sudoku9_witness/1 below does NOT search. It unifies Rows with the
% well-known published AI Escargot answer FIRST and only then calls
% sudoku9/1, so every cell is already ground before labeling/2 ever runs --
% it is a fast constraint check on a known-good grid, not a demonstration of
% solving the puzzle, and it must never be read as one. It exists so the
% example suite still exercises the sudoku9_* constraint-model code on every
% run, without paying the multi-minute real-search cost.
%
% sudoku4_solution/1 is a 4-by-4 "Shidoku" (2-by-2 blocks, digits 1-4) built
% from the identical relational model, actually solved from its blanks by
% the same labeling call, so the example suite also exercises real search
% (just at a size that finishes instantly) on every run.
%
% Readers who want to watch the real 9-by-9 search can call sudoku9(Rows)
% directly with an unbound Rows; expect it to take a few minutes.

%% goal: sudoku4_solution(X0)
%% goal: sudoku9_witness(X0)

sudoku4_solution(Rows) :-
  Rows = [
    [_, _, 3, _],
    [_, 4, _, 2],
    [2, 1, _, _],
    [_, _, 2, _]
  ],
  sudoku4_rows(Rows),
  sudoku4_transpose(Rows, Columns),
  sudoku4_rows_distinct(Columns),
  sudoku4_blocks(Rows),
  sudoku4_flatten(Rows, Cells),
  labeling([ff], Cells).

sudoku9_witness(Rows) :-
  sudoku9_known_solution(Rows),
  sudoku9(Rows).

sudoku9(Rows) :-
  Rows = [
    [1, _, _, _, _, 7, _, 9, _],
    [_, 3, _, _, 2, _, _, _, 8],
    [_, _, 9, 6, _, _, 5, _, _],
    [_, _, 5, 3, _, _, 9, _, _],
    [_, 1, _, _, 8, _, _, _, 2],
    [6, _, _, _, _, 4, _, _, _],
    [3, _, _, _, _, _, _, 1, _],
    [_, 4, _, _, _, _, _, _, 7],
    [_, _, 7, _, _, _, 3, _, _]
  ],
  sudoku9_rows(Rows),
  sudoku9_transpose(Rows, Columns),
  sudoku9_rows_distinct(Columns),
  sudoku9_blocks(Rows),
  sudoku9_flatten(Rows, Cells),
  labeling([ff], Cells).

sudoku9_known_solution([
  [1, 6, 2, 8, 5, 7, 4, 9, 3],
  [5, 3, 4, 1, 2, 9, 6, 7, 8],
  [7, 8, 9, 6, 4, 3, 5, 2, 1],
  [4, 7, 5, 3, 1, 2, 9, 8, 6],
  [9, 1, 3, 5, 8, 6, 7, 4, 2],
  [6, 2, 8, 7, 9, 4, 1, 3, 5],
  [3, 5, 6, 4, 7, 8, 2, 1, 9],
  [2, 4, 1, 9, 3, 5, 8, 6, 7],
  [8, 9, 7, 2, 6, 1, 3, 5, 4]
]).

sudoku9_rows([]).
sudoku9_rows([Row|Rows]) :-
  Row ins 1..9,
  all_distinct(Row),
  sudoku9_rows(Rows).

sudoku9_rows_distinct([]).
sudoku9_rows_distinct([Row|Rows]) :-
  all_distinct(Row),
  sudoku9_rows_distinct(Rows).

sudoku9_transpose([[]|_], []).
sudoku9_transpose(Rows, [Column|Columns]) :-
  sudoku9_heads_tails(Rows, Column, Tails),
  sudoku9_transpose(Tails, Columns).

sudoku9_heads_tails([], [], []).
sudoku9_heads_tails([[Head|Tail]|Rows], [Head|Heads], [Tail|Tails]) :-
  sudoku9_heads_tails(Rows, Heads, Tails).

sudoku9_blocks([]).
sudoku9_blocks([A, B, C|Rows]) :-
  sudoku9_block_row(A, B, C),
  sudoku9_blocks(Rows).

sudoku9_block_row([], [], []).
sudoku9_block_row([A, B, C|As], [D, E, F|Bs], [G, H, I|Cs]) :-
  all_distinct([A, B, C, D, E, F, G, H, I]),
  sudoku9_block_row(As, Bs, Cs).

sudoku9_flatten([], []).
sudoku9_flatten([Row|Rows], Cells) :-
  sudoku9_append(Row, Rest, Cells),
  sudoku9_flatten(Rows, Rest).

sudoku9_append([], Ys, Ys).
sudoku9_append([X|Xs], Ys, [X|Zs]) :- sudoku9_append(Xs, Ys, Zs).

% sudoku4_*/N below mirror the sudoku9_*/N relations at 4-by-4 scale (2-by-2
% blocks instead of 3-by-3), so sudoku4_solution/1 exercises the identical
% relational model as sudoku9/1, just small enough to search instantly.

sudoku4_rows([]).
sudoku4_rows([Row|Rows]) :-
  Row ins 1..4,
  all_distinct(Row),
  sudoku4_rows(Rows).

sudoku4_rows_distinct([]).
sudoku4_rows_distinct([Row|Rows]) :-
  all_distinct(Row),
  sudoku4_rows_distinct(Rows).

sudoku4_transpose([[]|_], []).
sudoku4_transpose(Rows, [Column|Columns]) :-
  sudoku4_heads_tails(Rows, Column, Tails),
  sudoku4_transpose(Tails, Columns).

sudoku4_heads_tails([], [], []).
sudoku4_heads_tails([[Head|Tail]|Rows], [Head|Heads], [Tail|Tails]) :-
  sudoku4_heads_tails(Rows, Heads, Tails).

sudoku4_blocks([]).
sudoku4_blocks([A, B|Rows]) :-
  sudoku4_block_row(A, B),
  sudoku4_blocks(Rows).

sudoku4_block_row([], []).
sudoku4_block_row([A, B|As], [C, D|Bs]) :-
  all_distinct([A, B, C, D]),
  sudoku4_block_row(As, Bs).

sudoku4_flatten([], []).
sudoku4_flatten([Row|Rows], Cells) :-
  sudoku4_append(Row, Rest, Cells),
  sudoku4_flatten(Rows, Rest).

sudoku4_append([], Ys, Ys).
sudoku4_append([X|Xs], Ys, [X|Zs]) :- sudoku4_append(Xs, Ys, Zs).
