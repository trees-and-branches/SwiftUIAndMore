# SwiftUI Todo Walkthrough

Clone this repository and follow along with the instructor. If you get behind or were absent, you can follow the steps below

## Goals

1. Setup the navigation stack
2. Be able to add new todos
3. Be able to delete todos

# Setup Navigation Stack

- Open up the TodoView file
- Add a NavigationStack around the VStack
- For this app we don't want to show the default navigation bar
    - Add the `.toolbar(.hidden)` view modifer inside the NavigationStack
- Done! The TodoView should look like the following at this point:
```Swift
struct TodoView: View {
    @State var todoSections = TodoSection.dummySections
    var body: some View {
        NavigationStack { // Added NavigationStack
            VStack {
                HStack{
                    Text("Todos").font(.title)
                        .padding(.leading, 25)
                    Spacer()
                }
                .padding()
                .frame(height: 40)
                
                List {
                    ForEach($todoSections) { $section in
                        Section(section.sectionTitle) {
                            ForEach($section.todos) { $todo in
                                TodoRowView(todo: $todo)
                            }
                        }
                    }
                }.listStyle(.inset)
            }.toolbar(.hidden) // Added view modifier
        }
    }
}
```

## Add new Todos
- Lets start by creating a button that navigates to an `AddTodoView`
    - In our `HStack`, lets create a NavigationLink that uses the `plus` SFSymbol as a label.
    - To position the label a bit better, I am going to add 25 points of trailing padding and make the font a title size with a thin weight.
    ```Swift
    NavigationLink {
        // TODO
    } label: {
        Image(systemName: "plus")
                .padding(.trailing, 25)
                .font(.title.weight(.thin))
    }
    ```
- Now create a new view called `CreateTodoView`
    - Our view is going to need to take in our array of `TodoSection` as an `@Binding` so we can add our new todo to it.
    ```Swift
    struct CreateTodoView: View {
    @Binding var todoSections: [TodoSection]
    var body: some View {
            // TODO
        }
    }

    struct CreateTodoView_Previews: PreviewProvider {
        static var previews: some View {
            CreateTodoView(todoSections: .constant(TodoSection.dummySections))
        }
    }
    ```
- Create the content for the view:
    ```Swift
        struct CreateTodoView: View {
            @Binding var todoSections: [TodoSection]
            @State var newTodoText = ""
            @State var selectedSection = ""
            var body: some View {
                VStack {
                    Text("Create New Todo")
                        .font(.largeTitle)
                        .fontWeight(.thin)
                        .padding(.top)
                    Spacer()
                    HStack {
                        TextField("Todo", text: $newTodoText)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(lineWidth: 0.2)))
                            .padding()
                        Picker("For Section", selection: $selectedSection) {
                            ForEach(todoSections, id: \.self) { section in
                                Text(section.sectionTitle)
                            }
                        }
                        .padding(.trailing)
                    }
                    Spacer()
                    VStack {
                        Button {
                            // Add new todo
                            
                            // Dismiss view
                            
                        } label: {
                            Text("Create")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                                .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).fill(.blue))
                        }
                        Button {
                            // Dismiss view
                            
                        } label: {
                            Text("Cancel")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                                .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).stroke(.red))
                        }
                    }
                    .padding()

                }
            }
        }
    ```
- Create New Todo Logic
    - Lets add a function to our view that takes in a todo title as a String and a sectionTitle as a string. This functions purpose will be to create a new todo and add that new todo to the correct TodoSection.
    - Take some time to try to figure out how to implement before looking at a possible solution below:
    ```Swift
    func addNewTodo(_ todoTitle: String, for sectionTitle: String) {
        if let sectionIndex = todoSections.firstIndex(where: { $0.sectionTitle == sectionTitle }) {
            todoSections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
        }
    }
    ```
    - Now we need to call that function in our submit button IF there is text inside our TextField.
    ```Swift
    Button {
        if !newTodoText.isEmpty {
            // Add new todo
            addNewTodo(newTodoText, for: selectedSection)
            // Dismiss view
            
        }
    } label: {
        Text("Create")
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).fill(.blue))
    }
    ```
