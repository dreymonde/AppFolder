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
        return appending(Images.self)
    }
    
}

extension Library.Application_Support {
    
    final class Files : Directory { }
    
    var Files: Files {
        return appending()
    }
    
}

enum MyAppGroup : AppGroup {
    static var groupIdentifier: String {
        return "group.com.your-app.your-app-group"
    }
}

func readme() {
    let cachesURL = AppFolder.Library.Caches.url
    let documentsURL = AppFolder.Documents.url
    print(cachesURL, documentsURL)
    
    let imagesCacheURL = AppFolder.Library.Caches.Images.url
    print(imagesCacheURL)
    
    typealias Files = Library.Application_Support.Files
    let filesFolder = AppFolder.Library.Application_Support.appending(Files.self)
    let sharedCaches = AppGroupContainer<MyAppGroup>.Library.Caches
    
    print(filesFolder, sharedCaches)
}

final class CustomNamedFolder : Directory {
    override var folderName: String {
        return "Whatever"
    }
}
