import Testing
import XCTest
@testable import RwLock

@Test func testRwLock() throws {
    let lock = RwLock(resource: [1, 2, 3])
    
    lock.access { resource in
        resource.append(4)
    }
    
    let result = lock.access { $0 }
    #expect(result == [1, 2, 3, 4])
}

@Test func testRwLockAsync() throws {
    let lock = RwLock(resource: 0)
    let dispatchGroup = DispatchGroup()
    let max = 1000

    dispatchGroup.enter()
    for _ in 1...max {
        DispatchQueue.global().async {
            lock.access { resource in
                resource += 1
                if resource == max {
                    dispatchGroup.leave()
                }
            }
        }
    }
    
    dispatchGroup.wait()

    lock.access { result in
        #expect(result == max, "Resource should be incremented correctly by all tasks")
    }
}
