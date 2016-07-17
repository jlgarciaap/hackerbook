//
//  HackerBooksGroup.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 9/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import Foundation


class HackerBooksGroup {
    
    
    //MARK: - Aliases
    
    typealias hackerBooksArray = [HackerBook]
    
    typealias tagString = String
    
    typealias titleString = String
    
    
    
    //Nos ayuda a separar los libros por tags
    typealias hackerBookswithTags = [ tagString : hackerBooksArray]
    
    
    //MARK: - Properties
    
    var dict : hackerBookswithTags = hackerBookswithTags()
    var tagsArray : [String] = [] //Almacenamos los tags existentes
    var tagsGroup : [String] = [] // Almacenamos los tags del libro en cuestion
    var favorites = ["Favorites" : hackerBooksArray()]
    
    //-----En cuanto a la vista por titulos-----//
    typealias booksGroupsTitles = [titleString : hackerBooksArray]
    var booksGroup : booksGroupsTitles = booksGroupsTitles()
    var booksTitles : [String] = []//Almacenamos los titulos de los libros
    //-----Fin vista por titulos-----//
    
    
    //MARK: - Initializators
    
    init(hbooks books: hackerBooksArray){
        
         dict = favorites
        let defaults = NSUserDefaults.standardUserDefaults()
        let favsSaved = defaults.dictionaryForKey("favsSaved")
        let booksSavedFavs = favsSaved?["favorites"] as? [String]
        
        for book in books{
        
            
            //--------Para los titulos----//
            if booksGroup.count == 0 {
                
                booksGroup = [book.title! : hackerBooksArray()]
                
            }
            
            if booksTitles.contains(book.title!) == false{
                booksTitles.append(book.title!)
                
                booksGroup[book.title!] = [book]
                
            }
            //-----fin de los titutos-------//
            
            tagsGroup = book.tags!.componentsSeparatedByString(", ")
        
            if(booksSavedFavs?.contains(book.title!) == true){
                
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
        
        //-----------------Para los titulos--------------------------//
            //Ordenamos los titulos para la tabla
        
        booksTitles = booksTitles.sort({$0.0 < $0.1})

        //-------Fin delos titulos----------------------------------//
        
        
        
        //Ordenamos tagsArray por orden alfabetico 
        tagsArray = tagsArray.sort({$0.0 < $0.1})
       
        
        if let position = tagsArray.indexOf("Favorites"){
            
            tagsArray.removeAtIndex(position)
            tagsArray.insert("Favorites", atIndex: 0)
            
        }
        
        
    }
    
    
 

    
    //Cantidad de tags
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
        
        
    }
    
    //Devolvemos el nombre del tag por la seccion que nos pasan
    func getTags (forSection section: Int) -> String {
        
        return tagsArray[section]
        
        
    }
    

    //-------------------Para la tabla de titulos-----------//
    
    //Cantidad de libros
    var booksCount : Int{
        
        get {
            
            return booksTitles.count
            
        }
        
    }
    
    //Cantidad de libros por seccion
    func booksForSectionOrdered (forSect sect: Int) -> Int{
        
        guard let count = booksGroup[booksTitles[sect]]?.count else {
            
            return 0
            
        }
        
        return count
        
    }


    
    //Identificamos el libro
    func bookForTableOrdered (atIndex index:Int, forSect sect: Int)   -> HackerBook{
        
        let books = booksGroup[booksTitles[sect]]
            
        let book = books![index]
        
        return book
            
            
    }
 
    

    //Nombres de las secciones de titulo
    func getTitles (forSection section: Int)-> String{
        
        return booksTitles[section]
        
    }
    
     //-------------------Fin tabla de titulos-----------//
}



























