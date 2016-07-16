//
//  HackerBookControllerViewController.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 8/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit

class HackerBookControllerViewController: UIViewController {
    
    //MARK: - Properties
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var authorsLabel: UILabel!
    
    @IBOutlet weak var favSwitch: UISwitch!
    
    
    @IBOutlet weak var tagsLabel: UILabel!
    
    
    @IBOutlet weak var tagsTitle: UILabel!
    
   
    

    var model: HackerBook
    
    init(model: HackerBook){
        
        self.model = model
        
        super.init(nibName:"HackerBookControllerViewController", bundle: nil)
        
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
        
            let favsSaved = defaults.dictionaryForKey("favsSaved")
        
            let bookFavsTitle = favsSaved?["favorites"] as? [String]
        
            if(bookFavsTitle?.contains(model.title!) == true){
            
                model.tags = model.tags! + ", favorites"
            
            }
        
            if((model.tags?.containsString("favorites")) == true){
                
                
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

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func stateChanged(switchState: UISwitch){
        
        let nCenter = NSNotificationCenter.defaultCenter()
        
        if switchState.on{
            
            
            
            let notif = NSNotification(name: "favChangedOn", object: self, userInfo: ["key": model])
            
            nCenter.postNotification(notif)
            
            model.tags = model.tags! + ", favorites"
            
            syncModelWithView()
            
            
            
        } else {
            
            let notif = NSNotification(name: "favChangedOff", object: self, userInfo: ["key": model])
            
            nCenter.postNotification(notif)
            
            model.tags = model.tags?.stringByReplacingOccurrencesOfString(", favorites", withString: "")
            syncModelWithView()
        }
        
        
        
    }
    

}

//MARK: - Delegate Subscription

extension HackerBookControllerViewController : HackerBooksControllerDelegate {
    
    func hackerBooksViewController(vc: HackerBooksTableTableViewController, didSelectBook book: HackerBook) {
        //Le indicamos que el modelo ahora es lo que le pasamos por paramtro
        model = book
        
        //Sincronizamos vista y model
        viewWillAppear(true)
        
        syncModelWithView()
        
    }
    
 
}

//MARK: - Protocols








