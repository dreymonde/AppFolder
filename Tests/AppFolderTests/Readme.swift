//
//  Readme.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
import AppFolder

extension Library.Caches {
    
    class Images: Directory { }
    var images: Images {
        return adding()
    }
    
}

#if os(iOS)
    func readme() {
        let cachesURL = AppFolder.library.caches.url
        let documentsURL = AppFolder.documents.url
        print(cachesURL, documentsURL)
        
        let imagesCacheURL = AppFolder.library.caches.images.url
        print(imagesCacheURL)
    }
#endif
