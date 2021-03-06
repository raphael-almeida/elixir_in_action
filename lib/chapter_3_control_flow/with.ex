defmodule With do
  def extract_user_nasty(user) do
    case extract_login(user) do
      {:error, reason} ->
        {:error, reason}

      {:ok, login} ->
        case extract_email(user) do
          {:error, reason} ->
            {:error, reason}

          {:ok, email} ->
            case(extract_password(user)) do
              {:error, reason} ->
                {:error, reason}

              {:ok, password} ->
                %{login: login, email: email, password: password}
            end
        end
    end
  end

  def extract_user(user) do
    with {:ok, login} <- extract_login(user),
         {:ok, email} <- extract_email(user),
         {:ok, password} <- extract_password(user) do
      %{login: login, email: email, password: password}
    end
  end

  def extract_user_with_map(user) do
    case Enum.filter(
           ["login", "email", "password"],
           &(not Map.has_key?(user, &1))
         ) do
      [] ->
        %{
          login: extract_login(user),
          email: extract_email(user),
          password: extract_password(user)
        }

      missing_fields ->
        IO.puts("the following fields are missing: #{Enum.join(missing_fields, ",")}")
    end
  end

  defp extract_login(%{"login" => login}), do: {:ok, login}
  defp extract_login(_), do: {:error, "missing login"}

  defp extract_email(%{"email" => email}), do: {:ok, email}
  defp extract_email(_), do: {:error, "missing email"}

  defp extract_password(%{"password" => password}), do: {:ok, password}
  defp extract_password(_), do: {:error, "missing password"}
end
