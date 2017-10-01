defmodule OpenApiSpex.Plug.PutApiSpec do
  @behaviour Plug

  def init(opts = [module: _mod]), do: opts

  def call(conn, module: mod) do
    spec = %OpenApiSpex.OpenApi{} =  mod.spec()
    private_data =
      conn
      |> Map.get(:private)
      |> Map.get(:open_api_spex, %{})
      |> Map.put(:spec, spec)
      |> Map.put(:operation_lookup, build_operation_lookup(spec))

    Plug.Conn.put_private(conn, :open_api_spex, private_data)
  end

  defp build_operation_lookup(spec = %OpenApiSpex.OpenApi{}) do
    spec
    |> Map.get(:paths)
    |> Stream.flat_map(fn {_name, item} -> Map.values(item) end)
    |> Stream.filter(fn x -> match?(%OpenApiSpex.Operation{}, x) end)
    |> Stream.map(fn operation -> {operation.operationId, operation} end)
    |> Enum.into(%{})
  end
end