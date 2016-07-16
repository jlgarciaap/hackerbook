//
//  HackerBooksGroup.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 9/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import Foundation


class HackerBooksGroup {
    
    
    //    "authors": "Scott Chacon, Ben Straub",
    //    "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
    //    "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
    //    "tags": "version control, git",
    //    "title": "Pro Git"
    
    //MARK: - Aliases
    
    typealias hackerBooksArray = [HackerBook]
    
    typealias tagString = String
    
    
    
    //NOs ayuda a separar los libros por tags
    typealias hackerBookswithTags = [ tagString : hackerBooksArray]
    
    //MARK: - Properties
    
    var dict : hackerBookswithTags = hackerBookswithTags()
    var tagsArray : [String] = [] //Almacenamos los tags existentes
    var tagsGroup : [String] = [] // Almacenamos los tags del libro en cuestion
    var favorites = ["favorites" : hackerBooksArray()]
    
    
    //MARK: - Util
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //MARK: - Initializators
    
    init(hbooks books: hackerBooksArray){
        
         dict = favorites
        let defaults = NSUserDefaults.standardUserDefaults()
        let favsSaved = defaults.dictionaryForKey("favsSaved")
        let booksSavedFavs = favsSaved?["favorites"] as? [String]
        
        for book in books{
            
            
            
            tagsGroup = book.tags!.componentsSeparatedByString(", ")
        
            if(booksSavedFavs?.contains(book.title!) == true){
                
                tagsArray.append("favorites")
                tagsGroup.append("favorites")
                
                
            }

    
            
            for tag in (tagsGroup) {

                
                if dict.count == 0 {
                    
                    dict = [ tag : hackerBooksArray()]
                    
                }
                
               
                
                
                if !tagsArray.contains(tag){
                    
                    tagsArray.append(tag)
                    dict[tag] = [book]
                    
                } else {
                    
                    dict[tag]?.append(book)
                  
        
                }
                
                
            }
            
        }
        
        //Ordenamos tagsArray por orden alfabetico 
        tagsArray = tagsArray.sort({$0.0 < $0.1})
        print(tagsArray)
        
        if let position = tagsArray.indexOf("favorites"){
            
            tagsArray.removeAtIndex(position)
            tagsArray.insert("favorites", atIndex: 0)
            
            print(tagsArray)
            
        }
        
        
        
    }
        
    // Cantidad de tags
        
        var tagsCount : Int {
            
            get {
                
                return tagsArray.count
            }
            
        }
        
        
    // Cantidad de libros por tag
        
        func booksForTagCount(forTags tag: Int) -> Int{
            
        
            guard let count = dict[tagsArray[tag]]?.count else {
                
                return 0
                
            }
            
            return count
            
        }
    
 
    
    // identificamos libro por tag
    func bookForTable (atIndex index: Int, forTag tag: Int ) -> HackerBook{
        
        // Aquie le pasamos Ints por el indexpath.row y el section y devolvemos un book
        
        
        let books = dict[tagsArray[tag]]
        
        let book = books![index]
        
        return book
            
            
            //Podemos intentar recibir el contenido de favoritos desde el controlador a una funcion aqui 
            //que tambien la llamamos desde aqui para que devuelva el contenido
            
       

    }
    
    //Devolvemos el nombre del tag por la seccion que nos pasan
    func getTags (forSection section: Int) -> String {
        
        return tagsArray[section]
        
        
        }
    
    
    }



























