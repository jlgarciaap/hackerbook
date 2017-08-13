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
        
        
        pdfView.load(obtainNSData(StringUrl: model.pdfUrl!) , mimeType: "application/pdf", textEncodingName: "utf-8", baseURL: (URL(string: model.pdfUrl!))!)
        
        
    }
    

    override func viewDidLoad() {
        
        //Vista por debajo del NavBar
        self.edgesForExtendedLayout = UIRectEdge()
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //Nos suscribimos a la notificacion del controlador de tabla
        let nCenter = NotificationCenter.default
        
        nCenter.addObserver(self, selector: #selector(bookDidChange), name: NSNotification.Name(rawValue: "BookChanged"), object: nil)
        
        
        syncModelWithView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        //Nos damos de baja de las notificaciones
        let nCenter = NotificationCenter.default
        
        nCenter.removeObserver(self)
    }
    
    //MARK: - UIViewDelegate
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //delegado del webView
        
        actView.stopAnimating()
        
        actView.hidesWhenStopped = true
    }


    //MARK: - Utilities
    
    func obtainNSData(StringUrl urlPdf: String) -> Data{
        
        let stringKey = (model.title! as String) + ".data"
    
        
        let downloadURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        let writeDownPath = downloadURL.appendingPathComponent(stringKey).path
    
        
        if((try? Data(contentsOf: URL(fileURLWithPath: writeDownPath))) == nil){
            
            
        let nsUrlCast = URL(string: urlPdf)!
        
        guard let dataURL : Data = try? Data(contentsOf: nsUrlCast) else {
            
            //Si por lo que sea la url no contiene datos mostramos una alerta
            
            let alertController = UIAlertController(title: "Surprise Error jeje", message: "The Dark Side has stolen this book, the Rebel Alliance will retrieve it. The force is with us", preferredStyle: UIAlertControllerStyle.alert)
            
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            
            return Data()
            }
            
            
            
            try? dataURL.write(to: URL(fileURLWithPath: writeDownPath), options: [.atomic])
        
            return dataURL
        }
        
        
        let dataURL = try? Data(contentsOf: URL(fileURLWithPath: writeDownPath))
        
        return dataURL!
        
    }
    
    func bookDidChange(_ notification: Notification){
        //Funcion para sacar el contenido de la notificacion
        
        let data = (notification as NSNotification).userInfo!
        
        //Sacamos el libro de la notificacion
        let book = data["key"] as? HackerBook
        
        //Actualizamos el modelo
        model = book!
        
        
        //Sincronicamos le cambio
        syncModelWithView()
        
        
        
    }
    
    

}
