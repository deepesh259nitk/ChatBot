//
//  ViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

enum Friends : String {
    
    case Carrie  = "Carrie"
    case Anthony = "Anthony"
    case Eleanor = "Eleanor"
    case Rodney  = "Rodney"
    case Oliva   = "Oliva"
    case Merve   = "Merve"
    case Lily    = "Lily"

}

class ViewController: UIViewController {

    @IBOutlet weak var loginName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.hidden = true
        
        let defaults = NSUserDefaults.standardUserDefaults()
                
        if defaults.stringForKey("isSameUser") == "true" {
            
            if let username = defaults.stringForKey("userName"){
                
                AppConstants.loggedInUserName = username
            }
            
            self.performSegueWithIdentifier("gotoChat", sender: nil)

        }

        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func showChat(sender: AnyObject) {
        
        if isValidUserName() == false {
            
            let alert = UIAlertController(title: "Alert", message: "Please Enter a Valid Name", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        if let userName = loginName.text {
            
            AppConstants.loggedInUserName = userName
            defaults.setObject(userName, forKey: "userName")
            defaults.synchronize()
            
        }
        
        loginName.text = ""
        
        /*if defaults.stringForKey("isSameUser") == nil  {
            self.performSegueWithIdentifier("gotoChat", sender: nil)
        }
        
        if defaults.stringForKey("isSameUser") == "true"  {
            self.performSegueWithIdentifier("gotoChat", sender: nil)
        }*/
        
        self.performSegueWithIdentifier("gotoChat", sender: nil)
    }

    func isValidUserName()-> Bool{
        
        if (loginName.text == Friends.Carrie.rawValue) || (loginName.text == Friends.Anthony.rawValue) || (loginName.text == Friends.Eleanor.rawValue) || (loginName.text == Friends.Rodney.rawValue) || (loginName.text == Friends.Oliva.rawValue) || (loginName.text == Friends.Merve.rawValue) || (loginName.text == Friends.Lily.rawValue) {
            
            return false
            
        } else if loginName.text?.characters.count == 0 {
            
            return false
        
        } else {
         
            return true
        }
    }
}

