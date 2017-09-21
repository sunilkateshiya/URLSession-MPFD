//
//  Media.swift
//  URLSession:MPFD
//
//  Created by Administrator on 9/20/17.
//  Copyright © 2017 zerones. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimiType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimiType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpege"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
        
        
    }
    
}
