//
//  HackerBooksTableTableViewController.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 9/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit

class HackerBooksTableViewController: UITableViewController {
    
    
    //MARK: - Properties
    let model : HackerBooksGroup
    
    
    //Delegado
    var delegate : HackerBooksControllerDelegate?
    
    //Segmented Control
    var orderSelect : UISegmentedControl
    
    
    //MARK: - Initialization
    
    init(model : HackerBooksGroup){
        
        self.model = model
        self.orderSelect = UISegmentedControl(items: ["Tags", "Title"])
        
        super.init(nibName: nil, bundle: nil)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: Table View Data Source
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        let nCenter = NSNotificationCenter.defaultCenter()
        
        nCenter.addObserver(self, selector: #selector(bookAddFav), name: "favChangedOn", object: nil)
        nCenter.addObserver(self, selector: #selector(bookRemoveFav), name: "favChangedOff", object: nil)
        nCenter.addObserver(self, selector: #selector(bookSaveFav), name: "favChangedOn", object: nil)
        nCenter.addObserver(self, selector: #selector(bookDelFav), name: "favChangedOff", object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self)
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Registramos celda personalizada
        self.tableView.registerNib(UINib(nibName:"HackerBooksCellView", bundle: nil), forCellReuseIdentifier: "HackerBooksCellView")

        
        self.orderSelect.selectedSegmentIndex = 0
        
        self.navigationItem.titleView = self.orderSelect
        //Controlamos los cambios en el selector
        self.orderSelect.addTarget(self, action: #selector(reloadTable), forControlEvents: .ValueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        //Averiguamos el libro
        let bookSelect = book(forIndexPath: indexPath)
        
        //avisamos al delegado del cambio
        delegate?.hackerBooksViewController(self, didSelectBook: bookSelect)
        
        //Lo mismo por notificaciones
        let nCenter = NSNotificationCenter.defaultCenter()
        
        let notif = NSNotification(name: "BookChanged", object: self, userInfo: ["key": bookSelect])
        
        nCenter.postNotification(notif)
        
        //Para movernos cuando es Iphone
        //raw value 0 iphone en raw value 1 ipad
        if (UIDevice.currentDevice().userInterfaceIdiom.rawValue == 0){
            
            let bookVC = HackerBookViewController(model: bookSelect)
            navigationController?.pushViewController(bookVC, animated: true)
        }
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if(self.orderSelect.selectedSegmentIndex == 0){
        
         return model.tagsArray.count
        }
        
        return model.booksTitles.count
        
        
        
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Numero de filas por seccion.
        //Es decir cuantos elementos por tag
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0){
            
            return model.booksForTagCount(forTags: section)
        }
        
        return model.booksForSectionOrdered(forSect: section)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellId = "HackerBooksCellView"
        
        let book : HackerBook
        
        if(self.orderSelect.selectedSegmentIndex == 0){
        
            book = model.bookForTable(atIndex: indexPath.row, forTag: indexPath.section)
        
        } else {
        
            book = model.bookForTableOrdered(atIndex: indexPath.row, forSect: indexPath.section)         
        }
        
        //Celda personalizada
        let cell : HackerBooksCellView = tableView.dequeueReusableCellWithIdentifier(cellId) as! HackerBooksCellView
        
        cell.authorsLabel.text = book.authors
        cell.ImageView?.image = book.image
        cell.titleLabel.text = book.title
        cell.titleLabel.textColor = UIColor.whiteColor()
        cell.titleLabel.backgroundColor = UIColor.lightGrayColor()
        
        return cell
        
    }
    
    
    //Color y fondo del header
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = UIColor.blueColor()
        header.textLabel?.textColor = UIColor.whiteColor()
        
    
    }
   

    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0){
            
            return 40.0
        }
        
        return 0
        
    }
    
    //Para la celda seleccionada ponemos el tamaño de la celda
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 172.0
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0) {
        
        return model.getTags(forSection: section)
        
        }
        
