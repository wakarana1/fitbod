defmodule FitbodApp.Activities do
  @moduledoc """
  The Activities context.
  """

  import Ecto.Query, warn: false
  alias FitbodApp.Activities
  alias FitbodApp.Activities.Workout
  alias FitbodApp.Repo

  @behaviour Bodyguard.Policy

  defdelegate authorize(action, user, params), to: FitbodApp.Activities.Policy

  @doc """
  Returns the list of workouts.

  ## Examples

      iex> list_workouts()
      [%Workout{}, ...]

  """
  def list_workouts do
    Repo.all(Workout)
  end

  @doc """
  Gets a single workout.

  ## Examples

      iex> get_workout(1, 123)
      {:ok, %Workout{}}

      iex> get_workout(2, 123)
      {:error, Ecto.NoResultsError}

  """
  def get_workout(user, id) do
    with {:ok, workout} <- Repo.fetch(Workout, id),
         :ok <- Bodyguard.permit(Activities, :read_workout, user, workout) do
      {:ok, workout}
    else
      {:error, :not_found} ->
        {:error, :not_found}

      {:error, :unauthorized} ->
        {:error, :unauthorized}
    end
  end

  @doc """
  Returns a list of workouts by user.

  ## Examples

      iex> get_workouts_by_user()
      [%Workout{}, ...]

  """
  def list_workouts_for_user(user) do
    user_id = user.id

    with workouts <- Workout |> where([w], w.user_id == ^user_id) |> Repo.all(),
         :ok <- Bodyguard.permit(Activities, :list_workouts, user, workouts) do
      {:ok, workouts}
    end
  end

  @doc """
  Creates a workout.

  ## Examples

      iex> create_workout(%User{}, %{field: value})
      {:ok, %Workout{}}

      iex> create_workout(%User{}, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_workout(user, attrs \\ %{}) do
    with :ok <- Bodyguard.permit(Activities, :create_workout, user, attrs) do
      %Workout{}
      |> Workout.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc """
  Updates a workout.

  ## Examples

      iex> update_workout(workout, %{field: new_value})
      {:ok, %Workout{}}

      iex> update_workout(workout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_workout(user, %Workout{} = workout, attrs) do
    with :ok <- Bodyguard.permit(Activities, :update_workout, user, workout) do
      workout
      |> Workout.changeset(attrs)
      |> Repo.update()
    end
  end

  @doc """
  Deletes a workout.

  ## Examples

      iex> delete_workout(user, workout)
      {:ok, %Workout{}}

      iex> delete_workout(user, workout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_workout(user, %Workout{} = workout) do
    with :ok <- Bodyguard.permit(Activities, :delete_workout, user, workout) do
      Repo.delete(workout)
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking workout changes.

  ## Examples

      iex> change_workout(workout)
      %Ecto.Changeset{data: %Workout{}}

  """
  def change_workout(%Workout{} = workout, attrs \\ %{}) do
    Workout.changeset(workout, attrs)
  end
end
