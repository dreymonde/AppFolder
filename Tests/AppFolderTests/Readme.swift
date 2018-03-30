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
    let cachesURL = AppFolder.Library.Caches.url
    let userCacheURL = cachesURL.appendingPathComponent("user-cache.json")
    let userCacheData = try Data(contentsOf: userCacheURL)
    print(userCacheData)
}

extension Documents {
    
    final class Photos : Directory { }
    
    var Photos: Photos {
        return subdirectory()
    }
    
}














extension Library.Caches {
    
    class Images: Directory { }
    var Images: Images {
        return subdirectory()
    }
    
}

extension Library.Application_Support {
    
    final class Files : Directory { }
    
    var Files: Files {
        return subdirectory()
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
