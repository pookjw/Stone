@_exported import CoreData
import Atomics

public actor CoreDataStack: NSObject {
    private static let containerMap: ManagedAtomic<Unmanaged<NSMapTable<NSString, NSPersistentContainer>>> = .init(.passRetained(.strongToWeakObjects()))
    
    public var container: NSPersistentContainer {
        get async throws {
            if let _container: NSPersistentContainer {
                return _container
            }
            
            let container: NSPersistentContainer = try await createContainer()
            _container = container
            return container
        }
    }
    
    public var context: NSManagedObjectContext {
        get async throws {
            if let _context: NSManagedObjectContext {
                return _context
            }
            
            let context: NSManagedObjectContext = try await createContext()
            _context = context
            return context
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
    
    public init(name: String, managedObjectModel: NSManagedObjectModel) {
        self.name = name
        self.managedObjectModel = managedObjectModel
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
}
