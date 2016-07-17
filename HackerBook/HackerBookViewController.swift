//
//  HackerBookControllerViewController.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 8/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit



class HackerBookViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var favSwitch: UISwitch!
    
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    
    @IBOutlet weak var tagsTitle: UILabel!
    
    let keyFavsSaved = "favsSaved"
    let keyFavorites = "favorites"
    

    var model: HackerBook
    
    init(model: HackerBook){
        
        self.model = model
        
        super.init(nibName:"HackerBookViewController", bundle: nil)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @IBAction func readPDFButton(sender: AnyObject) {
        
        let readVC = HackerPdfViewController(model: model)
        navigationController?.pushViewController(readVC, animated: true)
        
    }

    
    
    //MARK: - Sync
    func syncModelWithView () {
        
        imageView.image = model.image
        authorsLabel.text = model.authors
        tagsLabel.text = model.tags
        tagsTitle.text = model.title
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
            let defaults = NSUserDefaults.standardUserDefaults()
        
            //Comprobamos los favoritos guardados
            let favsSaved = defaults.dictionaryForKey(keyFavsSaved)
        
            let bookFavsTitle = favsSaved?[keyFavorites] as? [String]
        
            if(bookFavsTitle?.contains(model.title!) == true){
                
                //Controlamos para que no nos repita en la vista el favorites 
                //tag cada vez que pulsemos
                
                if((model.tags?.containsString(keyFavorites)) == false){
                
                model.tags = model.tags! + ", \(keyFavorites)"
            
                }
            }
        
            if((model.tags?.containsString(keyFavorites)) == true){
                
                
                favSwitch.on = true
                
            } else {
                
                favSwitch.on = false
                
            }
        
        
        syncModelWithView()
    }
    
    
    
    override func viewDidLoad() {
        
        //Vista por debajo del NavBar
        self.edgesForExtendedLayout = UIRectEdge.None
        
        
        
        //Estados del Switch
        favSwitch.addTarget(self, action: #selector(stateChanged), forControlEvents: UIControlEvents.ValueChanged)
        
        
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func stateChanged(switchState: UISwitch){
       
        //Mandamos notificacion cuando se marca o desmarca un elemento de favoritos
        //la recibimos en hackerBooksTableViewController
        
        let nCenter = NSNotificationCenter.defaultCenter()
        
        if switchState.on{
            
            let notif = NSNotification(name: "favChangedOn", object: self, userInfo: ["key": model])
            
            nCenter.postNotification(notif)
            
            model.tags = model.tags! + ", \(keyFavorites)"
            
        } else {
            
            let notif = NSNotification(name: "favChangedOff", object: self, userInfo: ["key": model])
            
            nCenter.postNotification(notif)
            
            model.tags = model.tags?.stringByReplacingOccurrencesOfString(", \(keyFavorites)", withString: "")
            
        }
        
        syncModelWithView()

        
    }
    

}

//MARK: - Delegate Subscription

extension HackerBookViewController : HackerBooksControllerDelegate {
    
    func hackerBooksViewController(vc: HackerBooksTableViewController, didSelectBook book: HackerBook) {
        //Le indicamos que el modelo ahora es lo que le pasamos por paramtro
        model = book
        
        //Sincronizamos vista y model
        viewWillAppear(true)
        
        syncModelWithView()
        
    }
    
 
}