        return model.getTitles(forSection: section)
    }
    
    
    
    //MARK: - Utilities
    
    func book(forIndexPath indexPath: NSIndexPath) -> HackerBook {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0) {
        
            return model.bookForTable(atIndex: indexPath.row, forTag: indexPath.section)
        }
       
        return model.bookForTableOrdered(atIndex: indexPath.row, forSect: indexPath.section)
    }
    
    
    
}


//MARK: - Protocols


protocol HackerBooksControllerDelegate {

    
    func hackerBooksViewController(vc: HackerBooksTableViewController, didSelectBook book: HackerBook)
    
    
}



//MARK: - Extensions

extension HackerBooksTableViewController {
    //Funcion que responde al cambio de segmento
    func reloadTable(){
        
        self.orderSelect.selectedSegmentIndex != self.orderSelect.selectedSegmentIndex

        self.tableView.reloadData()
        
    }

}


extension HackerBooksTableViewController {
 //Pertenece al comportamiento del switch de favoritos
    
    func bookAddFav (notification: NSNotification){
        
        let data = notification.userInfo!
        let keyFavorites = "Favorites"
        
        //Sacamos el libro de la notificacion
        let bookData : HackerBook = data["key"] as! HackerBook
        
        
        //Si dentro de donde almacenamos los tags no tenemos Favorites lo añadimos
        //y tambien al modelo de la vista
        if (model.tagsArray.contains(keyFavorites) == false){
            
            model.tagsArray.insert(keyFavorites, atIndex: 0)
            
            model.dict[keyFavorites]?.append(bookData)
            
            self.tableView.reloadData()
            
            
        } else {
            
            model.dict[keyFavorites]?.append(bookData)
           
            self.tableView.reloadData()
            
        }
        
    }

func bookRemoveFav (notification: NSNotification){
    
            let data = notification.userInfo!
            let keyFavorites = "Favorites"
    
            //Sacamos el libro de la notificacion
            let book = data["key"] as? HackerBook
    
            let favArray = model.dict[keyFavorites]
    
            let potision = favArray!.indexOf({$0.title == book!.title })
    
            model.dict[keyFavorites]?.removeAtIndex(potision!)
    
            book!.tags = book?.tags!.stringByReplacingOccurrencesOfString(", favorites", withString: "")
    
            self.tableView.reloadData()

                
     }
}

extension HackerBooksTableViewController {
    //Pertenece al guardado de favoritos
    
    
    
    func bookSaveFav(notification : NSNotification){
        
        let keyFavsSaved = "favsSaved"
        let keyFavorites  = "favorites"
        
        
        let defaults = NSUserDefaults.standardUserDefaults()
      
        let favContains = defaults.dictionaryForKey(keyFavsSaved)
    
        let data = notification.userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book!.title
        //comprobamos si ya existe el guardado
        
        if (favContains == nil) {
        
            let bookFavs = [keyFavorites : [bookTitle!]]
        
            defaults.setObject(bookFavs, forKey: keyFavsSaved)
        
        } else {
        
            var favsSaved = favContains![keyFavorites] as? Array<String>
            
            if(favsSaved?.contains(bookTitle!) == false){
            
                favsSaved?.append(bookTitle!)
            
                let bookFavs = [keyFavorites : favsSaved!]
            
                defaults.setObject(bookFavs, forKey: keyFavsSaved)
            }
            
        }
        
    }
    
    
    
    func bookDelFav(notification : NSNotification){
        
        let keyFavsSaved = "favsSaved"
        let keyFavorites  = "favorites"
        
        let defaults = NSUserDefaults.standardUserDefaults()
        
        let favContains = defaults.dictionaryForKey(keyFavsSaved)
        
        var favArrays = favContains![keyFavorites] as? Array<String>
        
        let data = notification.userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book?.title
        
        //Si esta dentro obtenemos la posicion y lo eliminamos
        if (favArrays?.contains(bookTitle!) == true ){
            
            let position = favArrays!.indexOf({$0 == bookTitle})
            
            favArrays?.removeAtIndex(position!)
            
            let favsSaved = [keyFavorites : favArrays!]
            
            defaults.setObject(favsSaved, forKey: keyFavsSaved)
            
        }
        
    }
    
    
    
    
}

    
    
    
    


























