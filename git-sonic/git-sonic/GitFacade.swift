// GitFacade.swift
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

import UIKit

class GitFacade {
    
    // Synchronous function for cloning a repository.
    class func cloneRepository(uri: String, intoPath pathOrNil: String? = nil, recursive: Bool = false, removeExistingDirectory removeExisting: Bool = true) throws -> GCRepository {
        
        guard let url = NSURL(string: uri) else {
            
            throw NSError(domain:#file, code:#line, userInfo:nil)
        }
        
        return try self.cloneRepository(url
            , intoPath: pathOrNil
            , recursive: recursive
            , removeExistingDirectory: removeExisting)
    }
    
    // Synchronous function that clones a repository.
    class func cloneRepository(url: NSURL, intoPath pathOrNil: String? = nil, recursive: Bool = false, removeExistingDirectory removeExisting: Bool = true) throws -> GCRepository {
        
        guard let path = pathOrNil else {
            let uniqueString = NSProcessInfo.processInfo().globallyUniqueString;
            let directoryName = uniqueString.stringByAppendingString(".git")
            let path = NSTemporaryDirectory().stringByAppendingString(directoryName)
            
            return try self.cloneRepository(url, intoPath: path, recursive: recursive, removeExistingDirectory: removeExisting)
        }
        
        if (removeExisting) {
            if (NSFileManager.defaultManager().fileExistsAtPath(path)) {
                try NSFileManager.defaultManager().removeItemAtPath(path)
            }
        }
        
        let repo = try GCRepository(newLocalRepository: path, bare: true)
        let remote = try repo.addRemoteWithName("origin", url: url)
        try repo.cloneUsingRemote(remote, recursive: recursive)
        
        return repo
    }

}
