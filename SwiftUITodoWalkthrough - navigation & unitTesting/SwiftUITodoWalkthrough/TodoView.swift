//
//  TodoView.swift
//  SwiftUITodoWalkthrough
//
//  Created by Brayden Lemke on 10/2/23.
//

import SwiftUI

struct TodoView: View {
    @StateObject var todoController = TodosController()
    
    @State var showModal = false
    
    var body: some View {
        NavigationStack {
            
            VStack {
                HStack{
                    Text("Todos").font(.title)
                        .padding(.leading, 25)
                    Spacer()
                    Button {
                        showModal = true
                    } label: {
                        Text("New Section")
                            .tint(.green)
                    }
                    .sheet(isPresented: $showModal) {
                        addSectionView(todoController: todoController)
                    }
                    
                    
                    NavigationLink {
                            CreateTodoView(todoController: todoController)
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title.weight(.thin))
                            .padding(.trailing, 25)
                    }
                }
                .padding()
                .frame(height: 40)
                
                List {
                    ForEach($todoController.sections) { $section in
                        Section(section.sectionTitle) {
                            ForEach($section.todos) { $todo in
                                TodoRowView(todo: $todo)
                            }
                            .onDelete { indexSet in
                                deleteTodo(at: indexSet, from: section)
                            }
                        }
                    }
                }
                .listStyle(.inset)
            }
            .toolbar(.hidden)
        }
    }
    
    func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
        if let index = todoController.sections.firstIndex(of: section) {
            todoController.sections[index].todos.remove(atOffsets: offsets)
        }
    }
}

struct addSectionView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var todoController: TodosController
    
    init(todoController: TodosController) {
        _todoController = ObservedObject(wrappedValue: todoController)
    }
    
    @State var sectionText = ""
    
    var body: some View {
        VStack {
            TextField("Section Name", text: $sectionText)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(.gray, style: StrokeStyle(lineWidth: 0.2))
                    
                    )
                .padding()
            
            
            Button {
                
                addNewSection(sectionName: sectionText)
                dismiss()
                
            } label: {
            Text("Add section")
                    .foregroundStyle(.white)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                    )
                    
            }
        }
    }
    func addNewSection(sectionName: String) {
        todoController.sections.append(TodoSection(sectionTitle: sectionName, todos: [Todo(markedComplete: false, title: "new")]))
    }
    
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        TodoView()
        addSectionView(todoController: TodosController())
    }
}
