defprotocol Giteax.Auth do
  @moduledoc """
  Auth for Gitea Api
  """

  @spec add(struct(), Keyword.t()) :: list()
  def add(type, middlewares)
end

defimpl Giteax.Auth, for: Giteax.Structs.AccessToken do
  @moduledoc """
  Access Token Authorization
  """

  @spec add(Giteax.Structs.AccessToken.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.AccessToken{token: token}, middlewares) do
    authorization = {:access_token, token}

    Giteax.Auth.Helper.update(middlewares, Tesla.Middleware.Query, authorization)
  end
end

defimpl Giteax.Auth, for: Giteax.Structs.AuthorizationHeaderToken do
  @moduledoc """
  Header Token Authorization
  """

  @spec add(Giteax.Structs.AuthorizationHeaderToken.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.AuthorizationHeaderToken{token: token}, middlewares) do
    authorization = {"Authorization", "token " <> token}

    Giteax.Auth.Helper.update(middlewares, Tesla.Middleware.Headers, authorization)
  end
end


defimpl Giteax.Auth, for: Giteax.Structs.BasicAuth do
  @moduledoc """
  Basic Authorization
  """

  @spec add(Giteax.Structs.BasicAuth.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.BasicAuth{username: username, password: password}, middlewares) do
    [
      {Tesla.Middleware.BasicAuth, username: username, password: password}
      | middlewares
    ]
  end
end

defimpl Giteax.Auth, for: Giteax.Structs.SudoHeader do
  @moduledoc """
  Sudo Header Authorization
  """

  @spec add(Giteax.Structs.SudoHeader.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.SudoHeader{token: token}, middlewares) do
    authorization = {"Sudo", token}

    Giteax.Auth.Helper.update(middlewares, Tesla.Middleware.Headers, authorization)
  end
end

defimpl Giteax.Auth, for: Giteax.Structs.SudoParam do
  @moduledoc """
  Sudo Param Authorization
  """

  @spec add(Giteax.Structs.SudoParam.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.SudoParam{token: token}, middlewares) do
    authorization = {"sudo", token}

    Giteax.Auth.Helper.update(middlewares, Tesla.Middleware.Query, authorization)
  end
end

defimpl Giteax.Auth, for: Giteax.Structs.Token do
  @moduledoc """
  Token Authorization
  """

  @spec add(Giteax.Structs.Token.t(), Keyword.t()) :: list()
  def add(%Giteax.Structs.Token{token: token}, middlewares) do
    authorization = {"token", token}

    Giteax.Auth.Helper.update(middlewares, Tesla.Middleware.Query, authorization)
  end
end
