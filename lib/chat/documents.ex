defmodule Chat.Documents do
  import Ecto.Query, warn: false

  alias Chat.Repo
  alias Chat.Documents.Upload
  alias Chat.FileUploader

  def list_uploads do
    Repo.all(Upload)
  end

  def create_upload_from_plug_upload(user, params) do
    file_path =
      params
      |> keys_to_atoms()
      |> decode_binary()
      |> FileUploader.store_file(user.id)

    file_path
  end

  defp keys_to_atoms(params) do
    Map.new(params, fn {k, v} -> {String.to_atom(k), v} end)
  end

  defp decode_binary(params) do
    Map.put(params, :binary, Base.decode64!(params.binary))
  end
end
