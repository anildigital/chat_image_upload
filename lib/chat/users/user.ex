defmodule Chat.Users.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :password, :string
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string
    field :token, :string
    has_many :messages, Chat.Messages.Message

    field(:email_verification_token, Ecto.UUID)
    field(:email_verified_at, :utc_datetime)

    field(:password_reset_token, Ecto.UUID)
    field(:password_reset_expires_at, :utc_datetime)
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:token, :email, :first_name, :last_name, :password, :password_hash])
    |> validate_required([:token, :email, :first_name, :last_name, :password, :password_hash])
  end

  def create_changeset(struct, params) do
    struct
    |> cast(params, [:email, :first_name, :last_name, :password, :password_confirmation])
    |> put_change(:token, UUID.uuid4())
    |> validate_confirmation(:password)
    |> Stein.Accounts.hash_password()
    |> Stein.Accounts.start_email_verification_changeset()
    |> validate_required([:email, :first_name, :last_name, :password_hash])
    |> unique_constraint(:email, name: :users_lower_email_index)
  end

  def update_changeset(struct, params) do
    struct
    |> cast(params, [:email, :first_name, :last_name])
    |> validate_required([:email, :first_name, :last_name])
    |> unique_constraint(:email, name: :users_lower_email_index)
  end
end
