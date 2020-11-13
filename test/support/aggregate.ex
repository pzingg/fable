defmodule Fable.Test.Aggregate do
  use Ecto.Schema
  @primary_key {:id, :binary_id, autogenerate: true}

  defmodule Created do
    use Fable.Event

    embedded_schema do
      # Required field that holds the name of this module.
      event_type()
    end
  end

  schema "aggregates" do
    field :last_event_id, :integer, read_after_writes: true
    timestamps()
  end
end
