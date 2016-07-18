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
    
    let aCommit = GitCommit(SHA1: "the SHA1", fullMessage: "the full message", authorName: "author name", authorEmail: "author email", committerName: "committer name", committerEmail: "committer email", committerDate: NSDate(), authorDate: NSDate(), parents: [ChangeSet](), children: [ChangeSet](), tippedBranches: [Branch](), tags: [Tag](), fileChanges: [FileChange](), deletedLines: 0, insertedLines: 0, modifiedLines: 0)

    func testThatGitBranchConstructorInitializesProperties() {
        
        let name = "the name"
        let tipCommit: ChangeSet = aCommit
        let remote = true
        let branch: Branch = GitBranch(name: name, tipCommit: tipCommit, remote: remote)
        XCTAssertEqual(branch.name, name)
        //TODO: XCTAssertEqual(branch.tipCommit, tipCommit)
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
        //TODO: XCTAssertEqual(tag.tipCommit, tipCommit)
    }

    func testThatGitFileConstructorInitializesProperties() {
        
        let path = "the path"
        let SHA1 = "the SHA1"
        let file: File = GitFile(path: path, SHA1: SHA1)
        XCTAssertEqual(file.path, path)
        XCTAssertEqual(file.SHA1, SHA1)
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
        let parents = [ChangeSet]()
        let children = [ChangeSet]()
        let tippedBranches = [Branch]()
        let tags = [Tag]()
        let fileChanges = [FileChange]()
        let deletedLines = 3
        let insertedLines = 5
        let modifiedLines = 7
        let changeSet: ChangeSet = GitCommit(SHA1: SHA1, fullMessage: fullMessage, authorName: authorName, authorEmail: authorEmail, committerName: committerName, committerEmail: committerEmail, committerDate: committerDate, authorDate: authorDate, parents: parents, children: children, tippedBranches: tippedBranches, tags: tags, fileChanges: fileChanges, deletedLines: deletedLines, insertedLines: insertedLines, modifiedLines: modifiedLines)
        XCTAssertEqual(changeSet.SHA1, SHA1)
        XCTAssertEqual(changeSet.fullMessage, fullMessage)
        XCTAssertEqual(changeSet.authorName, authorName)
        XCTAssertEqual(changeSet.authorEmail, authorEmail)
        XCTAssertEqual(changeSet.committerName, committerName)
        XCTAssertEqual(changeSet.committerEmail, committerEmail)
        XCTAssertEqual(changeSet.committerDate, committerDate)
        XCTAssertEqual(changeSet.authorDate, authorDate)
        //TODO: XCTAssertEqual(changeSet.parents, parents)
        //TODO: XCTAssertEqual(changeSet.children, children)
        //TODO: XCTAssertEqual(changeSet.tippedBranches, tippedBranches)
        //TODO: XCTAssertEqual(changeSet.tags, tags)
        //TODO: XCTAssertEqual(changeSet.fileChanges, fileChanges)
        XCTAssertEqual(changeSet.deletedLines, deletedLines)
        XCTAssertEqual(changeSet.insertedLines, insertedLines)
        XCTAssertEqual(changeSet.modifiedLines, modifiedLines)
    }
}
