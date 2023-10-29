import Foundation

public actor CurrentValueAsyncSubject<Element: Sendable> {
    public private(set) var value: Element
    
    public var stream: AsyncStream<Element> {
        let (stream, continuation): (AsyncStream<Element>, AsyncStream<Element>.Continuation) = AsyncStream<Element>.makeStream()
        let key: UUID = .init()
        
        continuation.onTermination = { [weak self] _ in
            Task { [weak self] in
                await self?.remove(key: key)
            }
        }
        
        continuations[key] = continuation
        
        return stream
    }
    
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = .init()
    
    public init(value: Element) {
        self.value = value
    }
    
    deinit {
        continuations.values.forEach { continuation in
            continuation.finish()
        }
    }
    
    public func callAsFunction() -> AsyncStream<Element> {
        stream
    }
    
    public func yield(with result: Result<Element, Never>) {
        if case .success(let newValue) = result {
            value = newValue
        }
        
        continuations.values.forEach { continuation in
            continuation.yield(with: result)
        }
    }
    
    public func yield(_ value: Element) {
        self.value = value
        
        continuations.values.forEach { continuation in
            continuation.yield(value)
        }
    }
    
    private func remove(key: UUID) {
        continuations.removeValue(forKey: key)
    }
}
