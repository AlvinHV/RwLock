// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation

public final class RwLock<T> : @unchecked Sendable {
    private let lock = NSLock()
    private var resource: T
    
    public init(_ resource: T) {
        self.resource = resource
    }
    
    /// Do not store object itself. Otherwise we cannot ensure thread safety.
    public func access<U>(_ modify: (inout T) -> U) -> U {
        lock.lock()
        defer { lock.unlock() }
        return modify(&resource)
    }
}
