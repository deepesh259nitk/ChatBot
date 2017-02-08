//
//  Message.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import Foundation

class Message {

    var name : String

    var time : String
    
    var image : String
    
    var content : String

    init(userName: String, userTime: String, userImage : String, userContent : String){
        
        self.name    = userName
        self.time    = userTime
        self.image   = userImage
        self.content = userContent
   
    }
    
}