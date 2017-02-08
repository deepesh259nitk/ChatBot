//
//  DataSource.swift
//  ProductList
//
//  Created by Vasthimal, Deepesh : @djrecker on 03/11/2016.
//  Copyright © 2016 Vasthimal, Deepesh : @djrecker. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DataSource {
    
    private var debugFileName = "chat"

    //messages is just a data model object and instance of Message model.
    var messages = [Message]()
    
    //messageData is coreData object storing data in coreData
    var messagesData = [NSManagedObject]()
    
    func requestData(){
        
        let api = ChatAPI()
        api.loadChatList(nil)
        
        if ChatAPI.json != nil {
            self.populateData()
        }
    
    }
    
    func populateData(){
        
        if AppConstants.isSTUBBED {
        
            if let stubbedData = self.debugSettings(){
                parseData(stubbedData)
            }
            
        } else {
            
            if let jsonData = ChatAPI.json {
                
                let defaults = NSUserDefaults.standardUserDefaults()
                
                if defaults.stringForKey("isSameUser") == nil || defaults.stringForKey("isSameUser") == "false" {
                 
                     parseData(jsonData)
                }
                
            }
        }
    }

    func debugSettings() -> NSDictionary?
    {
        if let dict = PathUtilities.findJSON(debugFileName)
        {
            return dict
        }
        return nil
    }
    
    
    func imageDataforUsers(imageUrl: String)-> NSData? {
        
        if let imageUrlStr = NSURL(string: imageUrl){
            
            let imageData = NSData(contentsOfURL: imageUrlStr)
            return imageData
            
        } else {
            return nil
        }
        
        
    }
    
    func parseData(jsonData : NSDictionary){
        
        //print(jsonData)
        
         if let debugData = jsonData["chats"] as? NSArray {
            
            for item in debugData {
                
                if let name = item["username"] as? String, content = item["content"] as? String, image = item["userImage_url"] as? String, time = item["time"] as? String {
                    
                    let message = Message(userName: name, userTime: time, userImage : image, userContent : content)
                    
                    messages.append(message)
                    
                    self.saveChatMessage(name, userTime: time, userImage: image, userContent: content)
                }
                
            }
            
        }
    }
    
    func addMessage(name: String, time: String, image : String, content : String){
        
        let message = Message(userName: name, userTime: time, userImage : image, userContent : content)
        self.messages.append(message)
    }
    
    func saveChatMessage(userName: String, userTime: String, userImage : String, userContent : String) {
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("ChatData",
                                                        inManagedObjectContext:managedContext)
        
        let chatData = NSManagedObject(entity: entity!,
                                     insertIntoManagedObjectContext: managedContext)
        
        chatData.setValue(userName, forKey: "username")
        chatData.setValue(userTime, forKey: "time")
        chatData.setValue(userImage, forKey: "imageurl")
        chatData.setValue(userContent, forKey: "content")
        
        do {
            try managedContext.save()
            messagesData.append(chatData)
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    func retriveChatMessage()-> [NSManagedObject]{
        
        var chatMessages = [NSManagedObject]()
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ChatData")
        
        do {
            let results =
                try managedContext.executeFetchRequest(fetchRequest)
            chatMessages = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return chatMessages
    }
    
    func deleteChatMessages(){
        
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let fetchRequest = NSFetchRequest(entityName: "ChatData")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedContext.executeRequest(deleteRequest)
            try managedContext.save()
        }
        catch _ as NSError {
            // Handle error
        }
        
    }


}


