import Foundation
@preconcurrency import CoreData
import Testing
@testable @_private(sourceFile: "CoreDataStack.swift") import StoneCore

actor CoreDataStackTests {
    private lazy var stack: CoreDataStack = makeStack()
    
    init() async throws {
        try await stack.destory()
    }
    
    @Test(.tags(["test_container"])) func test_container() async throws {
        let _: NSPersistentContainer = try await stack.container
    }
    
    @Test(.tags(["test_context"])) func test_context() async throws {
        let _: NSManagedObjectContext = try await stack.context
    }
    
    @Test(.tags(["test_saveAndFetch"]), arguments: 0..<100) func test_saveAndFetch(number: Int) async throws {
        let context: NSManagedObjectContext = try await stack.context
        
        try await context.perform {
            let entity: NSEntityDescription = try #require(NSEntityDescription.entity(forEntityName: "TestModel", in: context))
            let model_1: NSManagedObject = .init(entity: entity, insertInto: context)
            model_1.setValue(number, forKey: "number")
            
            try context.save()
            
            let fetchRequest: NSFetchRequest<NSManagedObject> = try .init(entityName: #require(entity.name))
            let fetchedObjects: [NSManagedObject] = try context.fetch(fetchRequest)
            #expect(fetchedObjects.count == 1)
            let model_2: NSManagedObject = try #require(fetchedObjects.first)
            
            let number_2: Int = try #require(model_2.value(forKey: "number") as? Int)
            #expect(number_2 == number)
        }
    }
    
    @Test(.tags(["test_destory"])) func test_destory() async throws {
        weak var container: NSPersistentContainer? = try await stack.container
        weak var context: NSManagedObjectContext? = try await stack.context
        
        try await stack.destory()
        
        #expect(container == nil)
        #expect(context == nil)
    }
    
    @Test(.tags(["test_StackMap"])) func test_StackMap() async throws {
        var stack_1: CoreDataStack? = makeStack()
        var stack_2: CoreDataStack? = makeStack()
        
        weak var container_1: NSPersistentContainer? = try await stack_1?.container
        weak var container_2: NSPersistentContainer? = try await stack_2?.container
        
        #expect(container_1 == container_2)
        
        weak var context_1: NSManagedObjectContext? = try await stack_1?.context
        weak var context_2: NSManagedObjectContext? = try await stack_2?.context
        
        #expect(context_1 == context_2)
        
        stack_1 = nil
        stack_2 = nil
        
        #expect(container_1 == nil)
        #expect(container_2 == nil)
        #expect(context_1 == nil)
        #expect(context_2 == nil)
    }
    
    private func makeStack() -> CoreDataStack {
        let model: NSManagedObjectModel = .init()
        let entity: NSEntityDescription = .init()
        entity.name = "TestModel"
        
        let numberAttribute: NSAttributeDescription = .init()
        numberAttribute.name = "number"
        numberAttribute.isOptional = false
        numberAttribute.attributeType = .integer64AttributeType
        
        entity.properties = [numberAttribute]
        
        model.entities = [entity]
        
        return .init(name: "Test", managedObjectModel: model)
    }
}
