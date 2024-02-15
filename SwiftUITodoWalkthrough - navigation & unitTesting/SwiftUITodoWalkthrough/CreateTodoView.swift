//
//  CreateToDoView.swift
//  SwiftUITodoWalkthrough
//
//  Created by shark boy on 1/23/24.
//

import SwiftUI

struct CreateTodoView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var todosController: TodosController
    
    @State var newTodoText = ""
    @State var selectedSection: TodoSection
    
    init(todoController: TodosController) {
        _todosController = ObservedObject(wrappedValue: todoController)
        _selectedSection = State(initialValue: todoController.sections[0])
    }
    
    var body: some View {
        VStack {
            Text("Create new todo")
                .font(.largeTitle)
                .fontWeight(.thin)
                .padding(.top)
            
            Spacer()
            
            HStack {
                TextField("todo", text: $newTodoText)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(.gray, style: StrokeStyle(lineWidth: 0.2))
                        
                        )
                    .padding()
                
                Picker("For Section", selection:  $selectedSection) {
                    ForEach(todosController.sections, id: \.self) { section in
                        Text(section.sectionTitle)

                        
                    }
                }
                .padding()
            }
            Spacer()
            
            VStack {
            Button {
                    addNewTodo(newTodoText, for: selectedSection)
                    
                } label: {
                 Text("Create")
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                        )
                }
            
                Button {
                    dismiss()
                    
                } label: {
                    Text("Cancel")
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                        RoundedRectangle(cornerSize: CGSize(width: 15, height: 15))
                            .stroke(.red)
                        )
                }
            }
            .padding()
        }
        .toolbar(.hidden)
    }
    
    func addNewTodo(_ todoTitle: String, for section: TodoSection) {
        if let section = todosController.sections.firstIndex(where: { $0 == section }) {
            todosController.sections[section].todos.append(Todo(markedComplete: false, title: todoTitle))
        }
            dismiss()
        
        
        
        
        
    }
}

#Preview {
    CreateTodoView(todoController: TodosController())
}

extension TodosController {
    
}
