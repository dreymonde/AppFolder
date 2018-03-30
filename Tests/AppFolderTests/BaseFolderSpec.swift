//
//  BaseFolderSpec.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
@testable import AppFolder

func testBaseFolder() {
    
    describe("base folder") {
        enum TestBaseFolder : BaseFolder {
            static var baseURL: URL {
                return URL.init(fileURLWithPath: "/usr/local/bin/")
            }
        }
        $0.it("has a library folder") {
            let library = TestBaseFolder.Library
            try expect(library.baseURL) == TestBaseFolder.baseURL
            try expect(library).to.beOfType(Library.self)
        }
        #if !os(macOS)
            $0.it("has a tmp folder") {
                let tmp = TestBaseFolder.tmp
                try expect(tmp.baseURL) == TestBaseFolder.baseURL
                try expect(tmp).to.beOfType(Temporary.self)
            }
        #endif
        $0.it("has s documents folder") {
            let documents = TestBaseFolder.Documents
            try expect(documents.baseURL) == TestBaseFolder.baseURL
            try expect(documents).to.beOfType(Documents.self)
        }
        $0.it("has a caches folder") {
            let caches = TestBaseFolder.Library.caches
            try expect(caches.baseURL) == TestBaseFolder.baseURL
            try expect(caches).to.beOfType(Library.Caches.self)
        }
        $0.it("has an application support folder") {
            let support = TestBaseFolder.Library.application_Support
            try expect(support.baseURL) == TestBaseFolder.baseURL
            try expect(support).to.beOfType(Library.Application_Support.self)
        }
    }
    
    describe("home folder") {
        $0.it("is located in home directory") {
            let homeURL = AppFolder.baseURL
            try expect(homeURL.path) == NSHomeDirectory()
        }
    }
    
    describe("app folder") {
        
        func systemLocations(for searchPathDirectory: FileManager.SearchPathDirectory) -> (fileManager: URL, nsSearchPathForDirectoriesInDomains: String) {
            let url = FileManager.default.urls(for: searchPathDirectory, in: .userDomainMask)[0]
            let path = NSSearchPathForDirectoriesInDomains(searchPathDirectory, .userDomainMask, true)[0]
            return (fileManager: url, nsSearchPathForDirectoriesInDomains: path)
        }
        
        func check(directory: Directory, for searchPathDirectory: FileManager.SearchPathDirectory) throws {
            let (url, path) = systemLocations(for: searchPathDirectory)
            try expect(directory.url) == url
            try expect(directory.url.path) == path
        }
        
        $0.it("documents directory is located at the right place") {
            try check(directory: AppFolder.Documents, for: .documentDirectory)
        }
        $0.it("caches directory is located at the right place") {
            try check(directory: AppFolder.Library.caches, for: .cachesDirectory)
        }
        $0.it("application support directory is located at the right place") {
            try check(directory: AppFolder.Library.application_Support, for: .applicationSupportDirectory)
        }
        $0.it("library directory is located at the right place") {
            try check(directory: AppFolder.Library, for: .libraryDirectory)
        }
        #if os(iOS) || os(tvOS)
        $0.it("temporary directory is located at the right place") {
            let appFolderTmpURL = AppFolder.tmp.url
            let systemTmpPath = NSTemporaryDirectory()
            let systemTmpURL = URL.init(fileURLWithPath: systemTmpPath)
            try expect(appFolderTmpURL) == systemTmpURL
        }
        #endif
    }
    
}
