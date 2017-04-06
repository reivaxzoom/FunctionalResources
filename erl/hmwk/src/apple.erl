%% @author Xavier
%% @doc @todo Add description to apple.
-module(apple).
-compile(export_all).

prod(X,Y) -> X*Y.
doble() -> prod(2,prod(10,20)).



