# AppFolder

[![Swift][swift-badge]][swift-url]
[![Platform][platform-badge]][platform-url]
[![Build Status](https://travis-ci.org/dreymonde/AppFolder.svg?branch=master)](https://travis-ci.org/dreymonde/AppFolder)

[swift-badge]: https://img.shields.io/badge/Swift-4.0-orange.svg?style=flat
[swift-url]: https://swift.org
[platform-badge]: https://img.shields.io/badge/platform-iOS%20%7C%20macOS%20%7C%20watchOS%20%7C%20tvOS-lightgrey.svg
[platform-url]: https://developer.apple.com/swift/

**AppFolder** is a lightweight framework that lets you design a friendly, strongly-typed representation of a directories inside your app folder. All the system directories like **Caches/** or **Application Support/** are already presented, and you can add yours using only a couple of lines of code.

**AppFolder** can offer two unique reasons for you to use it in your code:

1. It makes accessing trivial locations (like "**Documents**" folder) incredibly easy. `NSSearchPathForDirectoriesInDomains` can easily scare you from working with a file system, and **AppFolder** reduces anxiety of this (and others) scary Cocoa API.
2. It visualizes the folder structure of your app. You design how the folder should be structured using strong types -- and autocompletion.

## Usage

```swift
import AppFolder

// retrieving URLs for standard folders
let cachesURL = AppFolder.library.caches.url
let documentsURL = AppFolder.documents.url

// describing a folder inside "Library/Caches/"
extension Library.Caches {
    
    class Images: Directory { }
    var images: Images {
        return adding()
    }
    
}

// this will return a URL of a "Library/Caches/Images/" folder inside our app container
let imagesCacheURL = AppFolder.library.caches.images.url
```