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
    
    @IBAction func readPDFButton(_ sender: AnyObject) {
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            let defaults = UserDefaults.standard
        
            //Comprobamos los favoritos guardados
            let favsSaved = defaults.dictionary(forKey: keyFavsSaved)
        
            let bookFavsTitle = favsSaved?[keyFavorites] as? [String]
        
            if(bookFavsTitle?.contains(model.title!) == true){
                
                //Controlamos para que no nos repita en la vista el favorites 
                //tag cada vez que pulsemos
                
                if((model.tags?.contains(keyFavorites)) == false){
                
                model.tags = model.tags! + ", \(keyFavorites)"
            
                }
            }
        
            if((model.tags?.contains(keyFavorites)) == true){
                
                
                favSwitch.isOn = true
                
            } else {
                
                favSwitch.isOn = false
                
            }
        
        
        syncModelWithView()
    }
    
    
    
    override func viewDidLoad() {
        
        //Vista por debajo del NavBar
        self.edgesForExtendedLayout = UIRectEdge()
        
        
        
        //Estados del Switch
        favSwitch.addTarget(self, action: #selector(stateChanged), for: UIControlEvents.valueChanged)
        
        
        super.viewDidLoad()

       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func stateChanged(_ switchState: UISwitch){
       
        //Mandamos notificacion cuando se marca o desmarca un elemento de favoritos
        //la recibimos en hackerBooksTableViewController
        
        let nCenter = NotificationCenter.default
        
        if switchState.isOn{
            
            let notif = Notification(name: Notification.Name(rawValue: "favChangedOn"), object: self, userInfo: ["key": model])
            
            nCenter.post(notif)
            
            model.tags = model.tags! + ", \(keyFavorites)"
            
        } else {
            
            let notif = Notification(name: Notification.Name(rawValue: "favChangedOff"), object: self, userInfo: ["key": model])
            
            nCenter.post(notif)
            
            model.tags = model.tags?.replacingOccurrences(of: ", \(keyFavorites)", with: "")
            
        }
        
        syncModelWithView()

        
    }
    

}

//MARK: - Delegate Subscription

extension HackerBookViewController : HackerBooksControllerDelegate {
    
    func hackerBooksViewController(_ vc: HackerBooksTableViewController, didSelectBook book: HackerBook) {
        //Le indicamos que el modelo ahora es lo que le pasamos por paramtro
        model = book
        
        //Sincronizamos vista y model
        viewWillAppear(true)
        
        syncModelWithView()
        
    }
    
 
}









