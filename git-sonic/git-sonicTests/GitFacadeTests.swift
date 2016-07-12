// GitFacadeTests.swift
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

class GitFacadeTest: XCTestCase {
    
    let url = NSURL(string:"https://github.com/catchakos/git-sonic.git")!
    
    let repo = try! GitFacade.cloneRepository("https://github.com/catchakos/git-sonic.git")
    
    var branch: GCBranch?
    
    override func setUp() {
        super.setUp()
        branch = try! self.repo.findRemoteBranchWithName("origin/develop")
    }
    
    func testThatCloneRepositoryReturnsRepositoryWithCorrectRemote() {
        guard let repo = try? GitFacade.cloneRepository(url) else {
            XCTFail("clone failed")
            
            return
        }
        guard let remotes = try? repo.listRemotes() else {
            XCTFail("remotes failed")
            
            return
        }
        XCTAssertEqual(remotes.count, 1)
        let remote = remotes[0]
        XCTAssertTrue(remote.URL == url)
    }

}
