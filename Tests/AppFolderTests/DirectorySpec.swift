//
//  DirectorySpec.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
@testable import AppFolder

func makeDirectory<Dir : Directory>() -> Dir {
    let url = AppFolder.baseURL
    return Dir(baseURL: url)
}

func testDirectory() {
    
    describe("Directory object") {
        $0.it("automatically generates name") {
            class John : Directory { }
            let john = makeDirectory() as John
            try expect(john.folderName) == "John"
        }
        $0.it("automatically generates name with whitespaces for type names with _") {
            class John_Doe : Directory { }
            let john = makeDirectory() as John_Doe
            try expect(john.folderName) == "John Doe"
        }
        $0.it("can provide a custom name") {
            class Henry : Directory {
                override var folderName: String { return "Henry Goals Collection" }
            }
            let henry = makeDirectory() as Henry
            try expect(henry.subpath) == "Henry Goals Collection"
        }
        $0.it("has a base url") {
            let directory = Directory(baseURL: AppFolder.baseURL)
            try expect(directory.baseURL) == AppFolder.baseURL
        }
        $0.it("dinamically adds a directory to a path") {
            class Movies : Directory {
                lazy var comedy = appending(Comedy.self)
                class Comedy : Directory { }
            }
            let movies = makeDirectory() as Movies
            let comedy = movies.comedy
            try expect(comedy.folderName) == "Comedy"
            try expect(comedy.previous.last!.folderName) == "Movies"
            try expect(comedy.previous.last!).to.beOfType(Movies.self)
        }
        $0.it("holds all previous directory objects") {
            let directory1 = Directory(baseURL: AppFolder.baseURL)
            let directory2 = directory1.appending(Directory.self).appending(Directory.self)
            try expect(directory2.previous.count) == 2
        }
        $0.it("composes full subpath") {
            class Dir1 : Directory {
                class Dir2 : Directory {
                    class Dir3 : Directory { }
                    var dir3: Dir3 {
                        return appending(Dir3.self)
                    }
                }
                var dir2: Dir2 {
                    return appending(Dir2.self)
                }
            }
            let dir1 = makeDirectory() as Dir1
            let finalDir = dir1.dir2.dir3
            try expect(finalDir.subpath) == "Dir1/Dir2/Dir3"
        }
        $0.it("composes a full url") {
            class Music : Directory {
                lazy var beatles = self.appending(Beatles.self)
                class Beatles : Directory { }
            }
            let musicDir = makeDirectory() as Music
            let beatlesDir = musicDir.beatles
            let expectedBeatlesURL = AppFolder.baseURL.appendingPathComponent("Music/Beatles", isDirectory: true)
            try expect(beatlesDir.url) == expectedBeatlesURL
        }
        $0.it("has an external URL initializer") {
            let directory = makeDirectory() as Directory
            let url = directory.url
            let extURL = URL(of: directory)
            try expect(extURL) == url
        }
    }
    
    describe("custom directory") {
        $0.it("can be provided with a name in runtime") {
            let customDir = CustomDirectory(name: "Custom", baseURL: AppFolder.baseURL, previous: [])
            try expect(customDir.folderName) == "Custom"
        }
        $0.it("can be created from another directory") {
            let customDir = AppFolder.Library.application_Support.appending("Custom")
            try expect(customDir).to.beOfType(CustomDirectory.self)
            try expect(customDir.subpath) == "Library/Application Support/Custom"
            try expect(customDir.folderName) == "Custom"
        }
    }
    
    describe("dynamic directory") {
        $0.it("can be subclassed to create customizable directory") {
            let user5 = AppFolder.Library.application_Support.User(id: 5)
            try expect(user5.folderName) == "User-5"
            try expect(user5.subpath) == "Library/Application Support/User-5"
            try expect(user5).to.beOfType(UserIDDirectory.self)
        }
    }
    
    describe("app folder") {
        $0.it("has a documents directory") {
            let documents = AppFolder.Documents
            try expect(documents.subpath) == "Documents"
        }
        $0.it("has a library directory") {
            let library = AppFolder.Library
            try expect(library.subpath) == "Library"
        }
        #if !os(macOS)
            $0.it("has a tmp directory") {
                let tmp = AppFolder.tmp
                try expect(tmp.subpath) == "tmp"
            }
        #endif
        $0.it("has a caches directory") {
            let caches = AppFolder.Library.caches
            try expect(caches.subpath) == "Library/Caches"
        }
        $0.it("has an application support directory") {
            let applicationSupport = AppFolder.Library.application_Support
            try expect(applicationSupport.subpath) == "Library/Application Support"
        }
    }
    
}

final class UserIDDirectory : DynamicDirectory {
    let userID: Int
    init(userID: Int, baseURL: URL, previous: [DynamicDirectory]) {
        self.userID = userID
        super.init(baseURL: baseURL, previous: previous)
    }
    override var folderName: String {
        return "User-\(userID)"
    }
}
extension Library.Application_Support {
    func User(id: Int) -> UserIDDirectory {
        return UserIDDirectory(userID: id, baseURL: baseURL, previous: previous + [self])
    }
}