- Dismiss our view
    - In order to be able to dismiss our view when the user taps the submit button or the Cancel button we need to access the `dismiss` function from the `@Environment` property wrapper. At the top of your view struct add the following:
    ```Swift
    @Environment(\.dismiss) var dismiss
    ```
    - Now run the dismiss function in both of the button actions
    - Great work! Your final `CreateTodoView` should look like this:
    ```Swift
    struct CreateTodoView: View {
        @Environment(\.dismiss) var dismiss
        
        @Binding var todoSections: [TodoSection]
        @State var newTodoText = ""
        @State var selectedSection = ""
        
        var body: some View {
            VStack {
                Text("Create New Todo")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .padding(.top)
                Spacer()
                HStack {
                    TextField("Todo", text: $newTodoText)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(lineWidth: 0.2)))
                        .padding()
                    Picker("For Section", selection: $selectedSection) {
                        ForEach(todoSections, id: \.self) { section in
                            Text(section.sectionTitle)
                        }
                    }
                    .padding(.trailing)
                }
                Spacer()
                VStack {
                    Button {
                        if !newTodoText.isEmpty {
                            // Add new todo
                            addNewTodo(newTodoText, for: selectedSection)
                            // Dismiss view
                            dismiss()
                        }
                    } label: {
                        Text("Create")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).fill(.blue))
                    }
                    Button {
                        // Dismiss view
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).stroke(.red))
                    }
                }
                .padding()

            }
        }
        
        func addNewTodo(_ todoTitle: String, for sectionTitle: String) {
            if let sectionIndex = todoSections.firstIndex(where: { $0.sectionTitle == sectionTitle }) {
                todoSections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
            }
        }
    }
    ```
## Debugging
- Go ahead and run your app and try to add an item. Notice any issues? When we navigate to the `Create New Todo` screen our picker shows a default section. If the user wants to add their new todo to that section they are not going to tap on the picker and reselect that section. This will keep our `selectedSection` as an empty string and will not properly add the new todo to the desired section.
- Lets make some edits to fix this user experience.
- First things first change our selectedSection to be a `TodoSection` rather than defaulting to an empty string.
```Swift
@State var selectedSection: TodoSection
```
- This will cause a plethora of errors. Lets first focus on making our `TodoSection` hashable
    - Switch over to the Todo.swift file
    - Add the `Hashable` protocol to both the `Todo` struct and the `TodoSection` struct.
    - Click the `fix it` button on the remaining error and implement the `==` func
    ```Swift
    struct TodoSection: Identifiable, Hashable {
        static func == (lhs: TodoSection, rhs: TodoSection) -> Bool {
            lhs.id == rhs.id
        }
        
        var id: UUID = UUID()
        var sectionTitle: String
        var todos: [Todo]
        
        
    }

    struct Todo: Identifiable, Hashable {
        var id: UUID = UUID()
        var markedComplete: Bool
        var title: String
    }
    ```
- Now go back to the `CreateTodoView` and find your `addNewTodo` function.
    - Change the function definition to take in an optional `TodoSection` instead of a string and change that parameter name to `section`
    - Update the where clause within the `firstIndex` closure to check equality between the sections as a whole rather than just the titles.
    ```Swift
    func addNewTodo(_ todoTitle: String, for section: TodoSection?) {
        if let sectionIndex = todoSections.firstIndex(where: { $0 == section }) {
            todoSections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
        }
    }
    ```
