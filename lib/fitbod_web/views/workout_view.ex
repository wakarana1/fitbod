defmodule FitbodAppWeb.WorkoutView do
  use FitbodAppWeb, :view
  alias FitbodAppWeb.WorkoutView

  def render("index.json", %{workouts: workouts}) do
    %{data: render_many(workouts, WorkoutView, "workout.json")}
  end

  def render("show.json", %{workout: workout}) do
    %{data: render_one(workout, WorkoutView, "workout.json")}
  end

  def render("workout.json", %{workout: workout}) do
    %{id: workout.id, workout_duration: workout.workout_duration, workout_date: workout.workout_date}
  end
end
