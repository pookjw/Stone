import Foundation
import Testing
@testable @_private(sourceFile: "CoreDataStack.swift") @preconcurrency import StoneCore

actor CoreDataStackTests {
    private let stack: CoreDataStack = {
        let entity: NSEntityDescription = .init()
        entity.name = "TestModel"
        
        let numberAttribute: NSAttributeDescription = .init()
        numberAttribute.name = "number"
        numberAttribute.isOptional = false
        numberAttribute.attributeType = .integer64AttributeType
        
        entity.properties = [numberAttribute]
        
        let model: NSManagedObjectModel = .init()
        model.entities = [entity]
        
        let stack: CoreDataStack = .init(name: "Test", managedObjectModel: model)
        return stack
    }()
    
    init() async throws {
        try await stack.destory()
    }
    
    @Test func test_container() async throws {
        let _: NSPersistentContainer = try await stack.container
    }
    
    @Test(.tags([Tag(stringLiteral: "test_context")])) func test_context() async throws {
        let _: NSManagedObjectContext = try await stack.context
    }
}
