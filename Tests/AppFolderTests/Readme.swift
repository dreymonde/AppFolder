//
//  Readme.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
import AppFolder

func showcase() throws {
    let cachesURL = AppFolder.Library.caches.url
    let userCacheURL = cachesURL.appendingPathComponent("user-cache.json")
    let userCacheData = try Data(contentsOf: userCacheURL)
    print(userCacheData)
}

extension Documents {
    
    final class Photos : Directory { }
    
    var photos: Photos {
        return appending(Photos.self)
    }
    
}














extension Library.Caches {
    
    class Images: Directory { }
    var images: Images {
        return appending(Images.self)
    }
    
}

extension Library.Application_Support {
    
    final class Files : Directory { }
    
    var files: Files {
        return appending()
    }
    
}

enum MyAppGroup : AppGroup {
    static var groupIdentifier: String {
        return "group.com.your-app.your-app-group"
    }
}

final class CustomNamedFolder : Directory {
    override var folderName: String {
        return "Whatever"
    }
}
