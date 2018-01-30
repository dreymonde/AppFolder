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
    
    /// A reference to the library folder used by this file system.
    public static var Library: Library {
        return Lib(baseURL: baseURL)
    }
    
    /// A reference to the document folder used by this file system.
    ///
    /// Only documents and other data that is user-generated, or that cannot otherwise be recreated by your application, 
    /// should be stored here and will be automatically backed up by iCloud.
    public static var Documents: Documents {
        return Docs(baseURL: baseURL)
    }
    
    #if os(iOS) || os(tvOS) || os(watchOS)
    /// A reference to the temporary folder used by this file system
    ///
    /// Use this directory to write temporary files that do not need to persist between launches of your app. 
    /// Your app should remove files from this directory when they are no longer needed
    /// however, the system may purge this directory when your app is not running.
    public static var tmp: Temporary {
    return Temporary(baseURL: baseURL)
    }
    #elseif os(macOS)
    @available(*, deprecated, message: "AppFolder.tmp is unavailable on macOS")
    public static var tmp: Temporary {
        return Temporary(baseURL: baseURL)
    }
    #endif
    
}

public enum AppFolder: BaseFolder {
    
    /// Returns the base URL.
    public static let baseURL: URL = {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        return url
    }()
    
}

public protocol AppGroup {
    static var groupIdentifier: String { get }
}

public final class AppGroupContainer<Group: AppGroup>: BaseFolder {
    
    public static var baseURL: URL {
        return FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: Group.groupIdentifier)!
    }
    
}
