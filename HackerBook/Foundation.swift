

import Foundation

extension Bundle{
    
    
    func URLForResource(_ name: String?) -> URL?{

    let components = name?.components(separatedBy: ".")
    let fileTitle = components?.first
    let fileExtension = components?.last
        
        return url(forResource: fileTitle, withExtension: fileExtension)
    
    }
    
    
}