- Lastly we need to introduce a new concept you haven't learned yet. Everything we have done up to this point in the debugging phase has been done to initialize our view with a default section in `SelectedSection`
    - Rather than requiring us to pass in a default section we will create an init for our view that will default to the first section.
  ```Swift
    init(todoSections: Binding<[TodoSection]>) {
        self._todoSections = Binding(projectedValue: todoSections)
        self._selectedSection = State(initialValue: todosController.sections[0])
    }
  ```
    - Note the way we initialize our state and binding. We have to use the underscore version of our variables in order to initialize the variables properly. If we were to just say something like this: `self.todoSections = todoSections` we will not get the binding effect that we are expecting.
    - At this point our bug is fixed (as long as there are sections to add to, don't worry about that possible issue for right now)
    - Here is the view with all of our updates
    ```Swift
    struct CreateTodoView: View {
        @Environment(\.dismiss) var dismiss
        
        @Binding var todoSections: [TodoSection]
        @State var newTodoText = ""
        @State var selectedSection: TodoSection

        init(todoSections: Binding<[TodoSection]>) {
            self._todoSections = Binding(projectedValue: todoSections)
            self._selectedSection = State(initialValue: todosController.sections[0])
        }
        
        var body: some View {
            VStack {
                Text("Create New Todo")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .padding(.top)
                Spacer()
                HStack {
                    TextField("Todo", text: $newTodoText)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(lineWidth: 0.2)))
                        .padding()
                    Picker("For Section", selection: $selectedSection) {
                        ForEach(todoSections, id: \.self) { section in
                            Text(section.sectionTitle)
                        }
                    }
                    .padding(.trailing)
                }
                Spacer()
                VStack {
                    Button {
                        if !newTodoText.isEmpty {
                            // Add new todo
                            addNewTodo(newTodoText, for: selectedSection)
                            // Dismiss view
                            dismiss()
                        }
                    } label: {
                        Text("Create")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).fill(.blue))
                    }
                    Button {
                        // Dismiss view
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                            .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).stroke(.red))
                    }
                }
                .padding()
            }
        }
        
        func addNewTodo(_ todoTitle: String, for section: TodoSection?) {
            if let sectionIndex = todoSections.firstIndex(where: { $0 == section }) {
                todoSections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
            }
        }
    }
    ```
## Delete Todos
- After using our Todo App for more than a few days, users may start to feel overloaded with all the past todos that continue to stay in the list.
- Since we are using the `List` view to display our todos, deleting todos is pretty simple.
    - In the `TodoView` lets create a new function in our TodoView struct called `deleteTodo`.
    - Our function is going to take in an `IndexSet`, which is given to us from the `List` and a `TodoSection`
    ```Swift
    func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
        // TODO
    }
    ```
    - Our function will now need to first find the index of the `section` that got passed into the `deleteTodo` function
    - Once we find that index we can use the `.remove(atOffsets:)` on the `todos` array in that particular section to remove the desired todo
    ```Swift
    func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
        if let index = todoSections.firstIndex(of: section) {
            todoSections[index].todos.remove(atOffsets: offsets)            
        }
    }
    ```
    - Now in our inner `ForEach` in our `List` we can add the `.onDelete` modifier and use our `deleteTodo` function within it
    ```Swift
    ForEach($section.todos) { $todo in
        TodoRowView(todo: $todo)
    }
    .onDelete { offsets in
        deleteTodo(at: offsets, from: section)
    }
    ```
- Finished View:
```Swift
struct TodoView: View {
    @State var todoSections = TodoSection.dummySections
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Todos").font(.title)
                        .padding(.leading, 25)
                    Spacer()
                    NavigationLink {
                        CreateTodoView(todoSections: $todoSections)
                    } label: {
                        Image(systemName: "plus")
                                .padding(.trailing, 25)
                                .font(.title.weight(.thin))
                    }

                }
                .padding()
                .frame(height: 40)
                
                List {
                    ForEach($todoSections) { $section in
                        Section(section.sectionTitle) {
                            ForEach($section.todos) { $todo in
                                TodoRowView(todo: $todo)
                            }
                            .onDelete { offsets in
                                deleteTodo(at: offsets, from: section)
                            }
                        }
                    }
                }.listStyle(.inset)
            }.toolbar(.hidden)
        }
    }
    
    func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
        if let index = todoSections.firstIndex(of: section) {
            todoSections[index].todos.remove(atOffsets: offsets)
        }
    }
}
```
- Now when you run your app you should be able to delete todos.
## @State Debugging Shenanigans
- Originally this was the end of the walkthough. Since first making this, @State has caused some fun bugs that completly break the app. When you run the app you can only toggle a todo exactly once. After that you cannot make any updates to the todos. In order to fix this we have to use @StateObject. I have kept this as part of the walkthrough to help students further learn from this situation.
- To start fixing this bug, create a new file called `TodosController`
- This file will simply hold a class that contains our todoSections and inherits from `ObservableObject`
```Swift
class TodosController: ObservableObject {
    @Published var sections: [TodoSection]
    
    init() {
        self.sections = TodoSection.dummySections
    }
}
```
- Now open up the `TodoView` file. Here we are going to replace our todoSections with our todosController. Create the following line:
```Swift
@StateObject var todoController = TodosController()
```
- Go down to the `ForEach` and replace `$todoSections` with `$todoController.sections`
```Swift
ForEach($todoController.sections)
```
- Now replace the references to `todoSections` in the `deleteTodo` function with `todoController`
```Swift
func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
    if let index = todoController.sections.firstIndex(of: section) {
        todoController.sections[index].todos.remove(atOffsets: offsets)
    }
}
```
- Lets now move over to `CreateTodoView` and create an `@ObservedObject` for our todosController:
```Swift
@ObservedObject var todosController: TodosController
```
- Update our init:
```Swift
init(todosController: TodosController) {
    self._todosController = ObservedObject(wrappedValue: todosController)
    self._selectedSection = State(initialValue: todosController.sections[0])
}
```
- Update the forEach inside the picker
```Swift
ForEach(todosController.sections, id: \.self)
```
- Lastly update the references to todoSections in the `addNewTodo` function:
```Swift
func addNewTodo(_ todoTitle: String, for section: TodoSection?) {
    if let sectionIndex = todosController.sections.firstIndex(where: { $0 == section }) {
        todosController.sections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
    }
}
```
- Our `CreateTodoView` is now up to date and should look like the following:
```Swift
struct CreateTodoView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var todosController: TodosController
    @State var newTodoText = ""
    @State var selectedSection: TodoSection
    
    init(todosController: TodosController) {
        self._todosController = ObservedObject(wrappedValue: todosController)
        self._selectedSection = State(initialValue: todosController.sections[0])
    }
    
    var body: some View {
        VStack {
            Text("Create New Todo")
                .font(.largeTitle)
                .fontWeight(.thin)
                .padding(.top)
            Spacer()
            HStack {
                TextField("Todo", text: $newTodoText)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 15).stroke(.gray, style: StrokeStyle(lineWidth: 0.2)))
                    .padding()
                Picker("For Section", selection: $selectedSection) {
                    ForEach(todosController.sections, id: \.self) { section in
                        Text(section.sectionTitle)
                    }
                }
                .padding(.trailing)
            }
            Spacer()
            VStack {
                Button {
                    if !newTodoText.isEmpty {
                        // Add new todo
                        addNewTodo(newTodoText, for: selectedSection)
                        // Dismiss view
                        dismiss()
                    }
                } label: {
                    Text("Create")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).fill(.blue))
                }
                Button {
                    // Dismiss view
                    dismiss()
                } label: {
                    Text("Cancel")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
                        .background(RoundedRectangle(cornerSize: CGSize(width: 15, height: 15)).stroke(.red))
                }
            }
            .padding()
        }
    }
    
    func addNewTodo(_ todoTitle: String, for section: TodoSection?) {
        if let sectionIndex = todosController.sections.firstIndex(where: { $0 == section }) {
            todosController.sections[sectionIndex].todos.append(Todo(markedComplete: false, title: todoTitle))
        }
    }
}
```
- Navigate back to `TodoView`
- Update the navigationLink to CreateTodoView like so:
```Swift
NavigationLink {
    CreateTodoView(todosController: todoController)
}
```
- Now your `TodoView` should look like the following:
```Swift
struct TodoView: View {
    @StateObject var todoController = TodosController()
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack{
                    Text("Todos").font(.title)
                        .padding(.leading, 25)
                    Spacer()
                    NavigationLink {
                        CreateTodoView(todosController: todoController)
                    } label: {
                        Image(systemName: "plus")
                                .padding(.trailing, 25)
                                .font(.title.weight(.thin))
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
                            .onDelete { offsets in
                                deleteTodo(at: offsets, from: section)
                            }
                        }
                    }
                }.listStyle(.inset)
            }.toolbar(.hidden)
        }
    }
    
    func deleteTodo(at offsets: IndexSet, from section: TodoSection) {
        if let index = todoController.sections.firstIndex(of: section) {
            todoController.sections[index].todos.remove(atOffsets: offsets)
        }
    }
}
```
- The walkthrough is now complete 🎉
