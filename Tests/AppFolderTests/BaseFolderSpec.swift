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
        $0.it("has a tmp folder") {
            let tmp = TestBaseFolder.tmp
            try expect(tmp.baseURL) == TestBaseFolder.baseURL
            try expect(tmp).to.beOfType(Temporary.self)
        }
        $0.it("has s documents folder") {
            let documents = TestBaseFolder.Documents
            try expect(documents.baseURL) == TestBaseFolder.baseURL
            try expect(documents).to.beOfType(Documents.self)
        }
    }
    
    describe("home folder") {
        $0.it("is located in home directory") {
            let homeURL = HomeFolder.baseURL
            try expect(homeURL.path) == NSHomeDirectory()
        }
    }
    
}
