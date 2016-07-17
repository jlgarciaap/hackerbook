//
//  HackerPdfViewController.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 10/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit
import Foundation

class HackerPdfViewController: UIViewController, UIWebViewDelegate {
    
    //MARK: - Properties
    
    var model: HackerBook
    
    
    @IBOutlet weak var pdfView: UIWebView!
    
    @IBOutlet weak var actView: UIActivityIndicatorView!
    
    
    //MARK: - Init
    init(model: HackerBook){
        
        self.model = model
        super.init(nibName: nil, bundle: nil)
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Sync
    
    func syncModelWithView() {
        
        pdfView.delegate = self
        
        actView.startAnimating()
        
        pdfView.loadData(obtainNSData(StringUrl: model.pdfUrl!) , MIMEType: "application/pdf", textEncodingName: "utf-8", baseURL: NSURL())
        
        
    }
    

    override func viewDidLoad() {
        
        //Vista por debajo del NavBar
        self.edgesForExtendedLayout = UIRectEdge.None
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        
        //Nos suscribimos a la notificacion del controlador de tabla
        let nCenter = NSNotificationCenter.defaultCenter()
        
        nCenter.addObserver(self, selector: #selector(bookDidChange), name: "BookChanged", object: nil)
        
        
        syncModelWithView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        
        //Nos damos de baja de las notificaciones
        let nCenter = NSNotificationCenter.defaultCenter()
        
        nCenter.removeObserver(self)
    }
    
    //MARK: - UIViewDelegate
    
    func webViewDidFinishLoad(webView: UIWebView) {
        //delegado del webView
        
        actView.stopAnimating()
        
        actView.hidesWhenStopped = true
    }


    //MARK: - Utilities
    
    func obtainNSData(StringUrl urlPdf: String) -> NSData{
        
        let stringKey = (model.title! as String) + ".data"
    
        
        let downloadURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        
        let writeDownPath = downloadURL.URLByAppendingPathComponent(stringKey).path!
    
        
        if(NSData(contentsOfFile: writeDownPath) == nil){
            
            
        let nsUrlCast = NSURL(string: urlPdf)!
        
        guard let dataURL : NSData = NSData(contentsOfURL: nsUrlCast) else {
            
            //Si por lo que sea la url no contiene datos mostramos una alerta
            
            let alertController = UIAlertController(title: "Surprise Error jeje", message: "The Dark Side has stolen this book, the Rebel Alliance will retrieve it. The force is with us", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
            return NSData()
            }
            
            
            
            dataURL.writeToFile(writeDownPath, atomically: true)
        
            return dataURL
        }
        
        
        let dataURL = NSData(contentsOfFile: writeDownPath)
        
        return dataURL!
        
    }
    
    func bookDidChange(notification: NSNotification){
        //Funcion para sacar el contenido de la notificacion
        
        let data = notification.userInfo!
        
        //Sacamos el libro de la notificacion
        let book = data["key"] as? HackerBook
        
        //Actualizamos el modelo
        model = book!
        
        
        //Sincronicamos le cambio
        syncModelWithView()
        
        
        
    }
    
    

}
