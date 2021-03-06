defmodule Ebaze.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias Ebaze.{Auctions.Auction}

  schema "users" do
    field :password, :string
    field :username, :string
    has_many :auctions, Auction, foreign_key: :created_by_id
    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :password])
    |> validate_required([:username, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:username, message: "username is not unique. try again")
    |> put_password_hash()
  end

  defp put_password_hash(
         %Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset
       ) do
    change(changeset, password: Bcrypt.hash_pwd_salt(password))
  end

  defp put_password_hash(changeset), do: changeset
end
