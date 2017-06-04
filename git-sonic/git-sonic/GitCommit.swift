// GitCommit.swift
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

class GitCommit: ChangeSet, Equatable {
    
    var SHA1: String
    
    var fullMessage: String
    
    var authorName: String
    var authorEmail: String
    var authorDate: Date
    
    var committerName: String
    var committerEmail: String
    var committerDate: Date
    
    var parents: [ChangeSet]
    var children: [ChangeSet]
    
    var tippedBranches: [Branch]
    var tags: [Tag]
    
    var fileChanges: [FileChange]
    
    var deletedLines: Int
    var insertedLines: Int
    var modifiedLines: Int

    var conflicts: Int
    
    init(SHA1: String, fullMessage: String, authorName: String, authorEmail: String, committerName: String, committerEmail: String, committerDate: Date, authorDate: Date, parents: [ChangeSet], fileChanges: [FileChange], deletedLines: Int, insertedLines: Int, modifiedLines: Int, conflicts: Int) {
        
        self.SHA1 = SHA1
        self.fullMessage = fullMessage
        self.authorName = authorName
        self.authorEmail = authorEmail
        self.authorDate = authorDate
        self.committerName = committerName
        self.committerEmail = committerEmail
        self.committerDate = committerDate
        self.parents = parents
        self.children = [ChangeSet]()
        self.tippedBranches = [Branch]()
        self.tags = [Tag]()
        self.fileChanges = fileChanges
        self.deletedLines = deletedLines
        self.insertedLines = insertedLines
        self.modifiedLines = modifiedLines
        self.conflicts = conflicts
    }
}
