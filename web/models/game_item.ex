defmodule DotaLust.GameItem do
  use DotaLust.Web, :model

  schema "game_items" do
    field :game_item_id, :integer
    field :name, :string
    field :cost, :integer
    field :secret_shop, :integer
    field :side_shop, :integer
    field :localized_name, :string
    field :image, :string
  end

  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:game_item_id, :name, :cost, :secret_shop, :side_shop, :localized_name, :image])
    |> validate_required([:game_item_id, :name, :cost, :secret_shop, :side_shop, :localized_name, :image])
  end
end
