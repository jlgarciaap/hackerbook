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
    
    typealias titleString = String
    
    
    
    //NOs ayuda a separar los libros por tags
    typealias hackerBookswithTags = [ tagString : hackerBooksArray]
    
    typealias booksGroupsTitles = [titleString : hackerBooksArray]
    
    //MARK: - Properties
    
    var dict : hackerBookswithTags = hackerBookswithTags()
    var tagsArray : [String] = [] //Almacenamos los tags existentes
    var tagsGroup : [String] = [] // Almacenamos los tags del libro en cuestion
    var favorites = ["Favorites" : hackerBooksArray()]
    var booksGroup : booksGroupsTitles = booksGroupsTitles()
    var booksTitles : [String] = []//Almacenamos los titulos de los libros
    
    //MARK: - Util
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    //MARK: - Initializators
    
    init(hbooks books: hackerBooksArray){
        
         dict = favorites
        let defaults = NSUserDefaults.standardUserDefaults()
        let favsSaved = defaults.dictionaryForKey("favsSaved")
        let booksSavedFavs = favsSaved?["favorites"] as? [String]
        
        for book in books{
        
            if booksGroup.count == 0 {
                
                booksGroup = [book.title! : hackerBooksArray()]
                
            }
            
            //--------Para los titutlos----//
            if booksTitles.contains(book.title!) == false{
                booksTitles.append(book.title!)
                
                booksGroup[book.title!] = [book]
                
            }

            
            //-----fin de los titutos---
            
            tagsGroup = book.tags!.componentsSeparatedByString(", ")
        
            if(booksSavedFavs?.contains(book.title!) == true){
                
                //tagsArray.append("favorites")
                tagsGroup.append("favorites")
                
            }

            for tag in (tagsGroup) {

                
                if dict.count == 0 {
                    
                    dict = [ tag : hackerBooksArray()]
                    
                }
                
               
                
                
                if !tagsArray.contains(tag.capitalizedString){
                    
                    tagsArray.append(tag.capitalizedString)
                    dict[tag.capitalizedString] = [book]
                    
                } else {
                    
                    dict[tag.capitalizedString]?.append(book)
                  
        
                }
                
                
            }
            
        }
        
        //------Para los titulos---//
        
        
        
        booksTitles = booksTitles.sort({$0.0 < $0.1})

        //-------Fin delos titulos---//
        
        //Ordenamos tagsArray por orden alfabetico 
        tagsArray = tagsArray.sort({$0.0 < $0.1})
       
        
        if let position = tagsArray.indexOf("Favorites"){
            
            tagsArray.removeAtIndex(position)
            tagsArray.insert("Favorites", atIndex: 0)
            
        }
        
        
    }
    
    
        
    var booksCount : Int{
        
        get {
            
            return booksTitles.count
            
        }
        
    }

    
    // Cantidad de tags
        
        var tagsCount : Int {
            
            get {
                
                return tagsArray.count
            }
            
        }
    
    func booksForSectionOrdered (forSect sect: Int) -> Int{
        
        guard let count = booksGroup[booksTitles[sect]]?.count else {
            
            return 0
            
        }
        
        return count
        
    }
    
        
    // Cantidad de libros por tag
        
        func booksForTagCount(forTags tag: Int) -> Int{
            
        
            guard let count = dict[tagsArray[tag]]?.count else {
                
                return 0
                
            }
            
            return count
            
        }
    
    func bookForTableOrdered (atIndex index:Int, forSect sect: Int) -> HackerBook{
        
        let books = booksGroup[booksTitles[sect]]
        
        let book = books![index]
        
        return book
        
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
    
    
    func getTitles (forSection section: Int)-> String{
        
        return booksTitles[section]
        
    }
    
    //Devolvemos el nombre del tag por la seccion que nos pasan
    func getTags (forSection section: Int) -> String {
        
        return tagsArray[section]
        
        
        }
    
    
    }



























