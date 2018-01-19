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
    var Images: Images {
        return adding()
    }
    
}

func readme() {
    #if os(iOS)
        let cachesURL = AppFolder.Library.Caches.url
        let documentsURL = AppFolder.Documents.url
        print(cachesURL, documentsURL)
        
        let imagesCacheURL = AppFolder.Library.Caches.Images.url
        print(imagesCacheURL)
    #endif
}

