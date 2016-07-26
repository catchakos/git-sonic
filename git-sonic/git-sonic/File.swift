// File.swift
//
// Copyright (c) 2016 phonegroove. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

public enum FileChangeType {
    
    case Added
    case Deleted
    case Modified
    case Renamed
    case Copied
    case TypeChanged
}

public protocol FileChange {
    
    var type: FileChangeType { get }
    
    var newFile: File? { get }
    var oldFile: File? { get }
}

public extension FileChange {
    
    var canonicalPath: String {
        
        if let newFile = newFile {
            
            return newFile.path
        } else {
            
            return oldFile!.path
        }
    }
}

public func ==(lhs: FileChange, rhs: FileChange) -> Bool {
    
    return (lhs.type == rhs.type && lhs.canonicalPath == rhs.canonicalPath)
}

public func ==<T: FileChange>(lhs: T, rhs: T) -> Bool {
    
    return (lhs as FileChange) == (rhs as FileChange)
}


public protocol File {
    
    var path: String { get }
    var SHA1: String { get }
}

public func ==(lhs: File, rhs: File) -> Bool {
    
    return (lhs.path == rhs.path && lhs.SHA1 == rhs.SHA1)
}

public func ==<T: File>(lhs: T, rhs: T) -> Bool {
    
    return (lhs as File) == (rhs as File)
}

