
# Math Club

## Description

maths app


## Getting Started

Follow these steps to set up and run the project locally:

### 1. Install Dependencies

Install dependencies:

```bash
flutter pub get

```


### 2. Start Development Server

run application

```bash
flutter run

```


## Running Automated Tests

Note- For compatability test drivers to work the corresponding version of the browser must be installed on the computer running the tests.
Versions required:
For chrome: 135.x.xxxx.xx
For edge: 136.x.xxxx.xx
For firefox: 138.x.x(other versions of firefox may also work)

run tests

```bash
python -m http.server 8080

```
then in a new terminal

```bash
flutter test

```

## Guide to use Math Club

Introduction: When you first open Math Club, click anywhere on the welcome screen container to continue to the login page.

Login: Enter your email and password, then click "Login". If error messages are present then reply to them and click "Register" again. If you don't have an account yet, click "Don't have an account? Register" at the bottom. Successful login directs users to home/question page. 

Registration: If you dont have an account please enter:
Email (must be valid format, must be unique)
Username (4-12 characters, must be unique)
School Year (1-6, whole number)
Password (8+ characters with a number, uppercase, lowercase, and symbol)
Confirm Password (must match)
Then click "Register", if error messages are present then reply to them and click "Register" again. Successful registration directs users to home/question page. 

Awsering question: After logging in or registering, you'll see a math question with three possible answers, click the answer you think is correct.
You'll get instant feedback showing if you were right or wrong and the correct awnser. To continue to the next question, click one of the awnser boxes again or wait 3 seconds.

Score and days in a row: Your score (out of 10) shows at the side of the home/question page. Awnsering questions correctly increments score by 1 but score cannot increase past 10. Container containing score will also change colour as score increases.
When score hits 10 days in a row increments by 1. Score resets every 24 hours at 12am. If score doesn't = 10 on reset or if the user doesn't login for any given day, days in a row will reset with the score.
Highest days in a row is also recorded and updates with the value of days in a row if: days in a row > highest days in a row. Highest days in a row is never reset. 

Navigation
From home/question page press 'menu' and then one of the dropdown options (Profile, About Us or FAQ) to navigate to respective page. Alternatively press Logout to logout and be directed to login. The Profile, About Us and FAQ page all have a back button which directs users back to homepage. The FAQ page has links to other pages where relevant to questions. Pressing back after using these links will direct users back to FAQ.

Profile Page
from the profile page you can view their profile details (email, username, days in a row, highest days in a row, advanced mode). you can also toggle advanced mode by pressing the check box. This will change question difficulty to that of the year above or an additional difficulty for users in year 6 with advanced mode. you can also update profile details (username and school year). Click 'Update Profile', fill in fields, then press 'Update'. If error message is present/update is unsuccessful try again in response to the error. You can also change your password. Click 'Change Password', fill in fields, then click second 'Change Password' button. If error message is present/update is unsuccessful try again in response to the error.

About us
About us page offers a paragraph about the app as well as admin contact details.

Faq
The FAQ page contains answers to common questions. Use the search bar to find specific key words. Click on any question to view its answer.


