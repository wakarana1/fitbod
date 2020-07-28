defmodule FitbodAppWeb.WorkoutWebController do
  use FitbodAppWeb, :controller

  alias FitbodApp.Activities
  alias FitbodApp.Activities.Workout
  alias FitbodApp.Auth

  def index(conn, %{"user_web_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workouts} = Activities.list_workouts_for_user(user) do
      render(conn, "index.html", user: user, workouts: workouts)
    end
  end

  def new(conn, %{"user_web_id" => user_id}) do
    changeset = Activities.change_workout(%Workout{})
    render(conn, "new.html", user_id: user_id, changeset: changeset)
  end

  def create(conn, %{"user_web_id" => user_id, "workout" => attrs}) do
    attrs = Map.put(attrs, "user_id", user_id)

    with user = Auth.get_user!(user_id),
         {:ok, %Workout{} = workout} <- Activities.create_workout(user, attrs) do
      conn
      |> put_flash(:info, "Workout created successfully.")
      |> redirect(to: Routes.user_web_workout_web_path(conn, :show, user_id, workout))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", user_id: user_id, changeset: changeset)
    end
  end

  def show(conn, %{"id" => id, "user_web_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} <- Activities.get_workout(user, id) do
      render(conn, "show.html", user: user, workout: workout)
    end
  end

  def edit(conn, %{"id" => id, "user_web_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} = Activities.get_workout(user, id),
         changeset = Activities.change_workout(workout) do
      render(conn, "edit.html", user: user, workout: workout, changeset: changeset)
    end
  end

  def update(conn, %{"user_web_id" => user_id, "id" => id, "workout" => workout_params}) do
    # IO.inspect(workout_params, label: "update")
    user = Auth.get_user!(user_id)
    {:ok, workout} = Activities.get_workout(user, id)

    with {:ok, %Workout{} = updated_workout} <- Activities.update_workout(user, workout, workout_params) do
      conn
      |> put_flash(:info, "Workout updated successfully.")
      |> redirect(to: Routes.user_web_workout_web_path(conn, :show, user_id, updated_workout))
    else
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", user_id, workout: workout, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "user_web_id" => user_id}) do
    with user = Auth.get_user!(user_id),
         {:ok, workout} <- Activities.get_workout(user, id),
         {:ok, _workout} <- Activities.delete_workout(user, workout) do
      conn
      |> put_flash(:info, "Workout deleted successfully.")
      |> redirect(to: Routes.user_web_workout_web_path(conn, :index, user_id))
    end
  end
end
