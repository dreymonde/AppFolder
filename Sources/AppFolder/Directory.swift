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
    
    open var folderName: String {
        return type(of: self).defaultFolderName
    }
    
    public final var subpath: String {
        return all.map({ $0.folderName }).joined(separator: "/")
    }
    
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
    
    public final func appending<Subdirectory : Directory>(_ subdirectory: Subdirectory.Type = Subdirectory.self) -> Subdirectory {
        return Subdirectory(baseURL: baseURL, previous: all)
    }
    
}

extension URL {
    
    public init(of directory: Directory) {
        self = directory.url
    }
    
}

public final class Library : Directory {
    
    public final class Caches : Directory { }
    public var Caches: Caches {
        return appending(Caches.self)
    }
    
    public final class Application_Support : Directory { }
    public var Application_Support: Application_Support {
        return appending(Application_Support.self)
    }
    
}

public final class Documents : Directory { }
public final class Temporary : Directory {
    public override var folderName: String {
        return "tmp"
    }
}
