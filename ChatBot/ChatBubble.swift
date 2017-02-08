//
//  ChatBubble.swift
//  ChatBot
//
//  Created by Muge Ersoy on 22/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//


import UIKit
import CoreData

class ChatBubble : UITableViewCell {

    @IBOutlet weak var bubbleContent: UILabel!
    
    @IBOutlet weak var userName: UILabel!
    
    @IBOutlet weak var background: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var messageTime: UILabel!
    
    @IBOutlet weak var messageCellView: UIView!
    
    @IBOutlet weak var messageCellViewLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var messageCellViewTrailingConstant: NSLayoutConstraint!
    
    @IBOutlet weak var userNameLeadingConstant: NSLayoutConstraint!
    @IBOutlet weak var timeTrailingConstant: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
        self.userImage.layer.masksToBounds = true
       
        self.userImage.layer.borderWidth = 1
        self.userImage.layer.borderColor = UIColor.whiteColor().CGColor
        self.userImage.layer.cornerRadius = 15

        self.background.layer.cornerRadius = 8
        self.background.layer.masksToBounds = true
        
        self.messageCellView.layer.borderWidth = 1
        self.messageCellView.layer.cornerRadius = 15
        self.messageCellView.layer.borderColor = UIColor.clearColor().CGColor
    }
    
    
    func updateChatBubble(message : NSManagedObject, dataSource : DataSource){
    
    
        if let imageUrl = message.valueForKey("imageurl") as? String, data = dataSource.imageDataforUsers(imageUrl) {
            
            userImage.image = UIImage(data: data)
            
        }
    
        userName.text = message.valueForKey("username") as? String
        
        bubbleContent.text = message.valueForKey("content") as? String
        
        if let time = message.valueForKey("time") as? String{
            
            messageTime.text = "- \(time)"
        }
    }
}