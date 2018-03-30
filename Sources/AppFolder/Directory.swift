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

open class DynamicDirectory {
    
    /// Returns the base URL.
    public final let baseURL: URL
    public final let previous: [DynamicDirectory]
    
    internal final var all: [DynamicDirectory] {
        return previous + [self]
    }
    
    public init(baseURL: URL, previous: [DynamicDirectory] = []) {
        self.baseURL = baseURL
        self.previous = previous
    }
    
    internal static var defaultFolderName: String {
        let className = String.init(describing: self)
        return fixedClassName(className)
            .components(separatedBy: "_")
            .joined(separator: " ")
    }
    
    /** 
     Returns the folder name according to their real world names.
     
     - For example: class User_Files -> User Files
     */
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
    
}

open class CustomDirectory : DynamicDirectory {
    
    public init(name: String, baseURL: URL, previous: [DynamicDirectory] = []) {
        self._folderName = name
        super.init(baseURL: baseURL, previous: previous)
    }
    
    private let _folderName: String
    open override var folderName: String {
        return _folderName
    }
    
}

extension DynamicDirectory {
    
    public func appending(_ folderName: String) -> CustomDirectory {
        return CustomDirectory(name: folderName, baseURL: baseURL, previous: all)
    }
    
}

open class Directory : DynamicDirectory {
    
    public required override init(baseURL: URL, previous: [DynamicDirectory] = []) {
        super.init(baseURL: baseURL, previous: previous)
    }
    
    public final func appending<Subdirectory : Directory>(_ subdirectory: Subdirectory.Type) -> Subdirectory {
        return Subdirectory(baseURL: baseURL, previous: all)
    }
    
    public final func subdirectory<Subdirectory : Directory>() -> Subdirectory {
        return appending(Subdirectory.self)
    }
    
}

extension URL {
    
    public init(of directory: Directory) {
        self = directory.url
    }
    
}

/// Class that represents a Library directory
public final class Library : Directory {
    
    /// Class that represents a caches directory
    public final class Caches : Directory { }
    
    /**
     A reference to the cache folder used by this file system.
     
     # Important #
      - Data that can be downloaded again or regenerated should be stored here. Examples of files you should put in the Caches directory include database cache files and downloadable content, such as that used by magazine, newspaper, and map applications.
     */
    public var Caches: Caches {
        return subdirectory()
    }
    
    /// Class that represents Application Support directory
    public final class Application_Support : Directory { }
    
    /**
     A reference to the application support folder used by this file system.
     
     # Important #
     - The Application Support directory is a good place to store files that might be in your Documents directory but that shouldn't be seen by users. For example, a database that your app needs but that the user would never open manually.
     */
    public var Application_Support: Application_Support {
        return subdirectory()
    }
    
}

/// Class that represents Documents directory
public final class Documents : Directory { }

#if os(iOS) || os(tvOS) || os(watchOS)
    
    /// Class that represents Temporary directory
    public final class Temporary : Directory {
        public override var folderName: String {
            return "tmp"
        }
    }

#endif
