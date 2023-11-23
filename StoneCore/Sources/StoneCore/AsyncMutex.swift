import Foundation

actor AsyncMutex {
    private var isLocked: Bool = false
    private var continuations: [UUID: AsyncStream<Void>.Continuation] = .init()
    
    deinit {
        continuations.forEach { $0.value.finish() }
    }
    
    private var stream: AsyncStream<Void> {
        let (stream, continuation): (AsyncStream<Void>, AsyncStream<Void>.Continuation) = AsyncStream<Void>.makeStream()
        let key: UUID = .init()
        
        continuation.onTermination = { [weak self] _ in
            Task { [weak self] in
                await self?.remove(key: key)
            }
        }
        
        continuations[key] = continuation
        
        return stream
    }
    
    func lock() async {
        mutexLoop: while isLocked {
            for await _ in stream {
                if !isLocked {
                    break mutexLoop
                }
            }
        }
        
        isLocked = true
    }
    
    func unlock() async {
        isLocked = false
        continuations.forEach { $0.value.yield() }
    }
    
    private func remove(key: UUID) {
        continuations.removeValue(forKey: key)
    }
}
