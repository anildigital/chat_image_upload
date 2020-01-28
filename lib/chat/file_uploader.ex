defmodule Chat.FileUploader do
  alias Chat.Documents.Upload

  def store_file(file_data, user_id) do
    file_local_path = Upload.local_path(user_id, file_data[:filename])
    :ok = File.write(file_local_path, file_data[:binary])
    Upload.asset_path(user_id, file_data[:filename])
  end
end
