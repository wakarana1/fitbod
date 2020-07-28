defmodule FitbodAppWeb.WorkoutWebControllerTest do
  use FitbodAppWeb.ConnCase

  alias FitbodApp.{Activities, Auth}
  alias Plug.Test

  @update_attrs %{workout_date: "2011-05-18T15:01:01.000000Z", workout_duration: 43}
  @invalid_attrs %{workout_date: nil, workout_duration: nil}

  def create_workout!(user) do
    {:ok, workout} =
      Activities.create_workout(user, %{workout_date: "2020-04-17", workout_duration: 42, user_id: user.id})

    workout
  end

  def fixture(:user, opts \\ []) do
    email = Keyword.get(opts, :email, "email@email.com")
    {:ok, user} = Auth.create_user(%{email: email, password: "password"})
    user
  end

  setup %{conn: conn} do
    {:ok, conn: conn, current_user: current_user} = setup_current_user(conn)
    {:ok, conn: conn, current_user: current_user}
  end

  describe "index" do
    test "lists all workouts", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_web_workout_web_path(conn, :index, current_user.id))
      assert html_response(conn, 200) =~ "Listing Workouts"
    end
  end

  describe "new workout" do
    test "renders form", %{conn: conn, current_user: current_user} do
      conn = get(conn, Routes.user_web_workout_web_path(conn, :new, current_user.id))
      assert html_response(conn, 200) =~ "New Workout"
    end
  end

  describe "create workout" do
    test "redirects to show when data is valid", %{conn: conn, current_user: current_user} do
      conn =
        post(conn, Routes.user_web_workout_web_path(conn, :create, current_user.id),
          workout: %{workout_date: "2010-04-17T14:00:00.000000Z", workout_duration: 42}
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.user_web_workout_web_path(conn, :show, current_user.id, id)

      conn = get(conn, Routes.user_web_workout_web_path(conn, :show, current_user.id, id))
      assert html_response(conn, 200) =~ "Show Workout"
    end

    test "renders errors when data is invalid", %{conn: conn, current_user: current_user} do
      conn = post(conn, Routes.user_web_workout_web_path(conn, :create, current_user.id), workout: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Workout"
    end
  end

  describe "edit workout" do
    setup [:create_workout]

    test "renders form for editing chosen workout", %{conn: conn, current_user: current_user, workout: workout} do
      conn = get(conn, Routes.user_web_workout_web_path(conn, :edit, current_user.id, workout))
      assert html_response(conn, 200) =~ "Edit Workout"
    end
  end

  describe "update workout" do
    setup [:create_workout]

    test "redirects when data is valid", %{conn: conn, current_user: current_user, workout: workout} do
      conn =
        put(conn, Routes.user_web_workout_web_path(conn, :update, current_user.id, workout), workout: @update_attrs)

      assert redirected_to(conn) == Routes.user_web_workout_web_path(conn, :show, current_user.id, workout)

      conn = get(conn, Routes.user_web_workout_web_path(conn, :show, current_user.id, workout))
      assert html_response(conn, 200)
    end

    # test "renders errors when data is invalid", %{conn: conn, current_user: current_user, workout: workout} do
    #   conn =
    #     put(conn, Routes.user_web_workout_web_path(conn, :update, current_user.id, workout), workout: @invalid_attrs)

    #   assert html_response(conn, 200) =~ "Edit Workout"
    # end
  end

  describe "delete workout" do
    setup [:create_workout]

    test "deletes chosen workout", %{conn: conn, current_user: current_user, workout: workout} do
      conn = delete(conn, Routes.user_web_workout_web_path(conn, :delete, current_user.id, workout))
      assert redirected_to(conn) == Routes.user_web_workout_web_path(conn, :index, current_user.id)
    end
  end

  defp create_workout(context) do
    workout = create_workout!(context.current_user)
    %{workout: workout}
  end

  defp setup_current_user(conn) do
    current_user = fixture(:user)
    {:ok, conn: Test.init_test_session(conn, current_user_id: current_user.id), current_user: current_user}
  end
end
