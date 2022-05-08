//
//  KumparanTests.swift
//  KumparanTests
//
//  Created by Engineering on 04/05/22.
//

import XCTest
@testable import Kumparan

class KumparanTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        test_post_should_produce_post()
        test_post_should_produce_different_entity()
        test_user_should_produce_entity()
        test_user_should_produce_different_entity()
    }

    func test_post_should_produce_post() {
        let entity = Domain.PostEntity(id: "1", title: nil, body: nil)
        XCTAssert(entity != nil)
    }

    func test_post_should_produce_different_entity() {
        let entity = Domain.PostEntity(id: "1", title: nil, body: nil)
        var entity2 = entity
        entity2.id = "2"
        XCTAssert(entity.id != entity2.id)
    }

    func test_user_should_produce_entity() {
        let entity = Domain.UserEntity(
                id: "1",
                name: nil,
                username: nil,
                email: nil,
                phone: nil,
                website: nil,
                company: nil,
                address: nil
        )
        XCTAssert(entity != nil)
    }

    func test_user_should_produce_different_entity() {
        let entity = Domain.UserEntity(
                id: "1",
                name: nil,
                username: nil,
                email: nil,
                phone: nil,
                website: nil,
                company: nil,
                address: nil
        )
        var entity2 = entity
        entity2.id = "2"
        XCTAssert(entity.id != entity2.id)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
