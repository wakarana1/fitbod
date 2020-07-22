defmodule FitbodApp.Activities.Workout do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "workouts" do
    belongs_to :user, FitbodApp.Auth.User
    field :workout_date, :date
    field :workout_duration, :integer

    timestamps()
  end

  @doc false
  def changeset(workout, attrs) do
    workout
    |> cast(attrs, [:workout_duration, :workout_date, :user_id])
    |> validate_required([:workout_duration, :workout_date, :user_id])
    |> foreign_key_constraint(:user_id, name: :workouts_user_id_fkey)
  end
end
