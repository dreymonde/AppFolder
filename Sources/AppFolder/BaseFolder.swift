//
//  BaseFolder.swift
//  AppFolder
//
//  Created by Олег on 18.01.2018.
//  Copyright © 2018 AppFolder. All rights reserved.
//

import Foundation

public enum AppFolder {
    
    public static let baseURL: URL = {
        let url = URL(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        print("BASE URL:", url)
        return url
    }()
    
    public static var library: Library {
        return Library(baseURL: baseURL)
    }
    
    public static var documents: Documents {
        return Documents(baseURL: baseURL)
    }
    
    public static var tmp: Temporary {
        return Temporary(baseURL: baseURL)
    }
    
}
