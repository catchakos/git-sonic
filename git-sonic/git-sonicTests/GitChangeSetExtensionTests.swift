// GitVersionControlProtocolsTests.swift
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

import XCTest
@testable import git_sonic

class GitVersionControlProtocolsTests: XCTestCase {
    
    let aCommit = GitCommit(SHA1: "a SHA1", fullMessage: "a full message", authorName: "author name", authorEmail: "author email", committerName: "committer name", committerEmail: "committer email", committerDate: NSDate(), authorDate: NSDate(), parents: [ChangeSet](), children: [ChangeSet](), fileChanges: [FileChange](), deletedLines: 1, insertedLines: 2, modifiedLines: 3, conflicts: 4)

    let anotherCommit = GitCommit(SHA1: "the SHA1", fullMessage: "the full message", authorName: "the author name", authorEmail: "the author email", committerName: "the committer name", committerEmail: "the committer email", committerDate: NSDate(), authorDate: NSDate(), parents: [ChangeSet](), children: [ChangeSet](), fileChanges: [FileChange](), deletedLines: 4, insertedLines: 5, modifiedLines: 6, conflicts: 7)
    
    let aFileChange = GitFileChange(type: .Added, newFile: GitFile(path: "a path", SHA1: "a SHA1"), oldFile: nil)

    let anotherFileChange = GitFileChange(type: .Deleted, newFile: GitFile(path: "the path", SHA1: "the SHA1"), oldFile: nil)
    
    func testThatGitBranchConstructorInitializesProperties() {
        
        let name = "the name"
        let tipCommit: ChangeSet = aCommit
        let remote = true
        let branch: Branch = GitBranch(name: name, tipCommit: tipCommit, remote: remote)
        XCTAssertEqual(branch.name, name)
        XCTAssertTrue(branch.tipCommit == tipCommit)
        XCTAssertEqual(branch.remote, remote)
    }
    
    func testThatGitTagConstructorInitializesProperties() {
        
        let name = "the name"
        let message = "the message"
        let tagger = "the tagger"
        let tipCommit: ChangeSet = aCommit
        let tag: Tag = GitTag(name: name, message: message, tagger: tagger, tipCommit: tipCommit)
        XCTAssertEqual(tag.name, name)
        XCTAssertEqual(tag.message, message)
        XCTAssertEqual(tag.tagger, tagger)
        XCTAssertTrue(tag.tipCommit == tipCommit)
    }

    func testThatGitFileConstructorInitializesProperties() {
        
        let path = "the path"
        let SHA1 = "the SHA1"
        let file: File = GitFile(path: path, SHA1: SHA1)
        XCTAssertEqual(file.path, path)
        XCTAssertEqual(file.SHA1, SHA1)
    }
    
    func testThatGitFileChangeConstructorInitializesProperties() {
        
        let type: FileChangeType = .Renamed
        let newFile: File = GitFile(path: "a path", SHA1: "a SHA1")
        let oldFile: File = GitFile(path: "the path", SHA1: "the SHA1")
        let fileChange = GitFileChange(type: type, newFile: newFile, oldFile: oldFile)
        XCTAssertEqual(fileChange.type, type)
        XCTAssertTrue(fileChange.newFile! == newFile)
        XCTAssertTrue(fileChange.oldFile! == oldFile)
    }
    
    func testThatGitCommitConstructorInitializesProperties() {
        
        let SHA1 = "the SHA1"
        let fullMessage = "the full message"
        let authorName = "the author name"
        let authorEmail = "the author email"
        let authorDate = NSDate()
        let committerName = "the committer name"
        let committerEmail = "the committer email"
        let committerDate = NSDate()
        let parents: [ChangeSet] = [aCommit]
        let children: [ChangeSet] = [anotherCommit]
        let fileChanges: [FileChange] = [aFileChange, anotherFileChange]
        let deletedLines = 3
        let insertedLines = 5
        let modifiedLines = 7
        let conflicts = 8
        let changeSet: ChangeSet = GitCommit(SHA1: SHA1, fullMessage: fullMessage, authorName: authorName, authorEmail: authorEmail, committerName: committerName, committerEmail: committerEmail, committerDate: committerDate, authorDate: authorDate, parents: parents, children: children, fileChanges: fileChanges, deletedLines: deletedLines, insertedLines: insertedLines, modifiedLines: modifiedLines, conflicts: conflicts)
        XCTAssertEqual(changeSet.SHA1, SHA1)
        XCTAssertEqual(changeSet.fullMessage, fullMessage)
        XCTAssertEqual(changeSet.authorName, authorName)
        XCTAssertEqual(changeSet.authorEmail, authorEmail)
        XCTAssertEqual(changeSet.committerName, committerName)
        XCTAssertEqual(changeSet.committerEmail, committerEmail)
        XCTAssertEqual(changeSet.committerDate, committerDate)
        XCTAssertEqual(changeSet.authorDate, authorDate)
        XCTAssertEqual(changeSet.parents.count, parents.count)
        for index in 0 ..< parents.count {
            XCTAssertTrue(parents[index] == changeSet.parents[index])
        }
        XCTAssertEqual(changeSet.children.count, children.count)
        for index in 0 ..< children.count {
            XCTAssertTrue(children[index] == changeSet.children[index])
        }
        XCTAssertEqual(changeSet.fileChanges.count, fileChanges.count)
        for index in 0 ..< fileChanges.count {
            XCTAssertTrue(fileChanges[index] == changeSet.fileChanges[index])
        }
        XCTAssertEqual(changeSet.deletedLines, deletedLines)
        XCTAssertEqual(changeSet.insertedLines, insertedLines)
        XCTAssertEqual(changeSet.modifiedLines, modifiedLines)
        XCTAssertEqual(changeSet.conflicts, conflicts)
    }
}
