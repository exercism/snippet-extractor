%% Saddle points exercise
%% Finds cells that are largest in their row and smallest in their column.
-module(saddle_points).
-author("someone").
-behaviour(gen_server).
-compile(export_all).
-include_lib("eunit/include/eunit.hrl").
-import(lists, [max/1, min/1]).

-export([saddle_points/1,
         helper/2]).

-define(EMPTY, []).

% Entry point
saddle_points(?EMPTY) ->
	[];
saddle_points(Matrix) ->
	Rows = Matrix,
	Cols = transpose(Matrix),
	[{R, C} || {R, Row} <- enumerate(Rows),
	           {C, Col} <- enumerate(Cols),
	           is_saddle(Row, Col)].
