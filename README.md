# FitbodApp

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `npm install` inside the `assets` directory
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

## CURL commands

replace the email and password.
### Sign Up
curl -H "Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"email":"fitbod@fitbod.com","password":"password"}}}' \
http://localhost:4000/api/users/sign_up \
-c cookies.txt -b cookies.txt -i

### Sign In
curl -H "Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"email":"fitbod@fitbod.com","password":"password"}}}' \
http://localhost:4000/api/users/sign_in \
-c cookies.txt -b cookies.txt -i


Once you have the User ID from data returned, insert below

### Get A List Of Workouts
curl -H "Content-Type: application/json" -X GET \
http://localhost:4000/api/users/USER-ID-HERE/workouts \
-c cookies.txt -b cookies.txt -i

### Create Workout
curl -H"Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"workout_duration": 30, "workout_date": "2020-04-17"}}}' \
http://localhost:4000/api/users/USER-ID-HERE/workouts \
-c cookies.txt -b cookies.txt -i

Once you have the Workout ID from data returned, insert below

### Get Workout
curl -H"Content-Type: application/json" -X GET \
http://localhost:4000/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i

### Update Workout
curl -H"Content-Type: application/json" -X PUT \
-d '{"data": {"attributes": {"workout_duration": 45, "workout_date": "2020-04-17"}}}' \
http://localhost:4000/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i

### Delete Workout
curl -H"Content-Type: application/json" -X DELETE \
http://localhost:4000/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i
