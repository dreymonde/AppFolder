//
//  DirectorySpec.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
@testable import AppFolder

func makeDir<Dir : Directory>() -> Dir {
    let url = HomeFolder.baseURL
    return Dir(baseURL: url)
}

func testDirectory() {
    
    describe("Directory object") {
        $0.it("automatically generates name") {
            class John : Directory { }
            let john = makeDir() as John
            try expect(john.folderName) == "John"
        }
        $0.it("automatically generates name with whitespaces for type names with _") {
            class John_Doe : Directory { }
            let john = makeDir() as John_Doe
            try expect(john.folderName) == "John Doe"
        }
        $0.it("can provide a custom name") {
            class Henry : Directory {
                override var folderName: String { return "Henry Goals Collection" }
            }
            let henry = makeDir() as Henry
            try expect(henry.subpath) == "Henry Goals Collection"
        }
        $0.it("has a base url") {
            let directory = Directory(baseURL: HomeFolder.baseURL)
            try expect(directory.baseURL) == HomeFolder.baseURL
        }
        $0.it("dinamically adds a directory to a path") {
            class Movies : Directory {
                lazy var comedy = adding(Comedy.self)
                class Comedy : Directory { }
            }
            let movies = makeDir() as Movies
            let comedy = movies.comedy
            try expect(comedy.folderName) == "Comedy"
            try expect(comedy.previous.last!.folderName) == "Movies"
            try expect(comedy.previous.last!).to.beOfType(Movies.self)
        }
        $0.it("holds all previous directory objects") {
            let directory1 = Directory(baseURL: HomeFolder.baseURL)
            let directory2 = directory1.adding().adding() as Directory
            try expect(directory2.previous.count) == 2
        }
        $0.it("composes full subpath") {
            class Dir1 : Directory {
                class Dir2 : Directory {
                    class Dir3 : Directory { }
                    var dir3: Dir3 {
                        return adding()
                    }
                }
                var dir2: Dir2 {
                    return adding()
                }
            }
            let dir1 = makeDir() as Dir1
            let finalDir = dir1.dir2.dir3
            try expect(finalDir.subpath) == "Dir1/Dir2/Dir3"
        }
        $0.it("composes a full url") {
            class Music : Directory {
                lazy var beatles = self.adding(Beatles.self)
                class Beatles : Directory { }
            }
            let musicDir = makeDir() as Music
            let beatlesDir = musicDir.beatles
            let expectedBeatlesURL = HomeFolder.baseURL.appendingPathComponent("Music/Beatles", isDirectory: true)
            try expect(beatlesDir.url) == expectedBeatlesURL
        }
        $0.it("has an external URL initializer") {
            let directory = makeDir() as Directory
            let url = directory.url
            let extURL = URL(of: directory)
            try expect(extURL) == url
        }
    }
    
    describe("app folder") {
        $0.it("has a documents directory") {
            let documents = HomeFolder.Documents
            try expect(documents.subpath) == "Documents"
        }
        $0.it("has a library directory") {
            let library = HomeFolder.Library
            try expect(library.subpath) == "Library"
        }
        $0.it("has a tmp directory") {
            let tmp = HomeFolder.tmp
            try expect(tmp.subpath) == "tmp"
        }
        $0.it("has a caches directory") {
            let caches = HomeFolder.Library.Caches
            try expect(caches.subpath) == "Library/Caches"
        }
        $0.it("has an application support directory") {
            let applicationSupport = HomeFolder.Library.ApplicationSupport
            try expect(applicationSupport.subpath) == "Library/Application Support"
        }
    }
    
}
