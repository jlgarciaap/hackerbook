//
//  HackerBooksTableTableViewController.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 9/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit

class HackerBooksTableTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    let model : HackerBooksGroup
    
    //Delegado
    var delegate : HackerBooksControllerDelegate?
    
    
    //MARK: - Initialization
    
    init(model : HackerBooksGroup){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: Table View Data Source
    
    override func viewWillAppear(animated: Bool) {
        
        //let defaults = NSUserDefaults.standardUserDefaults()
        //defaults.removeObjectForKey("favsSaved")
        
        let nCenter = NSNotificationCenter.defaultCenter()
        
        nCenter.addObserver(self, selector: #selector(bookAddFav), name: "favChangedOn", object: nil)
        nCenter.addObserver(self, selector: #selector(bookRemoveFav), name: "favChangedOff", object: nil)
        nCenter.addObserver(self, selector: #selector(bookSaveFav), name: "favChangedOn", object: nil)
        nCenter.addObserver(self, selector: #selector(bookDelFav), name: "favChangedOff", object: nil)

        
        super.viewWillAppear(true)
        
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Averiguamos el libro
        let bookSelect = book(forIndexPath: indexPath)
        
       // print(UIDevice.currentDevice().userInterfaceIdiom.rawValue)
        
        //raw value 0 iphone n raw value 1 ipad
        
        if (UIDevice.currentDevice().userInterfaceIdiom.rawValue == 0){
        
        let bookVC = HackerBookControllerViewController(model: bookSelect)
        navigationController?.pushViewController(bookVC, animated: true)
        }
        //avisamos al delegado del cambio
        delegate?.hackerBooksViewController(self, didSelectBook: bookSelect)
        
        //Lo mismo por notificaciones
        let nCenter = NSNotificationCenter.defaultCenter()
        
        let notif = NSNotification(name: "BookChanged", object: self, userInfo: ["key": bookSelect])
        
        nCenter.postNotification(notif)
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
     
        
             return model.tagsArray.count
     
        
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Numero de filas por seccion.
        //Es decir cuantos elementos por tag
        
        return model.booksForTagCount(forTags: section)
        
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "HackerBookCellID"
        
        let book : HackerBook
        
        
        book = model.bookForTable(atIndex: indexPath.row, forTag: indexPath.section)
        
     
        var cell = tableView.dequeueReusableCellWithIdentifier(cellId)
        
        if cell == nil {
            
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: cellId)
            
            
        }
        
        cell?.imageView?.image = book.image
        cell?.textLabel?.text = book.title
        cell?.detailTextLabel?.text = book.authors
        
        
        return cell! // Como hemos puesto el if cell podemos forzar la apertura
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return model.getTags(forSection: section)
        
        
    }
    
    
    
    //MARK: - Utilities
    
    func book(forIndexPath indexPath: NSIndexPath) -> HackerBook {
        
        
        return model.bookForTable(atIndex: indexPath.row, forTag: indexPath.section)
        
    }
    
}


//MARK: - Protocols


protocol HackerBooksControllerDelegate {

    
    func hackerBooksViewController(vc: HackerBooksTableTableViewController, didSelectBook book: HackerBook)
    
    
}



//MARK: - Extensions

extension HackerBooksTableTableViewController {
 //Pertenece al comportamiento del switch de favoritos
    
    func bookAddFav (notification: NSNotification){
        
        
        let data = notification.userInfo!
        
        //Sacamos el libro de la notificacion
        let bookData : HackerBook = data["key"] as! HackerBook
        
        
        if (model.tagsArray.contains("Favorites") == false){
            
            print("Pasamos por aqui no tenemos favoritos")
          
        //model.tagsGroup.append("favorites")
            model.tagsArray.insert("Favorites", atIndex: 0)
            model.dict["Favorites"]?.append(bookData)
            
        //bookData.tags = bookData.tags! + ", favorites"
            
          self.tableView.reloadData()
            
            
        } else {
            
            model.dict["Favorites"]?.append(bookData)
           self.tableView.reloadData()
            
        }
        
    }

func bookRemoveFav (notification: NSNotification){
            

            let data = notification.userInfo!
    
            //Sacamos el libro de la notificacion
            let book = data["key"] as? HackerBook
    
            let favArray = model.dict["Favorites"]
    
            let potision = favArray!.indexOf({$0.title == book!.title })
    
            model.dict["Favorites"]?.removeAtIndex(potision!)
    
            book!.tags = book?.tags!.stringByReplacingOccurrencesOfString(", favorites", withString: "")
    
    
            //model.dict["favorites"]?.removeAtIndex(position)
    
            self.tableView.reloadData()

                
     }
}

extension HackerBooksTableTableViewController {
    //Pertenece al guardado de favoritos
    
    
    
    func bookSaveFav(notification : NSNotification){
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let favContains = defaults.dictionaryForKey("favsSaved")
    
        let data = notification.userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book!.title
        //comprobamos si ya existe el guardado
        
 
        
        if (favContains == nil) {
        
        let bookFavs = ["favorites" : [bookTitle!]]
        
        defaults.setObject(bookFavs, forKey: "favsSaved")
        
        } else {
        
            var favsSaved = favContains!["favorites"] as? Array<String>
            
            if(favsSaved?.contains(bookTitle!) == false){
            
                favsSaved?.append(bookTitle!)
            
                let bookFavs = ["favorites" : favsSaved!]
            
                defaults.setObject(bookFavs, forKey: "favsSaved")
            }
            
        }
        
    }
    
    
    
    func bookDelFav(notification : NSNotification){
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let favContains = defaults.dictionaryForKey("favsSaved")
        
        var favArrays = favContains!["favorites"] as? Array<String>
        
        let data = notification.userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book?.title
        
        if (favArrays?.contains(bookTitle!) == true ){
            
            let position = favArrays!.indexOf({$0 == bookTitle})
            
            favArrays?.removeAtIndex(position!)
            
            let favsSaved = ["favorites" : favArrays!]
            
            defaults.setObject(favsSaved, forKey: "favsSaved")
            
        }
        
    }
    
    
    
    
}

    
    
    
    


























