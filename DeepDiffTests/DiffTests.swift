import XCTest
import DeepDiff

class DiffTests: XCTestCase {
  func testEmpty() {
    let old: [String] = []
    let new: [String] = []
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 0)
  }

  func testAllInsert() {
    let old = Array("")
    let new = Array("abc")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].insert?.item, "a")
    XCTAssertEqual(changes[0].insert?.index, 0)

    XCTAssertEqual(changes[1].insert?.item, "b")
    XCTAssertEqual(changes[1].insert?.index, 1)

    XCTAssertEqual(changes[2].insert?.item, "c")
    XCTAssertEqual(changes[2].insert?.index, 2)
  }

  func testAllDelete() {
    let old = Array("abc")
    let new = Array("")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].delete?.item, "a")
    XCTAssertEqual(changes[0].delete?.index, 0)

    XCTAssertEqual(changes[1].delete?.item, "b")
    XCTAssertEqual(changes[1].delete?.index, 1)

    XCTAssertEqual(changes[2].delete?.item, "c")
    XCTAssertEqual(changes[2].delete?.index, 2)
  }

  func testAllReplace() {
    let old = Array("abc")
    let new = Array("ABC")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].replace?.item, "A")
    XCTAssertEqual(changes[0].replace?.fromIndex, 0)
    XCTAssertEqual(changes[0].replace?.toIndex, 0)

    XCTAssertEqual(changes[1].replace?.item, "B")
    XCTAssertEqual(changes[1].replace?.fromIndex, 1)
    XCTAssertEqual(changes[1].replace?.toIndex, 1)

    XCTAssertEqual(changes[2].replace?.item, "C")
    XCTAssertEqual(changes[2].replace?.fromIndex, 2)
    XCTAssertEqual(changes[2].replace?.toIndex, 2)
  }

  func test1() {
    // Same prefix "a"
    let old = Array("abc")
    let new = Array("aB")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].replace?.item, "B")
    XCTAssertEqual(changes[0].replace?.fromIndex, 1)
    XCTAssertEqual(changes[0].replace?.toIndex, 1)

    XCTAssertEqual(changes[1].delete?.item, "c")
    XCTAssertEqual(changes[1].delete?.index, 2)
  }

  func test2() {
    // Reversed
    let old = Array("abc")
    let new = Array("cba")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 2)

    XCTAssertEqual(changes[0].replace?.item, "c")
    XCTAssertEqual(changes[0].replace?.fromIndex, 0)
    XCTAssertEqual(changes[0].replace?.toIndex, 0)

    XCTAssertEqual(changes[1].replace?.item, "a")
    XCTAssertEqual(changes[1].replace?.fromIndex, 2)
    XCTAssertEqual(changes[1].replace?.toIndex, 2)
  }

  func test3() {
    // Small changes at beginning and end
    let old = Array("sitting")
    let new = Array("kitten")
    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)

    XCTAssertEqual(changes[0].replace?.item, "k")
    XCTAssertEqual(changes[0].replace?.fromIndex, 0)
    XCTAssertEqual(changes[0].replace?.toIndex, 0)

    XCTAssertEqual(changes[1].replace?.item, "e")
    XCTAssertEqual(changes[1].replace?.fromIndex, 4)
    XCTAssertEqual(changes[1].replace?.toIndex, 4)

    XCTAssertEqual(changes[2].delete?.item, "g")
    XCTAssertEqual(changes[2].delete?.index, 6)
  }

  func test4() {
    // Same postfix
    let old = Array("abcdef")
    let new = Array("def")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 6)
  }

  func test5() {
    // Replace with whole new word
    let old = Array("abc")
    let new = Array("d")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 3)
  }

  func test6() {
    // Replace with 1 character
    let old = Array("a")
    let new = Array("b")

    let changes = diff(old: old, new: new)
    XCTAssertEqual(changes.count, 1)

    XCTAssertEqual(changes[0].replace?.item, "b")
    XCTAssertEqual(changes[0].replace?.fromIndex, 0)
    XCTAssertEqual(changes[0].replace?.toIndex, 0)
  }
}
