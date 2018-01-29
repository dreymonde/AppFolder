//
//  AppFolder.swift
//  AppFolder
//
//  Created by Oleg Dreyman on 1/18/18.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

fileprivate func fixedClassName(_ classname: String) -> String {
    // check out SR-6787 for more
    return classname.components(separatedBy: " ")[0]
}

open class Directory {
    
    /// Returns the base URL.
    public final let baseURL: URL
    public final let previous: [Directory]
    
    private final var all: [Directory] {
        return previous + [self]
    }
    
    required public init(baseURL: URL, previous: [Directory] = []) {
        self.baseURL = baseURL
        self.previous = previous
    }
    
    internal static var defaultFolderName: String {
        let className = String.init(describing: self)
        return fixedClassName(className)
            .components(separatedBy: "_")
            .joined(separator: " ")
    }
    
    /// Returns the folder name according to their real world names.
    ///
    /// For example: class User_Files -> User Files
    open var folderName: String {
        return type(of: self).defaultFolderName
    }
    
    /// Returns full subpath of your folder.
    public final var subpath: String {
        return all.map({ $0.folderName }).joined(separator: "/")
    }
    
    /// Returns the folder url.
    public final var url: URL {
        return baseURL.appendingPathComponent(subpath, isDirectory: true)
    }
    
    /// Append an Directory to parents Directory
    public final func appending<Subdirectory: Directory>(_ subdirectory: Subdirectory.Type = Subdirectory.self) -> Subdirectory {
        return Subdirectory(baseURL: baseURL, previous: all)
    }
    
}

extension URL {
    
    public init(of directory: Directory) {
        self = directory.url
    }
    
}

/// Class that represents a Library directory
public final class Library: Directory {
    
    /// Class that represents a caches directory
    public final class Caches: Directory { }
    
    /// A reference to the cache folder used by this file system.
    ///
    /// Data that can be downloaded again or regenerated should be stored here. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications. 
    public var Caches: Caches {
        return appending(Caches.self)
    }
    
    /// Class that represents Application Support directory
    public final class Application_Support: Directory { }
    
    /// A reference to the application support folder used by this file system.
    /// 
    /// The Application Support directory is a good place to store files that might be in your Documents directory but that shouldn't be seen by users. For example, a database that your app needs but that the user would never open manually.
    public var Application_Support: Application_Support {
        return appending(Application_Support.self)
    }
    
}

/// Class that represents Documents directory
public final class Documents: Directory { }

/// Class that represents Temporary directory
public final class Temporary: Directory {
    public override var folderName: String {
        NSTemporaryDirectory()
        return "tmp"
    }
}
