//
//  Documentation.swift
//  IMAfter
//
//  Created by SIERRA on 11/28/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//


//MARK: - WELCOME SCREEN
/*
 1. It is the first screen of the App.
 2. Only one "Continue" button is there on the screen.
 3. On clicking "Continue" button, it will navigate to next(Select Login Type) screen.
*/

//MARK: - SELECT LOGIN TYPE SCREEN
/*
 There are three options in this screen:
 1. Facebook Login - It will initiate Facebook Login Sdk.
 2. Simple Login - It will navigate to Login screen.
 3. Create Account / Register  - It will navigate to Create Account screen.
 */

//MARK: - LOGIN SCREEN
/*
 1. To Login, enter "Email" and "Password".
 2. Then click "Login" button and login api will hit, it will navigate to Home Screen.
 3. "Forgotten Password" button - Clicking on it, forgot password api will be called.
 */

//MARK: - CREATE ACCOUNT SCREEN
/*
 1. Enter all details: "Image", "Unique Id", "Email" and "Password".
 2. Then click "Create Account" button, it will navigate to Home Screen.
 */

//MARK: - HOME(EXPLORE) SCREEN
/*
 1. There is SearchBar on the top to filter the result by manually typing the category.
 2. "Filter" button will open a pop up of filter categories tablview. Select any catgories and result will filter according to selected filter options.
 3. Total number of results are also shown on top of the screen.
 4. There is Collection View to display all the posts in the home screen which shows: post category, post title, price range.
 5. There is a star in each cell of collection view at top right corner.
 6. On clicking the star, post will be added in the Saved list.
 7. DisSelect of collection view will navigate to Detail screen of the selected Post.
*/

//MARK: - DETAIL SCREEN
/*
 1. Navigation title will be the Post Title/ Post Name
 2. Then Post image will be shown.
 3. Display Image and name of the user who posted the wanting will be shown.
 4. Post Name in the label is displayed.
 5. Post Description is shown.
 6. Post Price is displayed.
 7. In the bottom left corner of the screen there is a star button: It is to mark the post in the saved list same as star button in home screen collection view cell
 8. In the bottom right corner of the screen there is "Offer To Sell" button: It will navigate to Offer To Sell Screen.
 9. In the right corner of Navigation bar there are three dots: On clicking them Report the post option will be displayed if the post contains inappropriate content.
*/

//MARK: - OFFER TO SELL SCREEN
/*
 1. This screen is to send an offer against any post.
 2. To send offer first have to upload the image of the offer.
 3. Have to set the price of the offer.
 4. Enter the decription of the item offered.
 5. Then Click on "Submit Offer" button: it will navigate to the chat screen where the offer image and price will be sent as the message to the user who posted the wanting.
 6. If any offer is submitted against any post, it will be automatically added in the "Saved list" whether or not the star mark is tapped.
*/


//MARK: - SAVED SCREEN --
/*
 1. Enter all details: "Image", "Unique Id", "Email" and "Password".
 2. Then click "Create Account" button, it will navigate to Home Screen.
*/


//MARK: - MY ACCOUNT SCREEN
/*
 1. It shows the image, name and unique id of the user currently logged in.
 2. There are three other options:
     a. Settings
     b. Send Us Feedback
     c. Logout: It will logout the logged in user.
 3. Profile can be edited in this screen as image.
*/

//MARK: - Message List Screen
/*
 1. It shows the Two list open and closed.
 2.In Message Screen it show the listing of peoples with whom we chat recently.
*/

//MARK: - Chat Screen
/*
 1. There is Image of offer and Name of offer and Name of user who posted that offer at the top bar.
 2. Below that there is chat View where useres can send text and image messages.
*/








