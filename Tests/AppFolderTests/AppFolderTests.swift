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
    
    func testAppFolder() {
        testDirectory()
        testBaseFolder()
        testUsageScenario()
    }
    
}

extension Library.Application_Support {
    
    final class CoreData : Directory { }
    var coreData: CoreData {
        return adding()
    }
    
}

extension Library.Caches {
    
    final class Images_Cache : Directory { }
    var imagesCache: Images_Cache {
        return adding()
    }
    
}

func testUsageScenario() {
    describe("typical usage") {
        $0.it("adding a folder inside Application Support") {
            let coreData = HomeFolder.library.applicationSupport.coreData
            let path = coreData.url.path
            try expect(path) == NSHomeDirectory() + "/Library/Application Support/CoreData"
        }
        $0.it("adding a folder inside Caches") {
            let images = HomeFolder.library.caches.imagesCache
            let path = images.url.path
            try expect(path) == NSHomeDirectory() + "/Library/Caches/Images Cache"
        }
    }
}
