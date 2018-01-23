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

fileprivate typealias Lib = Library
fileprivate typealias Docs = Documents

extension BaseFolder {
    
    public static var Library: Library {
        return Lib(baseURL: baseURL)
    }
    
    public static var Documents: Documents {
        return Docs(baseURL: baseURL)
    }
    
    public static var tmp: Temporary {
        return Temporary(baseURL: baseURL)
    }
    
}

public enum AppFolder : BaseFolder {
    
    public static let baseURL: URL = {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        return url
    }()
    
}

public protocol AppGroup {
    
    static var groupIdentifier: String { get }
    
}

public final class AppGroupContainer<Group : AppGroup> : BaseFolder {
    
    public static var baseURL: URL {
       return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Group.groupIdentifier)!
    }
    
}
