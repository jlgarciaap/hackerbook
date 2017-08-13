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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let nCenter = NotificationCenter.default
        
        nCenter.addObserver(self, selector: #selector(bookAddFav), name: NSNotification.Name(rawValue: "favChangedOn"), object: nil)
        nCenter.addObserver(self, selector: #selector(bookRemoveFav), name: NSNotification.Name(rawValue: "favChangedOff"), object: nil)
        nCenter.addObserver(self, selector: #selector(bookSaveFav), name: NSNotification.Name(rawValue: "favChangedOn"), object: nil)
        nCenter.addObserver(self, selector: #selector(bookDelFav), name: NSNotification.Name(rawValue: "favChangedOff"), object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        let center = NotificationCenter.default
        center.removeObserver(self)
    }
      
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //Registramos celda personalizada
        self.tableView.register(UINib(nibName:"HackerBooksCellView", bundle: nil), forCellReuseIdentifier: "HackerBooksCellView")

        
        self.orderSelect.selectedSegmentIndex = 0
        
        self.navigationItem.titleView = self.orderSelect
        //Controlamos los cambios en el selector
        self.orderSelect.addTarget(self, action: #selector(reloadTable), for: .valueChanged)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Averiguamos el libro
        let bookSelect = book(forIndexPath: indexPath)
        
        //avisamos al delegado del cambio
        delegate?.hackerBooksViewController(self, didSelectBook: bookSelect)
        
        //Lo mismo por notificaciones
        let nCenter = NotificationCenter.default
        
        let notif = Notification(name: Notification.Name(rawValue: "BookChanged"), object: self, userInfo: ["key": bookSelect])
        
        nCenter.post(notif)
        
        //Para movernos cuando es Iphone
        //raw value 0 iphone en raw value 1 ipad
        if (UIDevice.current.userInterfaceIdiom.rawValue == 0){
            
            let bookVC = HackerBookViewController(model: bookSelect)
            navigationController?.pushViewController(bookVC, animated: true)
        }
        
        
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if(self.orderSelect.selectedSegmentIndex == 0){
        
         return model.tagsArray.count
        }
        
        return model.booksTitles.count
        
        
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        //Numero de filas por seccion.
        //Es decir cuantos elementos por tag
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0){
            
            return model.booksForTagCount(forTags: section)
        }
        
        return model.booksForSectionOrdered(forSect: section)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellId = "HackerBooksCellView"
        
        let book : HackerBook
        
        if(self.orderSelect.selectedSegmentIndex == 0){
        
            book = model.bookForTable(atIndex: (indexPath as NSIndexPath).row, forTag: (indexPath as NSIndexPath).section)
        
        } else {
        
            book = model.bookForTableOrdered(atIndex: (indexPath as NSIndexPath).row, forSect: (indexPath as NSIndexPath).section)         
        }
        
        //Celda personalizada
        let cell : HackerBooksCellView = tableView.dequeueReusableCell(withIdentifier: cellId) as! HackerBooksCellView
        
        cell.authorsLabel.text = book.authors
        cell.ImageView?.image = book.image
        cell.titleLabel.text = book.title
        cell.titleLabel.textColor = UIColor.white
        cell.titleLabel.backgroundColor = UIColor.lightGray
        
        return cell
        
    }
    
    
    //Color y fondo del header
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header : UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.contentView.backgroundColor = UIColor.blue
        header.textLabel?.textColor = UIColor.white
        
    
    }
   

    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0){
            
            return 40.0
        }
        
        return 0
        
    }
    
    //Para la celda seleccionada ponemos el tamaño de la celda
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 172.0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0) {
        
        return model.getTags(forSection: section)
        
        }
        
        return model.getTitles(forSection: section)
    }
    
    
    
    //MARK: - Utilities
    
    func book(forIndexPath indexPath: IndexPath) -> HackerBook {
        
        //Segun el segment seleccionado devolvemos una cosa u otra
        if (self.orderSelect.selectedSegmentIndex == 0) {
        
            return model.bookForTable(atIndex: (indexPath as NSIndexPath).row, forTag: (indexPath as NSIndexPath).section)
        }
       
        return model.bookForTableOrdered(atIndex: (indexPath as NSIndexPath).row, forSect: (indexPath as NSIndexPath).section)
    }
    
    
    
}


