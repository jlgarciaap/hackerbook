

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
    
    
    let authors = json["authors"] as? String
    
    guard let imageUrlString = json["image_url"] as? String, imageUrl = NSURL(string: imageUrlString), dataImage = NSData(contentsOfURL: imageUrl), image = UIImage(data: dataImage) else{
        
        throw HackerBooksErrors.imageJSONError
        
    }
    
    guard let pdfUrl = json["pdf_url"] as? String, url = NSURL(string: pdfUrl) else{
        
        throw HackerBooksErrors.pdfJSONError
        
    }

    let tags = json["tags"] as? String
    
    if let title = json["title"] as? String{
    
        return HackerBook(authors: authors, image: image, pdfUrl: url, tags: tags, title: title)
    
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
















