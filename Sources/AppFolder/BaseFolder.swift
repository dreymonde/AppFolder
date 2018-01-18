//
//  BaseFolder.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

public protocol BaseFolder {
    
    static var baseURL: URL { get }
    
}

extension BaseFolder {
    
    public static var library: Library {
        return Library(baseURL: baseURL)
    }
    
    public static var documents: Documents {
        return Documents(baseURL: baseURL)
    }
    
    public static var tmp: Temporary {
        return Temporary(baseURL: baseURL)
    }
    
}

public enum HomeFolder : BaseFolder {
    
    public static let baseURL: URL = {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        print("BASE URL:", url)
        return url
    }()
    
}

#if os(iOS) || os(tvOS) || os(watchOS)
    public typealias AppFolder = HomeFolder
#endif

public protocol AppGroup {
    
    static var groupIdentifier: String { get }
    
}

public final class AppGroupContainer<Group : AppGroup> : BaseFolder {
    
    public static var baseURL: URL {
       return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Group.groupIdentifier)!
    }
    
}
