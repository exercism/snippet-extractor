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
