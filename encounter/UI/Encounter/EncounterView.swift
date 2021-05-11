//
//  ContentView.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI
import CoreData

struct EncounterView: View {
    
    // MARK: - Public properties
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var isShowingAddEnemy = false
    
    // MARK: - Private properties
        
    @State private var showingClearAlert = false
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Fighter.initiative, ascending: false),
            NSSortDescriptor(keyPath: \Enemy.number, ascending: true)
        ],
        animation: .default)
    private var fighters: FetchedResults<Fighter>
    
    // MARK: - UI
    
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
                    Button(action: {
                        isShowingAddEnemy.toggle()
                    }) {
                        AddFighterButton()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingClearAlert.toggle()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text("Clear")
                        }
                    }.disabled(fighters.isEmpty)
                }
            }.sheet(isPresented: $isShowingAddEnemy, content: {
                AddFighterView(isShowingAddFighter: $isShowingAddEnemy)
            }).alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text(NSLocalizedString("Warning", comment: "")),
                    message: Text(NSLocalizedString("Do you want to clear the encounter?", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("Delete", comment: "")), action: clearList),
                    secondaryButton: .default(Text(NSLocalizedString("Cancel", comment: "")))
                )
            }.navigationTitle(NSLocalizedString("Encounter ⚔️", comment: ""))
        }
    }
    
    // MARJ: - Private methods
    
    private func clearList() {
        fighters.forEach { viewContext.delete($0) }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EncounterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
