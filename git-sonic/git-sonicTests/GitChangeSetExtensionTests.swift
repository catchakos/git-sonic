// GitChangeSetExtensionTests.swift
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

class GitChangeSetExtensionTests: XCTestCase {
    
    func buildCommit(_ SHA1: String, parents: [ChangeSet], message: String = "", insertedLines: Int = 0, modifiedLines: Int = 0, deletedLines: Int = 0) -> ChangeSet {
        
        let commit = GitCommit(SHA1: SHA1, fullMessage: message, authorName: "", authorEmail: "", committerName: "", committerEmail: "", committerDate: Date(), authorDate: Date(), parents: parents, fileChanges: [FileChange](), deletedLines: deletedLines, insertedLines: insertedLines, modifiedLines: modifiedLines, conflicts: 0)
        for parent in parents {
            (parent as! GitCommit).children.append(commit)
        }
        
        return commit
    }
    
    func buildBranch(_ name: String, tipCommit: ChangeSet, remote: Bool = false) -> Branch {
        let branch = GitBranch(name: name, tipCommit: tipCommit, remote: remote)
        (tipCommit as! GitCommit).tippedBranches.append(branch)
        
        return branch
    }
    
    func buildTag(_ name: String, tipCommit: ChangeSet) -> Tag{
        let tag = GitTag(name: name, message: "", tagger: "", tipCommit: tipCommit)
        (tipCommit as! GitCommit).tags.append(tag)
        
        return tag
    }
    
    func testThatShortSHA1LengthIs7() {

        let commit = buildCommit("1272d4eb29bf1a7b4eb9c7b8fed58b44d547dc51", parents: [ChangeSet]())
        XCTAssertEqual(commit.shortSHA1.characters.count, 7)
    }
    
    func testThatShortSHA1IsPrefixOfSHA1() {
        
        let commit = buildCommit("1272d4eb29bf1a7b4eb9c7b8fed58b44d547dc51", parents: [ChangeSet]())
        XCTAssertTrue(commit.SHA1.hasPrefix(commit.shortSHA1))
    }

