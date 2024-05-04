defmodule ForEditor.Repo do
  use Ecto.Repo,
    otp_app: :for_editor,
    adapter: Ecto.Adapters.Postgres
end
