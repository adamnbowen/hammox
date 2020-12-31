defmodule Hammox.ProtectCaseTest do
  use ExUnit.Case, async: true

  defmodule TestBehaviour do
    @callback foo() :: :bar
  end

  defmodule ModuleToProtect do
    @behaviour TestBehaviour

    @callback hello() :: :world
    # wrong implementation to show protection
    def hello, do: :error

    # wrong implementation to show protection
    def foo, do: :error
  end

  defmodule TestModule1 do
    use Hammox.ProtectCase, module: %{}
  end

  test "using ProtectCase without module throws an exception" do
    module_string = """
    defmodule ProtectCaseWithoutModule do
      use Hammox.ProtectCase
    end
    """

    assert_raise ArgumentError, ~r/Please specify a :module to protect/, fn ->
      Code.compile_string(module_string)
    end
  end

  test "using ProtectCase creates protected versions of functions from given behaviour" do
    assert_raise Hammox.TypeMatchError, fn -> TestModule1.hello() end
  end
end
