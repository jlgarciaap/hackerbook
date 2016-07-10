//
//  HackerBooksGroup.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 9/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//



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
    var tagsArray : [String] = [""]
    
    //MARK: - Initializators
    
    init(hbooks books: hackerBooksArray){
        
        
        
        for book in books{
            
            let tagsGroup = book.tags?.componentsSeparatedByString(",")
            
            for tag in (tagsGroup)! {
                
               
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
    }
        
    // Cantidad de tags
        
        var tagsCount : Int {
            
            get {
                
                return dict.count
                
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
    
    func getTags (forSection section: Int) -> String {
        
        return tagsArray[section]
        
        
    }
    
        
    
    
    }



























