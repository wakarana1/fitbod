# FitbodApp

To view the "admin" page, the website is https://peaceful-badlands-63941.herokuapp.com/

## CURL commands for API

replace the email and password.
### Sign Up
curl -H "Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"email":"fitbod@fitbod.com","password":"password"}}}' \
https://peaceful-badlands-63941.herokuapp.com/api/users/sign_up \
-c cookies.txt -b cookies.txt -i

### Sign In
curl -H "Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"email":"fitbod@fitbod.com","password":"password"}}}' \
https://peaceful-badlands-63941.herokuapp.com/api/users/sign_in \
-c cookies.txt -b cookies.txt -i


Once you have the User ID from data returned, insert below

### Get A List Of Workouts
curl -H "Content-Type: application/json" -X GET \
https://peaceful-badlands-63941.herokuapp.com/api/users/USER-ID-HERE/workouts \
-c cookies.txt -b cookies.txt -i

### Create Workout
curl -H"Content-Type: application/json" -X POST \
-d '{"data": {"attributes": {"workout_duration": 30, "workout_date": "2020-04-17"}}}' \
https://peaceful-badlands-63941.herokuapp.com/api/users/USER-ID-HERE/workouts \
-c cookies.txt -b cookies.txt -i

Once you have the Workout ID from data returned, insert below

### Get Workout
curl -H"Content-Type: application/json" -X GET \
https://peaceful-badlands-63941.herokuapp.com/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i

### Update Workout
curl -H"Content-Type: application/json" -X PUT \
-d '{"data": {"attributes": {"workout_duration": 45, "workout_date": "2020-04-17"}}}' \
https://peaceful-badlands-63941.herokuapp.com/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i

### Delete Workout
curl -H"Content-Type: application/json" -X DELETE \
https://peaceful-badlands-63941.herokuapp.com/api/users/USER-ID-HERE/workouts/WORKOUT-ID-HERE \
-c cookies.txt -b cookies.txt -i
