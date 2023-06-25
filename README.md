# News App

A mobile application for reading and browsing Malaysia news articles in real-time.

## Table of Contents

- [Project Members](#projectmembers)
- [Description](#description)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)

## Project Members

1.  HAZIM IMRAN BIN ABD AZIZ (2110133)
2.  NUR FARAH ADILAH BINTI RAHIM (2016490)
3.  WAN MOHAMMAD LUQMANUL HAKIM BIN MAZLELEE (2111907)
4.  NUR ZULFAH INSYIRAH BINTI FADZLEEY (2015384)

## Description

The News App is a mobile application designed to provide users with a seamless experience for reading and browsing Malaysia news articles from a wide range of reliable sources in real-time using the free api from https://newsapi.org/s/malaysia-news-api. This app offers a user-friendly interface that prioritizes accessibility and convenience, ensuring that users can stay well-informed about current events with ease. With the integration of Firebase for authentication and data storage, the News App offers a secure and personalized platform for users to discover and engage with news content.

The project utilize the following:

- The use of widgets.
- The use of HTTP library for fetching data.
- The use of Firebase for authentication and perform Create, Read, Update, and Delete (CRUD) operations.


## Features

1. Login Page
   - Allows users to sign in with their credentials.
   - If the user has not created an account, they can navigate to the sign-up page.
   - Handles authentication using Firebase.
   - Provides error messages for incomplete or incorrect login details.
   - Offers a password reset option by sending an email to the user.

2. Sign Up Page
   - Enables users to create a new account.
   - Requests profile picture upload, username, email, and password.
   - Validates and ensures completion of all required fields.
   - Stores user details, including the profile picture, in Firebase.
   - Redirects to the home page upon successful sign-up.

3. Home Page
   - Users can scroll through a feed of news articles and view headlines.
   - Categorizes news articles by provider/company.
   - Users can search for specific news articles using keywords.
   - Includes a profile icon that allows users to access their user profile.

4. News Page
   - Users can read full articles.
   - Users can access this page by clicking on a news article from the home page.

5. User Profile Page
   - Displays the user's profile picture.
   - Allows users to update their profile picture.
   - Retrieves and displays the username and email from Firebase.
   - Provides functionality to update the username, email, and password.
   - Updates changes to Firebase in real-time and reflects them on the screen.
   - Includes an option to delete the user account with confirmation.
   - Allows users to log out of the app.

## Installation

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
