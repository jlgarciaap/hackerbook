
import Foundation
import UIKit

class HackerBook{
    
    
    //MARK: - Properties
    
    let authors: String?
    let image: UIImage
    let pdfUrl: String?
    var tags: String?
    let title: String?
        
    //MARK: - Initialization
    
    init( authors: String?, image: UIImage, pdfUrl: String?, tags: String?, title: String?){
        
        self.authors = authors
        self.image = image
        self.pdfUrl = pdfUrl
        self.tags = tags
        self.title = title
        
    }
    
}

