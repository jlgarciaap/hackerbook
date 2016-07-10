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
    
    
    @IBAction func favButton(sender: UIBarButtonItem) {
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
        
        syncModelWithView()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//MARK: - Delegate Subscription

extension HackerBookControllerViewController : HackerBooksControllerDelegate {
    
    func hackerBooksViewController(vc: HackerBooksTableTableViewController, didSelectBook book: HackerBook) {
        //Le indicamos que el modelo ahora es lo que le pasamos por paramtro
        model = book
        
        //Sincronizamos vista y model
        
        syncModelWithView()
        
    }
    
 
}








