//
//  ContentView.swift
//  TodoList
//
//  Created by Alley Pereira on 25/10/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var newTask: String = ""
    @State var taskReminders: [TodoList] = []
    
    var body: some View {
        NavigationView {
            ZStack { // Quando não tiver tarefas, a Zstack ficará por cima dos meus reminders
                //MARK: - FORM
                Form {
                    Section {
                        TextField("Add reminders", text: $newTask)
                    }
                    Section(header: Text("My reminders")) {
                        // se taskReminders for vazio, [] ele só pula
                        // se taskReminders tiver items [1, 2, 3] ele entra uma vez pra cada item.
                        ForEach(taskReminders) { reminder in
                            Text(reminder.reminders!)
                        } .onDelete(perform: removeTasks(at:))
                    }
                }
                .navigationTitle("Reminders")
                .navigationBarItems(trailing:
                                        Button(
                                            action: {
                                                
                                                let task = TodoList(context: viewContext)
                                                task.reminders = newTask
                                                task.id = UUID()
                                                print(newTask)
                                                
                                                do {
                                                    try viewContext.save()
                                                    taskReminders.append(task)
                                                    newTask = "" // deleta o que ficou no textfield ao digitar uma tarefa
                                                } catch {
                                                    print(error.localizedDescription)
                                                }
                                            }, label: {
                                                Image(systemName: "plus").imageScale(.large)
                                            }
                                        )
                )
                //MARK: - Empty State
                if taskReminders.isEmpty { // se estiver vazia, mostrará que não tem tasks adicionadas.
                    Text("No Reminders here.\n\nType a new reminder at the top of the screen and press the plus button to add.")
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(100)
                }
            }
        }
        .onAppear { // Roda o codigo assim que a tela recarregar (ViewDidAppear no UIKit)
            let fetchRequest = NSFetchRequest<TodoList>(entityName: "TodoList") // busca o que ta persistido no coredata assim que abrimos a tela, carrega no array e o array carreg a lista na tela
            if let fetchedReminders = try? viewContext.fetch(fetchRequest) {
                // print(fetchedReminders)
                taskReminders = fetchedReminders
            }
        }
    }
    //MARK: - Remove rows to list
    func removeTasks(at offsets: IndexSet){
        let deletedItem = taskReminders[offsets.first!] // acessa o item que recebe o onDelete e armazena em uma variavel
        viewContext.delete(deletedItem) //Deletando do Coredata
        do {
            try viewContext.save() // persistindo a deleção
            taskReminders.remove(atOffsets: offsets)
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
