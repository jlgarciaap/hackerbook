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
        
        
        let nCenter = NSNotificationCenter.defaultCenter()
        
        nCenter.addObserver(self, selector: #selector(bookAddFav), name: "favChangedOn", object: nil)
        nCenter.addObserver(self, selector: #selector(bookRemoveFav), name: "favChangedOff", object: nil)
        
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
        //Es decir cuantos elementos por afiliacion
        
        return model.booksForTagCount(forTags: section)
        
        //return model.characterCount(forAffiliation: getAffiliation(forSection: section) )
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "HackerBookCellID"
        
        let book = model.bookForTable(atIndex: indexPath.row, forTag: indexPath.section)
        
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
    
    func bookAddFav (notification: NSNotification){
        
        
        let data = notification.userInfo!
        
        //Sacamos el libro de la notificacion
        let book = data["key"]
    
        let defaults = NSUserDefaults.standardUserDefaults()
        
       
        
        //Si no existe el "fav" lo creamos con el primer libro
        if defaults.dictionaryForKey("fav") == nil {
            
            let favSaved = ["Favorites": [book!]]
            
            defaults.setObject(favSaved, forKey: "fav")
            
            
        } else {
            
            //Sacamos lo que tiene comprobamos y si no existe lo añadimos
            let bookSavedinFav = defaults.dictionaryForKey("fav")
            
            let bookGroup = bookSavedinFav!["Favorites"]
            
            var bookExtract = bookGroup![0] as? String
            
            if (bookExtract!.containsString(book as! String)){
                
                //Si lo contiene no hacemos nada
                
            } else {
            
            bookExtract = bookExtract! + ",\(book!)"
            
            let favSaved = ["Favorites": [bookExtract!]]

            defaults.setObject(favSaved, forKey: "fav")
            
            }
        
        }

    }
    
    
    func bookRemoveFav (notification: NSNotification){
        
        
        let data = notification.userInfo!
        
        //Sacamos el libro de la notificacion
        let book = data["key"]
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        
        //Si no existe no hacemos nada
        if defaults.dictionaryForKey("fav") == nil {
           //no hacer nada
            
            
        } else {
            
            //Sacamos lo que tiene comprobamos y si existe lo borramos
            let bookSavedinFav = defaults.dictionaryForKey("fav")
            
            let bookGroup = bookSavedinFav!["Favorites"]
            
            let bookExtract = bookGroup![0] as? String
            
            if (bookExtract!.containsString(book as! String)){
                
             
               var bookArray = bookExtract?.componentsSeparatedByString(",")
                
                
                bookArray = bookArray?.filter({$0 != (book as! String)})
                
                let booksString = bookArray?.joinWithSeparator(",")
                
                
                let favSaved = ["Favorites" : [booksString!]]
                
                defaults.setObject(favSaved, forKey: "fav")
                
            } else {
                
                
                
            }
            
        }
        
    }
    
        
}
    




//MARK: - Protocols


protocol HackerBooksControllerDelegate {

    
    func hackerBooksViewController(vc: HackerBooksTableTableViewController, didSelectBook book: HackerBook)
    
    
}



//MARK: - Extensions



    
    
    
    


























