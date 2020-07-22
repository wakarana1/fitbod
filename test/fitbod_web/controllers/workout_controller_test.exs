defmodule FitbodAppWeb.WorkoutControllerTest do
  use FitbodAppWeb.ConnCase

  alias FitbodApp.{Activities, Auth}
  alias Plug.Test

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
    {:ok, conn: put_req_header(conn, "accept", "application/json"), current_user: current_user}
  end

  describe "index" do
    test "lists all workouts for user", %{conn: conn, current_user: current_user} do
      workout = create_workout!(current_user)
      conn = get(conn, Routes.user_workout_path(conn, :index, current_user.id))

      assert [
               %{
                 "id" => workout.id,
                 "workout_date" => "2020-04-17",
                 "workout_duration" => workout.workout_duration
               }
             ] == json_response(conn, 200)["data"]
    end

    test "doesn't list workouts from other users", %{conn: conn, current_user: current_user} do
      workout = create_workout!(current_user)
      user2 = fixture(:user, email: "second@user.com")
      _workout2 = create_workout!(user2)
      conn1 = get(conn, Routes.user_workout_path(conn, :index, current_user))

      assert [
               %{
                 "id" => workout.id,
                 "workout_date" => "2020-04-17",
                 "workout_duration" => workout.workout_duration
               }
             ] == json_response(conn1, 200)["data"]
    end
  end

  # describe "show workout" do
  #   test "users can only view their own workouts", %{conn: conn, current_user: current_user} do
  #     workout = create_workout!(current_user.id)
  #     conn = get(conn, Routes.user_workout_path(conn, :show, current_user.id, workout.id))
  #     assert %{"id" => id} = json_response(conn, 200)["data"]
  #   end
  # end

  describe "create workout" do
    test "renders workout when data is valid", %{conn: conn, current_user: current_user} do
      attrs = %{
        "data" => %{
          "attributes" => %{
            "workout_date" => "2020-04-17",
            "workout_duration" => 42
          }
        }
      }

      conn = post(conn, Routes.user_workout_path(conn, :create, current_user), attrs)

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_workout_path(conn, :show, current_user, id))

      assert %{
               "id" => id,
               "workout_date" => "2020-04-17",
               "workout_duration" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, current_user: current_user} do
      attrs = %{
        "data" => %{
          "attributes" => %{
            "workout_date" => nil,
            "workout_duration" => nil,
            "user_id" => nil
          }
        }
      }

      conn = post(conn, Routes.user_workout_path(conn, :create, current_user.id), attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workout" do
    test "updates workout when data is valid", %{conn: conn, current_user: current_user} do
      workout = create_workout!(current_user)
      workout_id = workout.id

      attrs = %{
        "data" => %{
          "attributes" => %{
            "workout_date" => "2020-05-17",
            "workout_duration" => 45,
            "user_id" => current_user.id
          }
        }
      }

      conn = put(conn, Routes.user_workout_path(conn, :update, current_user.id, workout_id, attrs))

      assert workout_id == json_response(conn, 200)["data"]["id"]

      conn = get(conn, Routes.user_workout_path(conn, :show, current_user.id, workout_id))

      assert %{
               "id" => ^workout_id,
               "workout_date" => "2020-05-17",
               "workout_duration" => 45
             } = json_response(conn, 200)["data"]
    end

    test "only user who created workout can update", %{conn: conn, current_user: current_user} do
      workout = create_workout!(current_user)
      different_user = fixture(:user, email: "user2@email.com")

      attrs = %{
        "data" => %{
          "attributes" => %{
            "workout_date" => "2020-05-17",
            "workout_duration" => 45,
            "user_id" => current_user.id
          }
        }
      }

      conn = put(conn, Routes.user_workout_path(conn, :update, different_user.id, workout.id), attrs)
      assert json_response(conn, 401) == "Unauthorized"
    end
  end

  describe "delete workout" do
    test "deletes chosen workout", %{conn: conn, current_user: current_user} do
      workout = create_workout!(current_user)
      conn = delete(conn, Routes.user_workout_path(conn, :delete, current_user, workout.id))
      assert response(conn, 204)
    end
  end

  defp setup_current_user(conn) do
    current_user = fixture(:user)
    {:ok, conn: Test.init_test_session(conn, current_user_id: current_user.id), current_user: current_user}
  end
end
