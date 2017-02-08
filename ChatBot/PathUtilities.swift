//
//  PathUtilities.swift

//  Created by ITRMG on 2016-18-12.
//  Copyright © 2016 Vasthimal, Deepesh : @djrecker. All rights reserved.
//

import Foundation


typealias JSONDict = [String : AnyObject]
typealias JSONDicts = [JSONDict]

class PathUtilities {
    
    static func find(resourceNamed : String, ofType type : String ) -> NSData?
    {
        if let path = NSBundle.mainBundle().pathForResource(resourceNamed, ofType: type)
        {
            do
            {
                let jsonData = try NSData(contentsOfFile: path, options: NSDataReadingOptions.DataReadingMappedIfSafe)
                return jsonData
            }
            catch {}
        }
        
        return nil
    }
    
    static func findJSON(resourceNamed : String) -> JSONDict?
    {
        if let jsonData = self.find(resourceNamed, ofType: "json")
        {
            do
            {
                if let jsonResult : JSONDict = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions(rawValue : 0)) as? JSONDict
                { return jsonResult }
                
            }
            catch {}
        }
        
        return nil
    }

}