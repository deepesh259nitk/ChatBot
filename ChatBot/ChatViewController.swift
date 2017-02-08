//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit
import CoreData

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraintTableView: NSLayoutConstraint!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    let dataSource = DataSource()
    
    var chatMessages = [NSManagedObject]()
    
    override func viewDidLoad() {
        
        self.navigationController?.navigationBar.hidden = false
        
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: navigationController, action: nil)
        navigationItem.leftBarButtonItem = backButton
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
            if defaults.stringForKey("isSameUser") == "false" {
                
                self.dataSource.deleteChatMessages()
            }
        
        //print("messagesData count before is \(dataSource.messagesData.count)");
        
        self.messageTextField.delegate = self
        
        self.tableView.registerNib(UINib(nibName: "ChatBubble", bundle: nil), forCellReuseIdentifier: "ChatBubble")
        self.tableView.registerNib(UINib(nibName: "ChatBubbleForLoggedIn", bundle: nil), forCellReuseIdentifier: "ChatBubbleForLoggedIn")
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.allowsSelection = false
        
        self.navigationItem.title = "Chat - \(AppConstants.loggedInUserName)"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.chatListRefreshed(_:)), name: ChatAPI.ChatListRefreshedNotification, object: nil)
        
        self.hideKeyboardWhenTappedAround()

        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillShow(_:)), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ChatViewController.keyboardWillHide(_:)), name:UIKeyboardWillHideNotification, object: nil);
        
        dataSource.requestData()
    }

    //MARK - UITableViewDataSource
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return self.dataSource.messages.count
        return self.chatMessages.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //print("messagesData cellForRowAtIndexPath count after is \(dataSource.messagesData.count)");

        let message = self.chatMessages[indexPath.row]
        //let message = self.dataSource.messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatBubble") as! ChatBubble
        
        if let username = message.valueForKey("username") as? String, _ = message.valueForKey("content") {
            
            //print(username)
            //print("-------------")
            //print("content is \(content)")
            
            if username != AppConstants.loggedInUserName {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("ChatBubble") as! ChatBubble
                cell.updateChatBubble(message, dataSource: self.dataSource)
                return cell
                
            } else {
                
                let cell = tableView.dequeueReusableCellWithIdentifier("ChatBubbleForLoggedIn") as! ChatBubbleForLoggedIn
                cell.updateChatBubble(message, dataSource: self.dataSource)
                return cell
                
            }
        }
        
        return cell
    }
    
    func chatListRefreshed(notification : NSNotification){
        
        dataSource.populateData()
        
        self.chatMessages = dataSource.retriveChatMessage()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.tableView.reloadData()
            self.scrollTableViewToLastRow()
            
        }
        
        //print("messagesData count after is \(dataSource.messagesData.count)");
        
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = keyboardFrame.size.height + 10
        })
        
        self.scrollTableViewToLastRow()
        
    }
    
    func keyboardWillHide(notification: NSNotification){
        
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.bottomConstraint.constant = 5
        })
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        
        if newLength > 0 {
            
            sendButton.userInteractionEnabled = true
            sendButton.titleLabel?.textColor = UIColor.blackColor()
            
        } else {
            
            sendButton.userInteractionEnabled = false
            sendButton.titleLabel?.textColor = UIColor.lightGrayColor()
        }
        
        return true
    }
    
    func scrollTableViewToLastRow(){
        
        let lastRow: Int = self.chatMessages.count-1
        let indexPath = NSIndexPath(forRow: lastRow, inSection: 0)
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
        
    }
    
    
    @IBAction func sendMessage(sender: AnyObject) {
        
        if let instantMessage = messageTextField.text {
            
            if instantMessage.characters.count > 0 {
            
                self.dataSource.addMessage(AppConstants.loggedInUserName, time: TimeUtilities.currentHourMinSec(), image: "", content: instantMessage)
                
                self.dataSource.saveChatMessage(AppConstants.loggedInUserName, userTime: TimeUtilities.currentHourMinSec(), userImage: "", userContent: instantMessage)
        
                self.chatMessages = dataSource.retriveChatMessage()
                
                self.tableView.reloadData()
                self.scrollTableViewToLastRow()
                
            }
            
        }
        
        messageTextField.text = ""
        
    }
    
    @IBAction func logOut(sender: AnyObject) {
        
        //flush all data from coredata
        self.dataSource.deleteChatMessages()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject("false", forKey: "isSameUser")
        
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self);
    }

}