    func testThatSummaryIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertEqual(commit.summary, "summary")
    }

    
    func testThatSummaryIsPrefixOfMessage() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertTrue(commit.fullMessage.hasPrefix(commit.summary))
    }
    
    func testThatSummaryDoesNotHaveNewLines() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertFalse(commit.summary.contains("\n"))
    }
    
    func testThatDescriptionIsNotNil() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertNotNil(commit.description)
    }
    
    func testThatDescriptionCanBeNil() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary without description")
        XCTAssertNil(commit.description)
    }
    
    func testThatDescriptionIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertEqual(commit.description, "description")
    }
    
    func testThatDescriptionIsNotPrefixOfMessage() {
        
        let commit = buildCommit("", parents: [ChangeSet](), message: "summary\ndescription")
        XCTAssertFalse(commit.fullMessage.hasPrefix(commit.description!))
    }
    
    func testThatRootCanBeTrue() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        XCTAssertTrue(commit.root)
    }
    
    func testThatRootCanBeFalse() {
        
        let commit0 = buildCommit("0", parents: [ChangeSet]())
        let commit1 = buildCommit("1", parents: [commit0])
        XCTAssertTrue(commit0.root)
        XCTAssertFalse(commit1.root)
    }
    
    func testThatLeafCanBeTrue() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        XCTAssertTrue(commit.leaf)
    }
    
    func testThatLeafCanBeFalse() {
        
        let commit0 = buildCommit("0", parents: [ChangeSet]())
        let commit1 = buildCommit("1", parents: [commit0])
        XCTAssertTrue(commit1.leaf)
        XCTAssertFalse(commit0.leaf)
    }
    
    func testThatHasReferencesIsTrueWhenTippingTags() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildTag("", tipCommit: commit)
        XCTAssertTrue(commit.hasReferences)
    }
    
    func testThatHasReferencesIsTrueWhenTippingBranches() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildBranch("", tipCommit: commit)
        XCTAssertTrue(commit.hasReferences)
    }
    
    func testThatHasReferencesCanBeFalse() {
        
        let commit0 = buildCommit("0", parents: [ChangeSet]())
        let commit1 = buildCommit("1", parents: [commit0])
        XCTAssertFalse(commit1.hasReferences)
        XCTAssertFalse(commit0.hasReferences)
    }
    
    func testThatRemoteBranchesIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildBranch("", tipCommit: commit, remote: true)
        XCTAssertEqual(commit.remoteBranches.count, 1)
    }
    
    func testThatRemoteBranchesCanBeZero() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildBranch("", tipCommit: commit, remote: false)
        XCTAssertEqual(commit.remoteBranches.count, 0)
    }
    
    func testThatLocalBranchesIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildBranch("", tipCommit: commit, remote: true)
        _ = buildBranch("", tipCommit: commit, remote: false)
        XCTAssertEqual(commit.localBranches.count, 1)
    }
    
    func testThatLocalBranchesCanBeZero() {
        
        let commit = buildCommit("", parents: [ChangeSet]())
        _ = buildBranch("", tipCommit: commit, remote: true)
        XCTAssertEqual(commit.localBranches.count, 0)
    }
    
    func testThatInsertionsIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet](), insertedLines: 5, modifiedLines: 1)
        XCTAssertEqual(commit.insertions, 5 + 1)
    }
    
    func testThatDeletionsIsCorrect() {
        
        let commit = buildCommit("", parents: [ChangeSet](), insertedLines: 5, modifiedLines: 1, deletedLines: 3)
        XCTAssertEqual(commit.deletions, 3 + 1)
    }
    
    func testThatBranchesReturnsExpectedBranches() {
        /*
             Commits graph:

             *_    .3  ->branch 3
             | |
             * |   .2a ->branch 2a
             | |
             | *   .2b ->branch 2b
             | |
             | |_* .2c ->branch 2c
             |_/
             *     .1  ->branch 1
             |
             *     .0  ->branch 0
         */
        
        let commit0 = buildCommit("0", parents: [ChangeSet]())
        let branch0 = buildBranch("0", tipCommit: commit0)
        let commit1 = buildCommit("1", parents: [commit0])
        let branch1 = buildBranch("1", tipCommit: commit1)
        let commit2a = buildCommit("2a", parents: [commit1])
        let commit2b = buildCommit("2b", parents: [commit1])
        let branch2b = buildBranch("2b", tipCommit: commit2b)
        let commit2c = buildCommit("2c", parents: [commit1])
        let branch2c = buildBranch("2c", tipCommit: commit2c)
        let commit3 = buildCommit("3", parents: [commit2a, commit2b])
        let branch3 = buildBranch("3", tipCommit: commit3)
        
        // test that unmerged branches are not branches of other commits with common ancestors
        XCTAssertFalse(commit3.branches.contains(where: {branch in
            return branch == branch2c
        }))
        
        // test that descendants' tipped branches are ancestor's branches
        XCTAssertTrue(commit0.branches.contains(where: {branch in
            
            return branch == branch0
        }))
        XCTAssertTrue(commit0.branches.contains(where: {branch in
            
            return branch == branch1
        }))
        XCTAssertTrue(commit0.branches.contains(where: {branch in
            
            return branch == branch2b
        }))
        XCTAssertTrue(commit0.branches.contains(where: {branch in
            
            return branch == branch2c
        }))
        XCTAssertTrue(commit0.branches.contains(where: {branch in
            
            return branch == branch3
        }))
        
        // test that unmerged branches' commits only have its own tipped branch
        XCTAssertEqual(commit2c.branches.count, 1)
        XCTAssertTrue(commit2c.branches.contains(where: {branch in
            
            return branch == branch2c
        }))
    }
    
    func testThatMergesReturnsExpectedCommits() {
        /*
         Commits graph:
            *_    .4  ->branch 4
            | \_
            *_  | .3
            | | |
            * | | .2a
            | | |
            | * | .2b
            | | |
            | |_* .2c
            |_/
            *     .1
            |
            *     .0
        */
        
        let commit0 = buildCommit("0", parents: [ChangeSet]())
        let commit1 = buildCommit("1", parents: [commit0])
        let commit2a = buildCommit("2a", parents: [commit1])
        let commit2b = buildCommit("2b", parents: [commit1])
        let commit2c = buildCommit("2c", parents: [commit1])
        let commit3 = buildCommit("3", parents: [commit2a, commit2b])
        let commit4 = buildCommit("4", parents: [commit3, commit2c])
        _ = buildBranch("4", tipCommit: commit4)

        // test that initial commit has all merges
        XCTAssertEqual(commit0.merges.count, 2)
        XCTAssertTrue(commit0.merges.contains(where: {commit in
            
            return commit == commit4
        }))
        XCTAssertTrue(commit0.merges.contains(where: {commit in
            
            return commit == commit3
        }))
        
        // test that initial commit's child has all merges
        XCTAssertEqual(commit1.merges.count, 2)
        XCTAssertTrue(commit1.merges.contains(where: {commit in
            
            return commit == commit4
        }))
        XCTAssertTrue(commit1.merges.contains(where: {commit in
            
            return commit == commit3
        }))
        
        // test that initial commit's first merge has only the initial commit's second merge
        XCTAssertEqual(commit3.merges.count, 1)
        XCTAssertTrue(commit3.merges.contains(where: {commit in
            
            return commit == commit4
        }))

        // test that initial commit's first merge's parent has all merges
        XCTAssertTrue(commit3.parents.contains(where: {commit in
            
            return commit == commit2b
        }))
        XCTAssertEqual(commit2b.merges.count, 2)
        XCTAssertTrue(commit2b.merges.contains(where: {commit in
            return commit == commit4
        }))
        XCTAssertTrue(commit2b.merges.contains(where: {commit in
            return commit == commit3
        }))
        
        // test that initial commit's second merge's parent has only the initial commit's second merge
        XCTAssertTrue(commit4.parents.contains(where: {commit in
            
            return commit == commit2c
        }))
        XCTAssertEqual(commit2c.merges.count, 1)
        XCTAssertTrue(commit2c.merges.contains(where: {commit in
            
            return commit == commit4
        }))

        // test that initial commit's second merge doesn't have any merge
        XCTAssertEqual(commit4.merges.count, 0)
    }
}
