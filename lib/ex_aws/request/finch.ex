defmodule ExAws.Request.Finch do
  @moduledoc """
  Configuration for `Finch`

  Options can be set for `Finch` with the following config:

      config :ex_aws, :finch_opts,
        receive_timeout: 30_000

  The default config handles setting the above.
  """
  alias Finch.Response

  @behaviour ExAws.Request.HttpClient

  @default_opts [receive_timeout: 30_000]

  def request(method, url, body \\ "", headers \\ [], http_opts \\ []) do
    http_client_module = Application.fetch_env!(:ex_aws, :finch_name)
    opts = Application.get_env(:ex_aws, :finch_opts, @default_opts)
    opts = http_opts ++ opts

    method
    |> Finch.build(url, headers, body)
    |> Finch.request(http_client_module, opts)
    |> case do
      {:ok, %Response{status: status, headers: headers, body: body}} ->
        {:ok, %{status_code: status, headers: headers, body: body}}

      {:error, reason} ->
        {:error, %{reason: reason}}
    end
  end
end
