defmodule DotaLust.Hero do
  use DotaLust.Web, :model

  schema "heroes" do
    field :hero_id, :integer
    field :name, :string
    field :hero_name, :string
    field :localized_name, :string
    field :avatars, :map
  end

  def changeset(struct, params \\ %{}) do
    attributes = [:hero_id, :name, :hero_name, :localized_name, :avatars]

    struct
      |> cast(params, attributes)
      |> validate_required(attributes)
  end
end
