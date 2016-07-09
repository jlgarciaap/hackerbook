

import Foundation

extension NSBundle{
    
    //Deberia confirmar que tenemos cosas dentro de cada opcional
    func URLForResource(name: String?) -> NSURL?{

    let components = name?.componentsSeparatedByString(".")
    let fileTitle = components?.first
    let fileExtension = components?.last
        
        return URLForResource(fileTitle, withExtension: fileExtension)
    
    }
    
}