import SwiftUI
import CoreData

struct ContentView: View {
    @State private var name: String = ""

    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    var body: some View {
        NavigationView {
            VStack {
                AddItemRow(name: $name, addItem: addItem)
                List {
                    ForEach(items) { item in
                        NavigationLink(destination: WordView(item: item)) {
                            TextForItem(item: item)
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
                .listStyle(PlainListStyle())
            }
            .navigationBarTitle("Words")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    HStack {
                        #if os(iOS)
                        EditButton()
                        #endif
                    }
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.name = name
            name = ""

            do {
                try viewContext.save()
            } catch {
                fatal(error: error)
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                fatal(error: error)
            }
        }
    }
}

struct WordView: View {
    var item: Item
    var body: some View {
        Text("\(item.name ?? "[empty]")")
    }
}

struct TextForItem: View {
    var item: Item
    var body: some View {
        Text("\(item.name ?? "[empty]") @ \(item.timestamp!, formatter: itemFormatter)")
    }

    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
}

struct AddItemRow: View {
    @Binding var name: String
    var addItem: () -> Void
    
    var body: some View {
        HStack {
            TextField("Enter a word", text: $name, onCommit: addItem)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
                .padding(.leading, 8)
            Button(action: addItem) {
                HStack{
                    Text("Add").padding(.trailing, 4)
                    Image(systemName: "plus.circle")
                }.padding(10)
                .foregroundColor(.white)
                .background(Color.accentColor)
                .cornerRadius(8)
            }
            .padding(.trailing, 8)
        }
    }
}

func fatal(error: Error) {
    // Replace this implementation with code to handle the error appropriately.
    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
    let nsError = error as NSError
    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        }
    }
}


