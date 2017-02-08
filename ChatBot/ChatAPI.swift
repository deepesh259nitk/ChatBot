//  Created by ITRMG on 2016-18-12.
//  Copyright © 2016 Vasthimal, Deepesh : @djrecker. All rights reserved.
//

import Foundation

class ChatAPI {
    
    static var json : NSDictionary?
    static let ChatListRefreshedNotification = "ChatListRefreshed"
    static let serverURL =  "https://s3-eu-west-1.amazonaws.com/rocket-interview/chat.json"
    
    func loadChatList(completion: ((AnyObject) -> Void)!) {
        
        let session = NSURLSession.sharedSession()
        if let productsUrl = NSURL(string: ChatAPI.serverURL){
            
            let task = session.dataTaskWithURL(productsUrl){
                (data, response, error) -> Void in
                
                do {
                    let JSON = try NSJSONSerialization.JSONObjectWithData(data!, options:NSJSONReadingOptions(rawValue: 0))
                    guard let JSONDictionary: NSDictionary = JSON as? NSDictionary else {
                        print("Not a Dictionary")
                        return
                    }
                    
                    ChatAPI.json = JSONDictionary
                    NSNotificationCenter.defaultCenter().postNotificationName(ChatAPI.ChatListRefreshedNotification, object: nil)
                    
                }
                catch let JSONError as NSError {
                    print("\(JSONError)")
                }
                
            }
            
            task.resume()
        }
    }
}