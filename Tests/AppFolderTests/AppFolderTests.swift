//
//  AppFolderTests.swift
//  AppFolder
//
//  Created by Oleg Dreyman on 1/18/18.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation
import XCTest
@testable import AppFolder

class Alba : Directory {
    
    class Belba : Directory { }
    
}

class AppFolderTests: XCTestCase {
    
    func testExample() {
        let url = URL.init(string: "https://github.com/")!
        let b = Alba.Belba(baseURL: url)
        print(b.folderName)        
    }
    
    func testApplicationSupport() {
        let applicationSupport = AppFolder.library.application_support.url
        print(applicationSupport)
    }
    
    static var allTests = [
        ("testExample", testExample),
    ]
}
