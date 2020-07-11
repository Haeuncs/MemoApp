//
//  MemoAppTests.swift
//  MemoAppTests
//
//  Created by LEE HAEUN on 2020/02/24.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import XCTest
import CoreData
@testable import MemoApp
// swiftlint:disable all
/**
 앱에서 사용하는 코어 데이터 테스트
 */
class MemoAppTests: XCTestCase {

  var coreDataManager: CoreDataManager!

  override func setUp() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    coreDataManager = CoreDataManager.sharedManager

  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    measure {
      // Put the code you want to measure the time of here.
    }
  }

  func test_init_coreDataManager() {
    let instance = CoreDataManager.sharedManager
    XCTAssertNotNil( instance )
  }
  func test_coreDataStackInitialization() {
    let coreDataStack = CoreDataManager.sharedManager.persistentContainer
    XCTAssertNotNil( coreDataStack )
  }

  /**
   create test
   */
  func test_create_mock_up_data() {
    let countBeforeAdd = coreDataManager.fetchAllMemos()?.count ?? 0

    let memo_1 = MemoData(title: "test1", memo: "memo1", date: Date(), identifier: UUID())
    let memo_2 = MemoData(title: "test2", memo: "memo2", date: Date(), identifier: UUID())
    let memo_3 = MemoData(title: "test3", memo: "memo3", date: Date(), identifier: UUID())
    let memo_4 = MemoData(title: "test4", memo: "memo4", date: Date(), identifier: UUID())
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_1))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_2))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_3))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_4))

    XCTAssertEqual(coreDataManager.fetchAllMemos()?.count, countBeforeAdd + 4)
  }
  /**
   delete test
   */
  func test_deleteMemo() {
    let testUUID = UUID()
    let testMemo = MemoData(title: "test", memo: "test", date: Date(), identifier: testUUID)
    XCTAssertNotNil(coreDataManager.add(newMemo: testMemo))

    let countMemoAfterAdd = coreDataManager.fetchAllMemos()?.count ?? 0

    XCTAssertNotNil(coreDataManager.delete(identifier: testUUID))

    XCTAssertEqual((coreDataManager.fetchAllMemos()?.count ?? 0), countMemoAfterAdd - 1)
  }
  /**
   update test
   */
  func test_update() {
    let firstMemo = coreDataManager.fetchAllMemos()?.first

    let checkUpdateTitle = "update"
    firstMemo?.title = checkUpdateTitle
    XCTAssertNotNil(coreDataManager.update(updateMemo: MemoData(title: checkUpdateTitle, memo: firstMemo?.memo, date: firstMemo?.date, identifier: firstMemo?.identifier)))

    let firstMemoAfterUpdate = coreDataManager.fetchAllMemos()?.first

    XCTAssertEqual(firstMemoAfterUpdate?.title, checkUpdateTitle)
  }

  func test_reset() {

    coreDataManager.flushData()

    XCTAssertEqual(coreDataManager.fetchAllMemos()?.count ?? 0, 0)

    let memo_1 = MemoData(title: "test1", memo: "memo1", date: Date(), identifier: UUID())
    let memo_2 = MemoData(title: "test2", memo: "memo2", date: Date(), identifier: UUID())
    let memo_3 = MemoData(title: "test3", memo: "memo3", date: Date(), identifier: UUID())
    let memo_4 = MemoData(title: "test4", memo: "memo4", date: Date(), identifier: UUID())
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_1))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_2))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_3))
    XCTAssertNotNil(coreDataManager.add(newMemo: memo_4))

    XCTAssertEqual(coreDataManager.fetchAllMemos()?.count ?? 0, 4)

    coreDataManager.reset()

    XCTAssertEqual(coreDataManager.fetchAllMemos()?.count ?? 0, 0)
    let memo_5 = MemoData(title: "test5", memo: "memo4", date: Date(), identifier: UUID())

    XCTAssertNotNil(coreDataManager.add(newMemo: memo_5))

    XCTAssertEqual(coreDataManager.fetchAllMemos()?.count ?? 0, 1)

  }
}
// swiftlint:enable all
