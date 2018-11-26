//
//  Constants.swift
//  IMAfter
//
//  Created by SIERRA on 11/29/17.
//  Copyright © 2017 SIERRA. All rights reserved.
//

import Foundation
import UIKit

// messages, alerts
let API_HIT_FAILURE = "Please check your internet connection"
//let API_HIT_FAILURE = "Group Created Successfully"
let API_PARSING_ERROR = "Api Hit Successfully, Parsing Data Error"


//MARK: - Base url of the apis
//let API_BASE_URL = "https://im-after.appspot.com/api/"
let API_BASE_URL = "http://35.176.230.108/imafter/api/"


//let API_BASE_URL = "http://oras.co.in/imafter/api/"

//MARK: - Apis method name
let Login = "native_login"
let Register = "native_register"
let ForgotPassword = "forgot_password"
let UpdateLocation = "update_location"
let DeviceUpdate = "device_update"
let Get_All_Post = "get_all_post"
let Facebook_Login = "facebook_login"
let Get_CategorysId = "get_categorys"
let GetAll_PostCategories = "get_all_post_categorys"
let Offer_to_Sell = "offer_to_sell"
let Post_Wanted = "post_wanted"
let Saved_Post = "saved"
let Update_Account = "update_account"
let Get_Account = "get_account"
let SavedPost_Details = "my_saved"
let WantedPost_Details = "my_wanted"
let Delete_Post = "delete_offer"
let Close_Post = "closed_post"
let Search_Post = "get_all_post_search"
let GET_MESSAGES_LIST = "listing_message"
let GET_CHAT = "get_chat"
let SEND_MESSAGE = "chat"
let ADD_FAV = "add_fav"
let DELETE_POST = "delete_post"


let THEME_COLOR = UIColor(displayP3Red: 43/255.0, green: 148/255.0, blue: 160/255.0, alpha: 1.0)
let CONSTANT_COLOR = UIColor(displayP3Red: 248/255.0, green: 248/255.0, blue: 248/255.0, alpha: 1.0)
let Search_color = UIColor(displayP3Red:62/255 , green: 131/255 , blue: 161/255 , alpha: 1.0)

let GREY_COLOR = UIColor(displayP3Red:225/255 , green: 225/255 , blue: 225/255 , alpha: 1.0)
let WHITE_COLOR = UIColor(displayP3Red:255/255 , green: 255/255 , blue: 255/255 , alpha: 0.7)

let BLACK_COLOR = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1)
//MARK:============================ Notification KEYS =============================

let MESSAGECOME = Notification.Name("message")
let UPDATE_MY_WANTEDSCREEN = Notification.Name("updatemywantedScreen")
let UPDATE_MY_MESSAGESCREEN = Notification.Name("updatemymessageScreen")
let UPDATE_MY_HOMESCREEN = Notification.Name("updatemyhomeScreen")
//Structs

struct PostData {
    var Name :String
    var PostName :String
    var Time :String
    var LastMessage :String
    var friendPic :String
    var PostID :String
    var friendID :String
    var messageCount :String
}
