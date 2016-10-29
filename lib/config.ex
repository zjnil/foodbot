defmodule Config do
 def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
   case Application.get_env(app, key) do
     {:system, env_var} ->
       case System.get_env(env_var) do
         nil -> default
         val -> val
       end
     {:system, env_var, preconfigured_default} ->
       case System.get_env(env_var) do
         nil -> preconfigured_default
         val -> val
       end
     nil ->
       default
     val ->
       val
   end
 end

 @spec get_integer(atom(), atom(), integer()) :: integer
 def get_integer(app, key, default \\ nil) do
   case get(app, key, nil) do
     nil -> default
     n when is_integer(n) -> n
     n ->
       case Integer.parse(n) do
         {i, _} -> i
         :error -> default
       end
   end
 end
end
