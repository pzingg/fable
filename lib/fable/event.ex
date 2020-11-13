defmodule Fable.Event do
  import Ecto.Query

  @type t :: Ecto.Schema.t()
  @type name :: module()

  defmacro __using__(_) do
    quote do
      use Ecto.Schema
      import Fable.Event, only: [event_type: 0]

      @primary_key false
    end
  end

  @doc """
  Macro to create required __type__ field  for the polymorphic data type
  with the default name of module that "uses" Fable.Event.
  """
  defmacro event_type do
    quote do
      field :__type__, :string, default: to_string(__MODULE__)
    end
  end

  use Ecto.Schema

  schema "events" do
    field(:prev_event_id, :integer)
    field(:aggregate_id, Ecto.UUID, null: false)
    field(:aggregate_table, :string, null: false)
    field(:version, :integer, null: false)
    field(:meta, :map, default: %{})
    field(:data, PolymorphicEmbed, types: :by_module, default: %{})
    field(:inserted_at, :utc_datetime, read_after_writes: true)
  end

  def active(queryable) do
    queryable |> where(active: true)
  end

  def for_aggregate(schema \\ __MODULE__, %agg{id: id}) do
    table = agg.__schema__(:source)

    schema
    |> where(aggregate_table: ^table, aggregate_id: ^id)
  end
end