//MARK: - Protocols


protocol HackerBooksControllerDelegate {

    
    func hackerBooksViewController(_ vc: HackerBooksTableViewController, didSelectBook book: HackerBook)
    
    
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
    
    func bookAddFav (_ notification: Notification){
        
        let data = (notification as NSNotification).userInfo!
        let keyFavorites = "Favorites"
        
        //Sacamos el libro de la notificacion
        let bookData : HackerBook = data["key"] as! HackerBook
        
        
        //Si dentro de donde almacenamos los tags no tenemos Favorites lo añadimos
        //y tambien al modelo de la vista
        if (model.tagsArray.contains(keyFavorites) == false){
            
            model.tagsArray.insert(keyFavorites, at: 0)
            
            model.dict[keyFavorites]?.append(bookData)
            
            self.tableView.reloadData()
            
            
        } else {
            
            model.dict[keyFavorites]?.append(bookData)
           
            self.tableView.reloadData()
            
        }
        
    }

func bookRemoveFav (_ notification: Notification){
    
            let data = (notification as NSNotification).userInfo!
            let keyFavorites = "Favorites"
    
            //Sacamos el libro de la notificacion
            let book = data["key"] as? HackerBook
    
            let favArray = model.dict[keyFavorites]
    
            let potision = favArray!.index(where: {$0.title == book!.title })
    
            model.dict[keyFavorites]?.remove(at: potision!)
    
            book!.tags = book?.tags!.replacingOccurrences(of: ", favorites", with: "")
    
            self.tableView.reloadData()

                
     }
}

extension HackerBooksTableViewController {
    //Pertenece al guardado de favoritos
    
    
    
    func bookSaveFav(_ notification : Notification){
        
        let keyFavsSaved = "favsSaved"
        let keyFavorites  = "favorites"
        
        
        let defaults = UserDefaults.standard
      
        let favContains = defaults.dictionary(forKey: keyFavsSaved)
    
        let data = (notification as NSNotification).userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book!.title
        //comprobamos si ya existe el guardado
        
        if (favContains == nil) {
        
            let bookFavs = [keyFavorites : [bookTitle!]]
        
            defaults.set(bookFavs, forKey: keyFavsSaved)
        
        } else {
        
            var favsSaved = favContains![keyFavorites] as? Array<String>
            
            if(favsSaved?.contains(bookTitle!) == false){
            
                favsSaved?.append(bookTitle!)
            
                let bookFavs = [keyFavorites : favsSaved!]
            
                defaults.set(bookFavs, forKey: keyFavsSaved)
            }
            
        }
        
    }
    
    
    
    func bookDelFav(_ notification : Notification){
        
        let keyFavsSaved = "favsSaved"
        let keyFavorites  = "favorites"
        
        let defaults = UserDefaults.standard
        
        let favContains = defaults.dictionary(forKey: keyFavsSaved)
        
        var favArrays = favContains![keyFavorites] as? Array<String>
        
        let data = (notification as NSNotification).userInfo!
        
        let book = data["key"] as? HackerBook
        
        let bookTitle = book?.title
        
        //Si esta dentro obtenemos la posicion y lo eliminamos
        if (favArrays?.contains(bookTitle!) == true ){
            
            let position = favArrays!.index(where: {$0 == bookTitle})
            
            favArrays?.remove(at: position!)
            
            let favsSaved = [keyFavorites : favArrays!]
            
            defaults.set(favsSaved, forKey: keyFavsSaved)
            
        }
        
    }
    
    
    
    
}

    
    
    
    


























