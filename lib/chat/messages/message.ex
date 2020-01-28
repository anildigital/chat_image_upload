defmodule Chat.Messages.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :message, :string
    field :name, :string
    field :message_type, :string
    belongs_to :room, Chat.Rooms.Room
    belongs_to :user, Chat.Users.User

    timestamps()
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:name, :message, :message_type, :room_id, :user_id])
    |> validate_required([:name, :message, :room_id, :user_id])
  end
end
