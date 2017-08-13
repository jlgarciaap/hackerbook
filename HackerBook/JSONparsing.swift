

import Foundation
import UIKit




//MARK: - Aliases

typealias JSONObject = AnyObject
typealias JSONDictionary = [String: JSONObject]
typealias JSONArray = [JSONDictionary]

//MARK: - Parsing JSON

func parsing (hackerBook json: JSONDictionary) throws -> HackerBook {
    
    let defaults = UserDefaults.standard
    
    let authors = json["authors"] as? String
    
    guard let title = json["title"] as? String else{
        
        throw HackerBooksErrors.jsonParsingError
        
    }
    
    if (defaults.data(forKey: title) == nil){
    
    guard let imageUrlString = json["image_url"] as? String, let imageUrl = URL(string: imageUrlString), let dataImage = try? Data(contentsOf: imageUrl) else{
        
        throw HackerBooksErrors.imageJSONError
        
        }
        
        //Si todo va bien lo guardamos
        defaults.set(dataImage, forKey: title)
    }
        
    guard let imageData = defaults.data(forKey: title) else{
        
        throw HackerBooksErrors.imageSaveRecoverFailed
        
    }
        
    let image = UIImage(data: imageData)
    
    guard let pdfUrl = json["pdf_url"] as? String else {
        
        
        throw HackerBooksErrors.pdfJSONError
                
    }
    
    
    
    if let tags = json["tags"] as? String {
    
        return HackerBook(authors: authors, image: image!, pdfUrl: pdfUrl, tags: tags, title: title)
    
    } else {
        
       throw HackerBooksErrors.jsonParsingError
        
    }
    
}

// Sobrecargamos en el caso de que tengamos un opcional en lugar de un JSONDictionary directamente

func parsing(hackerBook json: JSONDictionary?) throws -> HackerBook {
    
    
    if case .some(let jsonDict) = json{
        
        return try parsing(hackerBook: jsonDict)
        
    }else {
        
        throw HackerBooksErrors.jsonParsingError
        
    }
    
}

//MARK: - Loading local file

func loadFromLocalFile(fileName name: String, bundle: Bundle = Bundle.main) throws -> JSONArray {
    
    
    if let url = bundle.URLForResource(name), let data = try? Data(contentsOf: url),
        let maybeArray = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray, let array = maybeArray{
        
        return array
        
    } else{
        
        throw HackerBooksErrors.jsonParsingError
    }
    
    
    
}

//MARK: - Loading save File

func loadFromSaveFile (file name: Data) throws -> JSONArray {
    
   if let maybeArray = try? JSONSerialization.jsonObject(with: name, options: JSONSerialization.ReadingOptions.mutableContainers) as? JSONArray, let array = maybeArray{
        
        return array
        
    } else{
        
        throw HackerBooksErrors.jsonParsingError
    }
    

    
    
}
















