
# Thread-Safe Resource Access with RwLock

This Swift implementation demonstrates a thread-safe read-write lock for managing resources in applications that do not support Swift concurrency (prior to iOS 12). It uses `NSLock` to ensure safe access to shared resources in a multithreaded environment.

## Features

- Utilizes `NSLock` for locking and unlocking.
- Recommended on iOS 12 and prior versions where concurrency is not supported natively.

## Code Overview

The `RwLock<T>` class allows safe access to a shared resource by locking it during modifications. The lock prevents other threads from accessing the resource while it is being modified.

### RwLock Class

```swift
final class RwLock<T> : @unchecked Sendable {
    private let lock = NSLock()
    private var resource: T
    
    init(resource: T) {
        self.resource = resource
    }
    
    /// Do not store object itself. Otherwise we cannot ensure thread safety.
    func access<U>(_ modify: (inout T) -> U) -> U {
        lock.lock()
        defer { lock.unlock() }
        return modify(&resource)
    }
}
```

- **`lock`**: An instance of `NSLock` used to synchronize access to the shared resource.
- **`resource`**: The shared resource being protected by the lock.
- **`access(modify:)`**: A method that locks the resource for modification, performs the modification, and then unlocks it.

### Example Usage

```swift
import RwLock

let rwLock = RwLock(resource: 42)

// Access and modify the resource safely
rwLock.access { resource in
    resource += 1
    print(resource) // Output: 43
}


```

Another example

```swift
import RwLock

let rwLock = RwLock(resource: -1)

// Access and modify
rwLock.access { resource in
    resource += 1
}

// Access and return result
let isNegative : Bool = rwLock.access { resource in
    return resource < 0
}

print(isNegative) // Output: false
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---
