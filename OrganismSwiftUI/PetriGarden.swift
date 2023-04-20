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
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Dish.timestamp, ascending: true)],
        animation: .default)
    private var dishes: FetchedResults<Dish>

    var body: some View {
        GeometryReader { proxy in
            VStack{
                NavigationView {
                    listOfDishes
                    .environment(\.defaultMinListHeaderHeight, 16)
                    .listStyle(.insetGrouped)
                    .toolbarBackground(Color.teal, for: .navigationBar, .tabBar, .bottomBar)
                    .toolbarBackground(.visible)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            EditButton().foregroundColor(Color.primary)
                        }
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: newDish) {
                                Label("Get A New Dish", systemImage: "plus").foregroundColor(Color.primary)
                            }
                        }
                    }
                    // 平板初始可见区
                    bgColor(.colorSky){ Text("Select a dish from Sideboard") }
                    // 平板初始可见区
                }
            }
        }
    }
}

extension View{
    func bgColor(_ color: Color, content: (()->some View)? = nil) -> some View{
        return ZStack {
            color.ignoresSafeArea()
            content?()
        }
    }
}

extension PetriGarden{
    
    private var listOfDishes: some View{
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
            .padding(.horizontal, 4)
        }
#if TARGET_OS_IPAD
        .padding(.top, 16.0)
#endif

    }
    
    private func newDish() {
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


struct PetriGarden_Previews: PreviewProvider {
    static var previews: some View {
        PetriGarden().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
