
import Foundation
import UIKit

class HackerBook{
    
    
//    "authors": "Scott Chacon, Ben Straub",
//    "image_url": "http://hackershelf.com/media/cache/b4/24/b42409de128aa7f1c9abbbfa549914de.jpg",
//    "pdf_url": "https://progit2.s3.amazonaws.com/en/2015-03-06-439c2/progit-en.376.pdf",
//    "tags": "version control, git",
//    "title": "Pro Git"
    
    //MARK: - Properties
    
    let authors: String?
    let image: UIImage
    let pdfUrl: NSURL
    let tags: String?
    let title: String?
    
    
    //MARK: - Initialization
    
    init( authors: String?, image: UIImage, pdfUrl: NSURL, tags: String?, title: String?){
        
        self.authors = authors
        self.image = image
        self.pdfUrl = pdfUrl
        self.tags = tags
        self.title = title
        
        
    }
    
    
    
}

