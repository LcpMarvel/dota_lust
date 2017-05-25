defmodule DotaLust.WechatAppletUserSession do
  use DotaLust.Web, :model
  use Timex

  alias DotaLust.Repo

  schema "wechat_applet_user_sessions" do
    field :wechat_open_id, :string
    field :session_key, :string
    field :token, :string
    field :expired_at, :naive_datetime

    timestamps()
  end

  def changeset(struct, params \\ %{}) do
    struct
      |> cast(params, [:wechat_open_id, :session_key, :token, :expired_at])
      |> validate_required([:wechat_open_id, :session_key, :token, :expired_at])
  end

  @spec valid(Ecto.Queryable.t) :: Ecto.Queryable.t
  def valid(query \\ __MODULE__) do
    from c in query,
      where: c.expired_at > ^DateTime.utc_now,
      order_by: [desc: c.id]
  end

  @spec insert_by_params(map) :: Ecto.Schema.t | no_return
  def insert_by_params(%{"openid" => id, "session_key" => key, "expires_in" => seconds}) do
    params = %{
      wechat_open_id: id,
      session_key: key,
      token: generate_token(),
      expired_at: Timex.shift(Timex.now, seconds: seconds)
    }

    %__MODULE__{}
      |> changeset(params)
      |> Repo.insert!
  end

  @spec generate_token() :: binary
  defp generate_token do
    token = [
      DateTime.to_string(Timex.now), Enum.random(100_000..200_000)
    ] |> Enum.join

    :md5
      |> :crypto.hash(token)
      |> Base.encode64
  end
end
