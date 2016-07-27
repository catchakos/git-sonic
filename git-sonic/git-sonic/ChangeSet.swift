// ChangeSet.swift
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

public protocol ChangeSet {
    
    var SHA1: String { get }

    var fullMessage: String { get }

    var authorName: String { get }
    var authorEmail: String { get }
    var authorDate: NSDate { get }
    
    var committerName: String { get }
    var committerEmail: String { get }
    var committerDate: NSDate { get }

    var parents: [ChangeSet] { get }
    var children: [ChangeSet] { get }
    
    var tippedBranches: [Branch] { get }
    var tags: [Tag] { get }
    
    var fileChanges: [FileChange] { get }
    
    var deletedLines: Int { get }
    var insertedLines: Int { get }
    var modifiedLines: Int { get }
    
    var conflicts: Int { get }
}

public extension ChangeSet {
    
    var shortSHA1: String {
        
        let index = SHA1.startIndex.advancedBy(7)
        
        return SHA1.substringToIndex(index)
    }
    
    var summary: String {
        
        let components = fullMessage.componentsSeparatedByString("\n")
        
        return components.first!
    }
    
    var description: String? {
        
        var description: String?
        let range = fullMessage.rangeOfString("\n")
        if let range = range {
            description = fullMessage.substringFromIndex(range.endIndex)
        }
        
        return description
    }
    
    var root: Bool {
        
        return (parents.count == 0)
    }
    
    var leaf: Bool {
        
        return (children.count == 0)
    }
    
    var hasReferences: Bool {
        
        return (tags.count > 0 || tippedBranches.count > 0)
    }
    
    var remoteBranches: [Branch] {
        
        return tippedBranches.filter({$0.remote})
    }
    
    var localBranches: [Branch] {
        
        return tippedBranches.filter({$0.local})
    }
    
    var insertions: Int {
        
        return (insertedLines + modifiedLines)
    }
    
    var deletions: Int {
        
        return (deletedLines + modifiedLines)
    }
    
    var branches: [Branch] {
        
        var branches = [Branch]()
        for tippedBranch in tippedBranches {
            var append = true
            for branch in branches {
                if (branch == tippedBranch) {
                    append = false
                    
                    break
                }
            }
            if (append) {
                branches.append(tippedBranch)
            }
        }
        for child in children {
            for childBranch in child.branches {
                var append = true
                for branch in branches {
                    if (branch == childBranch) {
                        append = false
                        
                        break
                    }
                }
                if (append) {
                    branches.append(childBranch)
                }
            }
        }
        
        return branches
    }
    
    var merges: [ChangeSet] {
        
        var merges = [ChangeSet]()
        for child in children {
            if (child.parents.count > 1) {
                var append = true
                for merge in merges {
                    if (merge == child) {
                        append = false
                        
                        break
                    }
                }
                if (append) {
                    merges.append(child)
                }
            }
            for descendantMerge in child.merges {
                var append = true
                for merge in merges {
                    if (merge == descendantMerge) {
                        append = false
                        
                        break
                    }
                }
                if (append) {
                    merges.append(descendantMerge)
                }
            }
        }
        
        return merges
    }
}

public func ==(lhs: ChangeSet, rhs: ChangeSet) -> Bool {
    
    return (lhs.SHA1 == rhs.SHA1)
}

public func ==<T: ChangeSet>(lhs: T, rhs: T) -> Bool {
    
    return (lhs as ChangeSet) == (rhs as ChangeSet)
}
