//
//  SwiftUITodoWalkthroughTests.swift
//  SwiftUITodoWalkthroughTests
//
//  Created by shark boy on 2/1/24.
//

import XCTest
@testable import SwiftUITodoWalkthrough

let todoController = TodosController()
let createTodoView = CreateTodoView(todoController: todoController)
let todoView = TodoView()
let todoSections = todoController.sections

final class SwiftUITodoWalkthroughTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    
    func testAddNewTodo() throws {
        // Given
        let todoTitle = "Test Todo"
        
        

        // When
        createTodoView.addNewTodo(todoTitle, for: todoController.sections[0])

        // Then
        // Add assertions to check if the todo was added successfully
        XCTAssertTrue(todoController.sections[0].todos.contains { $0.title == todoTitle })
    }
    
    func testDeleteTodo() throws {
        let todoTitle = "Test Todo"
        
        

        // When
        createTodoView.addNewTodo(todoTitle, for: todoController.sections[0])

        
        
        let indexSet = IndexSet(arrayLiteral: 1)
        
        
        
        todoView.deleteTodo(at: indexSet, from: todoController.sections[0])
        
        print(todoController.sections)
        
        print(indexSet)
        print(todoController.sections[0].todos)
        
        XCTAssertFalse(todoController.sections[0].todos.contains { $0.title == todoTitle })
        
    }
    
    

}
