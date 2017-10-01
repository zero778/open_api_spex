defmodule OpenApiSpex.Parameter do
  alias OpenApiSpex.{
    Schema, Reference, Example, MediaType, Parameter
  }
  defstruct [
    :name,
    :in,
    :description,
    :required,
    :deprecated,
    :allowEmptyValue,
    :style,
    :explode,
    :allowReserved,
    :schema,
    :example,
    :examples,
    :content,
  ]
  @type location :: :query | :header | :path | :cookie
  @type style :: :matrix | :label | :form | :simple | :spaceDelimited | :pipeDelimited | :deep
  @type t :: %__MODULE__{
    name: atom,
    in: location,
    description: String.t,
    required: boolean,
    deprecated: boolean,
    allowEmptyValue: boolean,
    style: style,
    explode: boolean,
    allowReserved: boolean,
    schema: Schema.t | Reference.t | atom,
    example: any,
    examples: %{String.t => Example.t | Reference.t},
    content: %{String.t => MediaType.t}
  }

  @doc """
  Sets the schema for a parameter from a simple type, reference or Schema
  """
  @spec put_schema(t, Reference.t | Schema.t | atom) :: t
  def put_schema(parameter = %Parameter{}, type = %Reference{}) do
    %{parameter | schema: type}
  end
  def put_schema(parameter = %Parameter{}, type = %Schema{}) do
    %{parameter | schema: type}
  end
  def put_schema(parameter = %Parameter{}, type) when type in [:boolean, :integer, :number, :string, :array, :object] do
    %{parameter | schema: %Schema{type: type}}
  end
  def put_schema(parameter = %Parameter{}, type) when is_atom(type) do
    %{parameter | schema: type}
  end

  def schema(%Parameter{schema: schema = %{}}) do
    schema
  end
  def schema(%Parameter{content: content = %{}}) do
    {_type, %MediaType{schema: schema}} = Enum.at(content, 0)
    schema
  end
end