//
//  ChatBubbleForLoggedIn.swift
//  ChatBot
//
//  Created by ITRMG on 2016-18-12.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit
import CoreData

class ChatBubbleForLoggedIn: UITableViewCell {

    @IBOutlet weak var bubbleContent: UILabel!
    @IBOutlet weak var background: UIView!

    @IBOutlet weak var messageCellView: UIView!
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    override func awakeFromNib() {
               super.awakeFromNib()
        // Initialization code
        
        self.background.layer.cornerRadius = 8
        self.background.layer.masksToBounds = true
        
        self.messageCellView.layer.borderWidth = 1
        self.messageCellView.layer.cornerRadius = 15
        self.messageCellView.layer.borderColor = UIColor.clearColor().CGColor
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateChatBubble(message : NSManagedObject, dataSource : DataSource){
    
        userName.text = message.valueForKey("username") as? String
    
        bubbleContent.text = message.valueForKey("content") as? String
        
        if let time = message.valueForKey("time") as? String{
        
            messageTime.text = "- \(time)"
        }
        
    }

}
