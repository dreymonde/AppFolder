//
//  AppFolder.swift
//  AppFolder
//
//  Created by Oleg Dreyman on 1/18/18.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

open class Directory {
    
    public let baseURL: URL
    public final let previous: [Directory]
    
    private var all: [Directory] {
        return previous + [self]
    }
    
    required public init(baseURL: URL, previous: [Directory] = []) {
        self.baseURL = baseURL
        self.previous = previous
    }
    
    open var folderName: String {
        return String.init(describing: type(of: self)).components(separatedBy: "_").joined(separator: " ")
    }
    
    public final var subpath: String {
        return all.map({ $0.folderName }).joined(separator: "/")
    }
    
    public var url: URL {
        return baseURL.appendingPathComponent(subpath, isDirectory: true)
    }
    
    func adding<Subdirectory : Directory>(subpath: Subdirectory.Type = Subdirectory.self) -> Subdirectory {
        return Subdirectory(baseURL: baseURL, previous: all)
    }
    
}

public final class Library : Directory {
    
    public final class Caches : Directory { }
    public var caches: Caches {
        return adding()
    }
    
    public final class Application_Support : Directory { }
    public var application_support: Application_Support {
        return adding()
    }
    
}

public final class Documents : Directory { }
public final class Temporary : Directory {
    public override var folderName: String {
        return "tmp"
    }
}
