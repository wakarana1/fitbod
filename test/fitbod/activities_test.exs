defmodule FitbodApp.ActivitiesTest do
  use FitbodApp.DataCase

  alias FitbodApp.{Activities, Auth}

  describe "workouts" do
    alias FitbodApp.Activities.Workout

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(%{email: "email@email.com", password: "password"})
        |> Auth.create_user()

      user
    end

    def workout_fixture(user) do
      {:ok, workout} =
        Activities.create_workout(user, %{workout_date: "2010-04-17", workout_duration: 42, user_id: user.id})

      workout
    end

    test "list_workouts/0 returns all workouts" do
      user = user_fixture()
      workout = workout_fixture(user)
      assert Activities.list_workouts() == [workout]
    end

    test "get_workout/2 returns the workout with given id" do
      user = user_fixture()
      workout = workout_fixture(user)
      assert Activities.get_workout(user, workout.id) == {:ok, workout}
    end

    test "list_workouts_for_user/1 returns tuple with {:ok, workouts}" do
      user = user_fixture()
      workout = workout_fixture(user)
      assert Activities.list_workouts_for_user(user) == {:ok, [workout]}
    end

    test "create_workout/2 with valid data creates a workout" do
      user = user_fixture()
      params = %{workout_date: "2010-04-17", workout_duration: 42, user_id: user.id}
      assert {:ok, %Workout{} = workout} = Activities.create_workout(user, params)
      assert workout.workout_date == ~D[2010-04-17]
      assert workout.workout_duration == 42
    end

    test "create_workout/2 with invalid data returns error changeset" do
      user = user_fixture()
      params = %{workout_date: nil, workout_duration: nil, user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Activities.create_workout(user, params)
    end

    test "update_workout/2 with valid data updates the workout" do
      user = user_fixture()
      workout = workout_fixture(user)
      params = %{workout_date: "2011-05-18", workout_duration: 43}
      assert {:ok, %Workout{} = workout} = Activities.update_workout(user, workout, params)
      assert workout.workout_date == ~D[2011-05-18]
      assert workout.workout_duration == 43
    end

    test "update_workout/2 with invalid data returns error changeset" do
      user = user_fixture()
      workout = workout_fixture(user)
      params = %{workout_date: nil, workout_duration: nil, user_id: nil}
      assert {:error, %Ecto.Changeset{}} = Activities.update_workout(user, workout, params)
      assert {:ok, workout} == Activities.get_workout(user, workout.id)
    end

    test "delete_workout/2 deletes the workout" do
      user = user_fixture()
      workout = workout_fixture(user)
      assert {:ok, %Workout{}} = Activities.delete_workout(user, workout)
      assert {:error, :not_found} == Activities.get_workout(user, workout.id)
    end

    test "change_workout/1 returns a workout changeset" do
      user = user_fixture()
      workout = workout_fixture(user)
      assert %Ecto.Changeset{} = Activities.change_workout(workout)
    end
  end
end
