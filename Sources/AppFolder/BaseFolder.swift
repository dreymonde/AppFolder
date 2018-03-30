//
//  BaseFolder.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

/// Protocol that define default methods of a Folder.
public protocol BaseFolder {
    
    /// Returns the base URL.
    static var baseURL: URL { get }
}

fileprivate typealias Lib = Library
fileprivate typealias Docs = Documents

extension BaseFolder {
    
    /**
     A reference to the library folder used by this file system.
     
     Example:
     ```
     let applicationSupport = AppFolder.Library.Application_Support
     let caches = AppFolder.Library.Caches
     ```
     */
    public static var Library: Library {
        return Lib(baseURL: baseURL)
    }

    /**
     A reference to the document folder used by this file system.
     
     # Important # 
      - Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, should be stored here and will be automatically backed up by iCloud. 
     */
    public static var Documents: Documents {
        return Docs(baseURL: baseURL)
    }
    
    #if os(iOS) || os(tvOS) || os(watchOS)
    /**
     A reference to the temporary folder used by this file system
     
     # Important #
     - Use this directory to write temporary files that do not need to persist between launches of your app. Your app should remove files from this directory when they are no longer needed however, the system may purge this directory when your app is not running.
     */
    public static var tmp: Temporary {
        return Temporary(baseURL: baseURL)
    }
    #endif
}

/**
 
 A Representation of a directories inside your app's container
 
 ````
 let documents = AppFolder.Documents
 let caches = AppFolder.Library.Caches
 let cachesURL = caches.url
 ````
 
 */ 
public enum AppFolder : BaseFolder {
    
    /// Returns the base URL.
    public static let baseURL: URL = {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        return url
    }()
    
}

/// Static representation of an app group identifier.
public protocol AppGroup {
    static var groupIdentifier: String { get }
}

public enum AppGroupContainer<Group : AppGroup> : BaseFolder {
    
    /// Returns the base URL.
    public static var baseURL: URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Group.groupIdentifier)!
    }
    
}
