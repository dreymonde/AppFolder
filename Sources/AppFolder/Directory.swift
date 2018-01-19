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
    
    open var folderName: String {
        return type(of: self).defaultFolderName
    }
    
    public final var subpath: String {
        return all.map({ $0.folderName }).joined(separator: "/")
    }
    
    public final var url: URL {
        return baseURL.appendingPathComponent(subpath, isDirectory: true)
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
