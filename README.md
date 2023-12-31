# News App

A mobile application for reading and browsing Malaysian news articles in real-time.

## Table of Contents

- [Project Members](#project-members)
- [Description](#description)
- [Features](#features)
- [Compilation and Running](#compilation-and-running)
- [Usage](#usage)

## Project Members

GROUP 2

1.  HAZIM IMRAN BIN ABD AZIZ (2110133)
2.  NUR FARAH ADILAH BINTI RAHIM (2016490)
3.  WAN MOHAMMAD LUQMANUL HAKIM BIN MAZLELEE (2111907)
4.  NUR ZULFAH INSYIRAH BINTI FADZLEEY (2015384)

## Description

The News App is a mobile application designed to provide users with a seamless experience for reading and browsing Malaysian news articles from a wide range of reliable sources in real-time using the free API from https://newsapi.org/s/malaysia-news-api. This app offers a user-friendly interface that prioritizes accessibility and convenience, ensuring that users can stay well-informed about current events with ease. With the integration of Firebase for authentication and data storage, the News App offers a secure and personalized platform for users to discover and engage with news content.

The project utilizes the following:

- The use of widgets.
- The use of HTTP library for fetching data.
- The use of Firebase for authentication and performing Create, Read, Update, and Delete (CRUD) operations.


## Features

1. Login Page
   - Allows users to sign in with their credentials.
   - If the user has not created an account, they can navigate to the sign-up page.
   - Handles authentication using Firebase.
   - Provides error messages for incomplete or incorrect login details.
   - Offers a password reset option by sending an email to the user.

   ![signin](https://github.com/hazimmm/news_app/assets/97010443/17e4cd7b-787c-4271-9235-bf0e15fb3e52)

2. Sign Up Page
   - Enables users to create a new account.
   - Requests profile picture upload, username, email, and password.
   - Validates and ensures completion of all required fields.
   - Stores user details, including the profile picture, in Firebase.
   - Redirects to the home page upon successful sign-up.

   ![signup](https://github.com/hazimmm/news_app/assets/97010443/cd784e4f-95ba-48de-80f7-1af365a7d598)

3. Home Page
   - Users can scroll through a feed of news articles and view headlines.
   - Categorizes news articles by provider/company.
   - Users can search for specific news articles using keywords.
   - Includes a profile icon that allows users to access their user profile.

   ![homescreen](https://github.com/hazimmm/news_app/assets/97010443/a87718ba-b900-4214-9cdc-945c07c94899)

4. News Page
   - Users can read full articles.
   - Users can access this page by clicking on a news article from the home page.

   ![news](https://github.com/hazimmm/news_app/assets/97010443/6aa30ba0-e3de-424a-9868-5a84661e11d7)

5. User Profile Page
   - Displays the user's profile picture.
   - Allows users to update their profile picture.
   - Retrieves and displays the username and email from Firebase.
   - Provides functionality to update the username, email, and password.
   - Updates changes to Firebase in real-time and reflects them on the screen.
   - Includes an option to delete the user account with confirmation.
   - Allows users to log out of the app with confirmation.

   ![profile](https://github.com/hazimmm/news_app/assets/97010443/739da986-c3c5-4476-a302-bee0d6d82b4d)

## Compilation and Running

To run the News App locally, follow these steps:

1. Make sure you have Flutter installed on your machine.

2. Clone this repository to your local machine using the following command: git clone https://github.com/hazimmm/news_app.git.

3. Navigate to the project directory: cd news-app.

4. Install the dependencies by running the following command: flutter pub get.

5. Check and make sure the `google-services.json` file is in the project's folder.

6. Open Visual Studio Code. Open the project's folder. Run the app from main.dart.

## Usage

1. Launch the News App on your device or emulator.

2. Register a new account or log in with your existing credentials.

3. Browse through different news provider and scroll through the news feed.

4. Tap on a news article to view the full content.

5. Use the search functionality to find articles based on keywords.

6. Update details on the user profile whenever you want.

7. Stay informed and enjoy reading news articles from various sources!
