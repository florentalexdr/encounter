//
//  ContentView.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI
import CoreData

struct EncounterView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State var isShowingAddEnemy = false

    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Fighter.initiative, ascending: false),
            NSSortDescriptor(keyPath: \Enemy.number, ascending: true)
        ],
        animation: .default)
    
    private var fighters: FetchedResults<Fighter>

    var body: some View {
        NavigationView {
            List {
                ForEach(fighters) { fighter in
                    if let enemy = fighter as? Enemy {
                        EnnemyCell(enemy: enemy)
                    } else if let hero = fighter as? Hero {
                        HeroCell(hero: hero)
                    }
                }
                .onDelete(perform: deleteItems)
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        isShowingAddEnemy.toggle()
                    }
                }
            }.sheet(isPresented: $isShowingAddEnemy, content: {
                AddFighterView(isShowingAddFighter: $isShowingAddEnemy)
            }).navigationTitle(NSLocalizedString("Encounter", comment: ""))
        }
    }


    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fighters[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EncounterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
