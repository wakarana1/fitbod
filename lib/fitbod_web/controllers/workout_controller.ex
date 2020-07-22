defmodule FitbodAppWeb.WorkoutController do
  use FitbodAppWeb, :controller

  alias FitbodApp.Activities
  alias FitbodApp.Activities.Workout
  alias FitbodApp.Auth

  action_fallback FitbodAppWeb.FallbackController

  def index(conn, %{"user_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workouts} = Activities.list_workouts_for_user(user) do
      render(conn, "index.json", workouts: workouts)
    end
  end

  def create(conn, %{"user_id" => user_id, "data" => %{"attributes" => attrs}}) do
    attrs = Map.put(attrs, "user_id", user_id)

    with user = Auth.get_user!(user_id),
         {:ok, %Workout{} = workout} <- Activities.create_workout(user, attrs) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.user_workout_path(conn, :show, user.id, workout.id))
      |> render("show.json", workout: workout)
    end
  end

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} <- Activities.get_workout(user, id) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.user_workout_path(conn, :show, user_id, workout.id))
      |> render("show.json", workout: workout)
    end
  end

  def update(conn, %{"id" => id, "user_id" => user_id, "data" => %{"attributes" => attrs}}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} <- Activities.get_workout(user, id),
         {:ok, %Workout{} = updated_workout} <- Activities.update_workout(user, workout, attrs) do
      conn
      |> put_status(:ok)
      |> put_resp_header("location", Routes.user_workout_path(conn, :show, user_id, updated_workout.id))
      |> render("show.json", workout: updated_workout)
    else
      {:error, message} ->
        {:error, message}
    end
  end

  def delete(conn, %{"id" => id, "user_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} <- Activities.get_workout(user, id),
         {:ok, %Workout{}} <- Activities.delete_workout(user, workout) do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(:no_content, "")
    end
  end
end
