defmodule Hammox.ProtectCase do
  defmacro __using__(opts) do
    quote do
      for {name, arity, fun} <- generate_protected_funs(unquote(opts)) do
        def
      end
    end
  end

  def generate_protected_funs(opts) do
    module = get_module!(opts)
    behaviour = Keyword.get(opts, :behaviour)
    funs = Keyword.get(opts, :funs)

    module
    |> protect(behaviour, funs)
    |> Enum.map(fn {key, fun} ->
      {name, arity} = function_key_to_name_and_arity(key)
      {name, arity, fun}
    end)
  end

  @doc false
  def get_module!(opts) do
    case Keyword.get(opts, :module) do
      nil ->
        raise ArgumentError,
          message: """
          Please specify a :module to protect with Hammox.ProtectCase.
          Example:

            use Hammox.ProtectCase, module: ModuleToProtect

          """

      module ->
        module
    end
  end

  # Hammox returns maps of functions with keys in the `:"#{name}_{arity}"`
  # format.
  @doc false
  def function_key_to_name_and_arity(key) do
    {arity, name_parts} = key
    |> Atom.to_string()
    |> String.split("_")
    |> List.pop_at(-1)

    {Enum.join(name_parts, "_"), arity}
  end

  @doc false
  def protect(module, behaviour, funs)
  def protect(module, nil, nil), do: Hammox.protect(module)
  def protect(module, behaviour, nil), do: Hammox.protect(module, behaviour)
  def protect(module, nil, funs), do: Hammox.protect(module, funs)
  def protect(module, behaviour, funs), do: Hammox.protect(module, behaviour, funs)
end
