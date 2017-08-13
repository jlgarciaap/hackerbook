//
//  AppDelegate.swift
//  HackerBook
//
//  Created by Juan Luis Garcia on 8/7/16.
//  Copyright © 2016 styleapps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
     
        
        do{
            
            let documents = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
            
            let fileSavedPath = documents + "/hackerBooksData.json"
            
            guard let url = URL(string: "https://t.co/K9ziV0z3SJ") else {
                
                throw HackerBooksErrors.jsonParsingError
                
            }
            
            
            if(FileManager.default.fileExists(atPath: fileSavedPath) == false){
                let data = try! Data(contentsOf: url)
                
                
                let documentsPath = URL(fileURLWithPath: documents).appendingPathComponent("hackerBooksData.json")
                try? data.write(to: documentsPath, options: [])
            }
            
            
            let documentPath = URL(fileURLWithPath: documents).appendingPathComponent("hackerBooksData.json")
            let data = try? Data(contentsOf: documentPath)
            
        
        let jsonFile = try loadFromSaveFile(file: data!)
        
        var books = [HackerBook]()
        
            for dict in jsonFile{
                
                
                do{
                    
                    let book = try parsing(hackerBook: dict)
                    books.append(book)
                    
                } catch{
                    
                    print("Error al procesar JSON \(dict)")
                    
                    
                }
                
            }
            
          
            
            
       let model = HackerBooksGroup(hbooks: books)
        
       // let vc = HackerPdfViewController(model: hBook)
            
        window = UIWindow(frame: UIScreen.main.bounds)
        
        //let vc = HackerBookControllerViewController(model: model)
        
        let vc = HackerBooksTableViewController(model: model)
        
        let navTable = UINavigationController(rootViewController: vc)
            
        let book : HackerBook
                
        book = model.bookForTable(atIndex: 0, forTag: 1)
                
          
                
            
        //Creamos el elemento que se muestra por defecto cuando estamos en SPlit
            let bookVC = HackerBookViewController(model: book)
            
        //Asignamos el delegado. Es decir le indicamos al HackerBooksTableTableViewController quien es su delegado
            
            if UIDevice.current.userInterfaceIdiom.rawValue == 1{
            //Si es un IPAD el delegado es HackerBookCOntroller
                vc.delegate = bookVC
            }
            
            
            
        let navBook = UINavigationController(rootViewController: bookVC)
            
        //Creamos el SplitView
            
        let splitVC = UISplitViewController()
        splitVC.viewControllers = [navTable, navBook]
            
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = splitVC
        
        window?.makeKeyAndVisible()
        
        
        return true
            
        } catch {
            
            fatalError("Error while loading JSON")
            
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

