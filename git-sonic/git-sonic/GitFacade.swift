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
    
    // Returns the commits of the given branch (fallbacks to head) reverse-chronologically sorted.
    class func getCommits(repository: GCRepository, branch: GCBranch? = nil) throws -> [GCHistoryCommit] {
        let history = try repository.loadHistoryUsingSorting(GCHistorySorting.ReverseChronological)
        var tipCommit: GCHistoryCommit
        if let branch = branch {
            let commit = try repository.lookupTipCommitForBranch(branch)
            tipCommit = history.historyCommitForCommit(commit)
        } else {
            let commit = try repository.lookupTipCommitForBranch(history.HEADBranch)
            tipCommit = history.historyCommitForCommit(commit)
        }
        let branchCommits = try self.getCommits(history, fromDescendant: tipCommit)
        
        return branchCommits
    }
    
    // Returns commits between the two given in a breadth-first fashion and sorting commits in the same level reverse-chronologically.
    class func getCommits(history: GCHistory, fromDescendant: GCHistoryCommit, toAncestor:GCHistoryCommit? = nil) throws -> [GCHistoryCommit] {
        var sortedCommits = [GCHistoryCommit]() // result
        var ancestorReached = false // stop condition
        var buffer = [fromDescendant] // buffer of unsorted commits
        history.walkAncestorsOfCommits([fromDescendant]) { (commit: GCHistoryCommit!, stop: UnsafeMutablePointer<ObjCBool>) in
            // flush buffer
            var commitsToFlush = [GCHistoryCommit]()
            var indexesToRemoveFromBuffer = [Int]()
            for child in commit.children as! [GCHistoryCommit] {
                if let index = buffer.indexOf(child) {
                    indexesToRemoveFromBuffer.append(index)
                    commitsToFlush.append(child)
                }
            }
            for index in indexesToRemoveFromBuffer.sort({$0 > $1}) {
                buffer.removeAtIndex(index)
            }
            commitsToFlush.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
            sortedCommits.appendContentsOf(commitsToFlush)
            // select new commit if appropriate
            if let toCommit = toAncestor  {
                if (toCommit.date.compare(commit.date) == NSComparisonResult.OrderedDescending) {
                    if (ancestorReached) {
                        stop.memory = true
                    }
                    
                    return
                } else if (toCommit == commit) {
                    ancestorReached = true
                }
            }
            buffer.append(commit)
        }
        // flush buffer and return selection
        buffer.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedDescending })
        sortedCommits.appendContentsOf(buffer)
        assert(toAncestor == nil || sortedCommits.contains(toAncestor!))
        
        return sortedCommits
    }

}
