defmodule FitbodApp.Activities.Policy do
  alias FitbodApp.Activities.Workout
  alias FitbodApp.Auth.User

  @behaviour Bodyguard.Policy

  def authorize(:list_workouts, %User{}, _), do: true
  def authorize(:read_workout, %User{id: user_id}, %Workout{user_id: user_id}), do: true
  def authorize(:create_workout, %User{}, _), do: true
  def authorize(:update_workout, %User{id: user_id}, %Workout{user_id: user_id}), do: true
  def authorize(:delete_workout, %User{id: user_id}, %Workout{user_id: user_id}), do: true

  # catch-all to deny anything not matched
  def authorize(_, _, _), do: false
end
