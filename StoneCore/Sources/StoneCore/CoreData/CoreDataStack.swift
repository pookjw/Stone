@_exported @preconcurrency import CoreData

@objc(CoreDataStack)
public actor CoreDataStack: NSObject {
    public var container: NSPersistentContainer {
        get async throws {
            if let _container: NSPersistentContainer {
                return _container
            } else if let container: NSPersistentContainer = await _CoreDataStackMap.shared.load(key: name) {
                _container = container
                return container
            } else {
                let container: NSPersistentContainer = try await createContainer()
                _container = container
                await _CoreDataStackMap.shared.store(key: name, container: container)
                return container
            }
        }
    }
    
    public var context: NSManagedObjectContext {
        get async throws {
            if let _context: NSManagedObjectContext {
                return _context
            } else if let context: NSManagedObjectContext = await _CoreDataStackMap.shared.load(key: name) {
                _context = context
                return context
            } else {
                let context: NSManagedObjectContext = try await createContext()
                _context = context
                await _CoreDataStackMap.shared.store(key: name, context: context)
                return context
            }
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
    
    @objc
    public init(name: String, managedObjectModel: NSManagedObjectModel) {
        self.name = name
        self.managedObjectModel = managedObjectModel
    }
    
    @objc
    public func container() async throws -> NSPersistentContainer {
        try await container
    }
    
    @objc
    public func context() async throws -> NSManagedObjectContext {
        try await context
    }
    
    private func createContainer() async throws -> NSPersistentContainer {
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
    
    private func createContext() async throws -> NSManagedObjectContext {
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
        
        assert(oldContainer == nil)
        assert(oldContext == nil)
    }
}

@globalActor
fileprivate actor _CoreDataStackMap {
    static let shared: _CoreDataStackMap = .init()
    
    private let containerMap: NSMapTable<NSString, NSPersistentContainer> = .strongToWeakObjects()
    private let contextMap: NSMapTable<NSString, NSManagedObjectContext> = .strongToWeakObjects()
    
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
