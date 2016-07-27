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
    
    func buildCommit(SHA1: String, parents: [ChangeSet]) -> ChangeSet {
        
        let commit = GitCommit(SHA1: SHA1, fullMessage: "", authorName: "", authorEmail: "", committerName: "", committerEmail: "", committerDate: NSDate(), authorDate: NSDate(), parents: parents, fileChanges: [FileChange](), deletedLines: 0, insertedLines: 0, modifiedLines: 0, conflicts: 0)
        for parent in parents {
            (parent as! GitCommit).children.append(commit)
        }
        return commit
    }
    
    func buildBranch(name: String, tipCommit: ChangeSet) -> Branch {
        let branch = GitBranch(name: name, tipCommit: tipCommit, remote: false)
        (tipCommit as! GitCommit).tippedBranches = [branch]
        
        return branch
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
        XCTAssertFalse(commit3.branches.contains({branch in
            return branch == branch2c
        }))
        
        // test that descendants' tipped branches are ancestor's branches
        XCTAssertTrue(commit0.branches.contains({branch in
            
            return branch == branch0
        }))
        XCTAssertTrue(commit0.branches.contains({branch in
            
            return branch == branch1
        }))
        XCTAssertTrue(commit0.branches.contains({branch in
            
            return branch == branch2b
        }))
        XCTAssertTrue(commit0.branches.contains({branch in
            
            return branch == branch2c
        }))
        XCTAssertTrue(commit0.branches.contains({branch in
            
            return branch == branch3
        }))
        
        // test that unmerged branches' commits only have its own tipped branch
        XCTAssertEqual(commit2c.branches.count, 1)
        XCTAssertTrue(commit2c.branches.contains({branch in
            
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
        XCTAssertTrue(commit0.merges.contains({commit in
            
            return commit == commit4
        }))
        XCTAssertTrue(commit0.merges.contains({commit in
            
            return commit == commit3
        }))
        
        // test that initial commit's child has all merges
        XCTAssertEqual(commit1.merges.count, 2)
        XCTAssertTrue(commit1.merges.contains({commit in
            
            return commit == commit4
        }))
        XCTAssertTrue(commit1.merges.contains({commit in
            
            return commit == commit3
        }))
        
        // test that initial commit's first merge has only the initial commit's second merge
        XCTAssertEqual(commit3.merges.count, 1)
        XCTAssertTrue(commit3.merges.contains({commit in
            
            return commit == commit4
        }))

        // test that initial commit's first merge's parent has all merges
        XCTAssertTrue(commit3.parents.contains({commit in
            
            return commit == commit2b
        }))
        XCTAssertEqual(commit2b.merges.count, 2)
        XCTAssertTrue(commit2b.merges.contains({commit in
            return commit == commit4
        }))
        XCTAssertTrue(commit2b.merges.contains({commit in
            return commit == commit3
        }))
        
        // test that initial commit's second merge's parent has only the initial commit's second merge
        XCTAssertTrue(commit4.parents.contains({commit in
            
            return commit == commit2c
        }))
        XCTAssertEqual(commit2c.merges.count, 1)
        XCTAssertTrue(commit2c.merges.contains({commit in
            
            return commit == commit4
        }))

        // test that initial commit's second merge doesn't have any merge
        XCTAssertEqual(commit4.merges.count, 0)
    }
}
