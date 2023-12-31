@preconcurrency import CoreData

actor CoreDataStack {
    var container: NSPersistentContainer {
        get async throws {
            if let _container: NSPersistentContainer {
                return _container
            }
            
            let task: Task<NSPersistentContainer, Error> = .init { @_CoreDataStackMap in
                if let container: NSPersistentContainer = await _CoreDataStackMap.shared.load(key: name) {
                    await _set(_container: container)
                    return container
                } else {
                    let container: NSPersistentContainer = try await makeContainer()
                    await _set(_container: container)
                    await _CoreDataStackMap.shared.store(key: name, container: container)
                    return container
                }
            }
            
            return try await task.value
        }
    }
    
    var context: NSManagedObjectContext {
        get async throws {
            if let _context: NSManagedObjectContext {
                return _context
            }
            
            let task: Task<NSManagedObjectContext, Error> = .init { @_CoreDataStackMap in
                if let context: NSManagedObjectContext = await _CoreDataStackMap.shared.load(key: name) {
                    await _set(_context: context)
                    return context
                } else {
                    let context: NSManagedObjectContext = try await makeContext()
                    await _set(_context: context)
                    await _CoreDataStackMap.shared.store(key: name, context: context)
                    return context
                }
            }
            
            return try await task.value
        }
    }
    
    private let name: String
    private let managedObjectModel: NSManagedObjectModel
    
    private var _container: NSPersistentContainer?
    private var _context: NSManagedObjectContext?
    
    private var containerURL: URL {
        URL
            .applicationSupportDirectory
            .appending(component: "StoneCore", directoryHint: .isDirectory)
            .appending(path: "CoreDataStack", directoryHint: .isDirectory)
            .appending(path: name, directoryHint: .notDirectory)
            .appendingPathExtension("sqlite")
    }
    
    init(name: String, managedObjectModel: NSManagedObjectModel) {
        self.name = name
        self.managedObjectModel = managedObjectModel
    }
    
    func container() async throws -> NSPersistentContainer {
        try await container
    }
    
    func context() async throws -> NSManagedObjectContext {
        try await context
    }
    
    private func makeContainer() async throws -> NSPersistentContainer {
        let container: NSPersistentContainer = .init(name: name, managedObjectModel: managedObjectModel)
        let description: NSPersistentStoreDescription = .init(url: containerURL)
        description.shouldAddStoreAsynchronously = true
        
        let _: Void = try await withCheckedThrowingContinuation { continuation in
            container.persistentStoreCoordinator.addPersistentStore(with: description) { _, error in
                if let error: Error {
                    continuation.resume(with: .failure(error))
                } else {
                    continuation.resume(with: .success(()))
                }
            }
        }
        
        return container
    }
    
    private func makeContext() async throws -> NSManagedObjectContext {
        let container: NSPersistentContainer = try await container
        let context: NSManagedObjectContext = container.newBackgroundContext()
        
        return context
    }
    
    private func destory() async throws {
        let coordinator: NSPersistentStoreCoordinator = try await container.persistentStoreCoordinator
        
        try coordinator
            .persistentStores
            .forEach { persistentStore in
                try coordinator.destroyPersistentStore(at: persistentStore.url!, type: .init(rawValue: persistentStore.type), options: nil)
            }
        
        weak var oldContainer: NSPersistentContainer? = try await container
        weak var oldContext: NSManagedObjectContext? = try await context
        
        _container = nil
        _context = nil
        
//        assert(oldContainer == nil)
//        assert(oldContext == nil)
    }
    
    private func _set(_container: NSPersistentContainer) {
        self._container = _container
    }
    
    private func _set(_context: NSManagedObjectContext) {
        self._context = _context
    }
}

@globalActor
fileprivate actor _CoreDataStackMap {
    static let shared: _CoreDataStackMap = .init()
    
    static func run<T: Sendable>(resultType: T.Type = T.self, body: @_CoreDataStackMap @Sendable () throws -> T) async rethrows -> T {
        return try await body()
    }
    
    private let containerMap: NSMapTable<NSString, NSPersistentContainer> = .strongToWeakObjects()
    private let contextMap: NSMapTable<NSString, NSManagedObjectContext> = .strongToWeakObjects()
    
    private init() {
        
    }
    
    func store(key: String, container: NSPersistentContainer?) {
        containerMap.setObject(container, forKey: key as NSString)
    }
    
    func store(key: String, context: NSManagedObjectContext?) {
        contextMap.setObject(context, forKey: key as NSString)
    }
    
    func load(key: String) -> NSPersistentContainer? {
        containerMap.object(forKey: key as NSString)
    }
    
    func load(key: String) -> NSManagedObjectContext? {
        contextMap.object(forKey: key as NSString)
    }
}
