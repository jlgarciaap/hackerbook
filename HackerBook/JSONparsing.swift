

import Foundation
import UIKit




//MARK: - Aliases

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Parsing JSON

//    "authors": "Scott Chacon, Ben Straub",
//    "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
//    "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
//    "tags": "version control, git",
//    "title": "Pro Git"


func parsing (hackerBook json: JSONDictionary) throws -> HackerBook {
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    let authors = json["authors"] as? String
    let title = json["title"] as? String
    
    if (defaults.dataForKey(title!) == nil){
    
    guard let imageUrlString = json["image_url"] as? String, imageUrl = NSURL(string: imageUrlString), dataImage = NSData(contentsOfURL: imageUrl) else{
        
        //image = UIImage(data: dataImage)
        throw HackerBooksErrors.imageJSONError
        
        }
    
        defaults.setObject(dataImage, forKey: title!)
    }
        
        let imageData = defaults.dataForKey(title!)
        
        let image = UIImage(data: imageData!)
        
    
    
    guard let pdfUrl = json["pdf_url"] as? String else {
        
        //url = NSURL(string: pdfUrl)
        
        throw HackerBooksErrors.pdfJSONError
                
    }
    
    
    
    if let tags = json["tags"] as? String {
    
        return HackerBook(authors: authors, image: image!, pdfUrl: pdfUrl, tags: tags, title: title)
    
    } else {
        
       throw HackerBooksErrors.JSONParsingError
        
    }
    
}

// Sobrecargamos en el caso de que tengamos un opcional en lugar de un JSONDictionary directamente

func parsing(hackerBook json: JSONDictionary?) throws -> HackerBook {
    
    
    if case .Some(let jsonDict) = json{
        
        return try parsing(hackerBook: jsonDict)
        
    }else {
        
        throw HackerBooksErrors.JSONParsingError
        
    }
    
}

//MARK: - Loading local file

func loadFromLocalFile(fileName name: String, bundle: NSBundle = NSBundle.mainBundle()) throws -> JSONArray {
    
    
    if let url = bundle.URLForResource(name), data = NSData(contentsOfURL: url),
        maybeArray = try? NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as? JSONArray, array = maybeArray{
        
        
        
        
        return array
        
    } else{
        
        throw HackerBooksErrors.JSONParsingError
    }
    
    
    
}

//MARK: - Loading save File

func loadFromSaveFile (file name: NSData) throws -> JSONArray {
    
   if let maybeArray = try? NSJSONSerialization.JSONObjectWithData(name, options: NSJSONReadingOptions.MutableContainers) as? JSONArray, array = maybeArray{
        
        return array
        
    } else{
        
        throw HackerBooksErrors.JSONParsingError
    }
    

    
    
}
















