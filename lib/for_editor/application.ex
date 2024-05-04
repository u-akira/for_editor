defmodule ForEditor.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ForEditorWeb.Telemetry,
      ForEditor.Repo,
      {DNSCluster, query: Application.get_env(:for_editor, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: ForEditor.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: ForEditor.Finch},
      # Start a worker by calling: ForEditor.Worker.start_link(arg)
      # {ForEditor.Worker, arg},
      # Start to serve requests, typically the last entry
      ForEditorWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ForEditor.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ForEditorWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
