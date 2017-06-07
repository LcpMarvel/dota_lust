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
    struct
    |> cast(params, [:hero_id, :name, :hero_name, :localized_name, :avatars])
    |> validate_required([:hero_id, :name, :hero_name, :localized_name, :avatars])
  end
end
