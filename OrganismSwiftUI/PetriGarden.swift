//
//  PetriGarden.swift
//  OrganismSwiftUI
//
//  Created by 张文涛 on 2023/4/14.
//

import SwiftUI
import CoreData

struct PetriGarden: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.timestamp, ascending: true)],
        animation: .default)
    private var dishes: FetchedResults<Dish>

    var body: some View {
        GeometryReader { proxy in
            VStack{
                NavigationView {
                    List {
                        ForEach(dishes) { dish in
                            NavigationLink {
                                Text("Dish at \(dish.timestamp!, formatter: itemFormatter)").modifier(BgColor())
                            } label: {
                                Text(dish.timestamp!, formatter: itemFormatter)
                            }
                        }
                        .onDelete(perform: deleteItems)
                        .listRowBackground(Color.colorBarDrinks)
                    }
                    .environment(\.defaultMinListHeaderHeight, 16)
                    .listStyle(.insetGrouped)
                    .toolbarBackground(Color.teal, for: .navigationBar, .tabBar, .bottomBar)
                    .toolbarBackground(.visible)
                    .toolbar {
#if TARGET_OS_IPAD
                        ToolbarItem(placement: .navigationBarLeading) {
                            EditButton().foregroundColor(Color.primary)

                        }
#else
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton().foregroundColor(Color.primary)
                        }
#endif
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: addItem) {
                                Label("Add Dish", systemImage: "plus").foregroundColor(Color.primary)
                            }
                        }
                    }
                    // 平板初始可见区
                    Text("Select an dish").modifier(BgColor())
                    // 平板初始可见区
                }
            }
        }
    }
}

extension View{
    
}

extension PetriGarden{
    private func addItem() {
        withAnimation {
            let newDish = Dish(context: viewContext)
            newDish.timestamp = Date()

            do {
                try viewContext.save()
            } catch {
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { dishes[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct PetriGarden_Previews: PreviewProvider {
    static var previews: some View {
        PetriGarden().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
