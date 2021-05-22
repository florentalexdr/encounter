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
    
    @Environment(\.presentationMode) var presentation
    
    @State var isShowingAddEnemy = false
    
    
    // MARK: - Private properties
    
    @State private var showingClearAlert = false
    
    @FetchRequest(
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Fighter.initiative, ascending: false),
            NSSortDescriptor(keyPath: \Fighter.index, ascending: true),
            NSSortDescriptor(keyPath: \Fighter.name, ascending: true),
        ],
        animation: .default)
    
    private var fighters: FetchedResults<Fighter>
            
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fighters) { fighter in
                    NavigationLink(destination: EditFighterView(fighter: fighter)) {
                        if !fighter.isHero {
                            EnnemyCell(enemy: fighter)
                        } else {
                            HeroCell(hero: fighter)
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isShowingAddEnemy.toggle()
                    }) {
                        AddButton()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        showingClearAlert.toggle()
                    }) {
                        HStack {
                            Image(systemName: "trash")
                            Text(NSLocalizedString("Clear", comment: ""))
                        }
                    }
                    .disabled(fighters.isEmpty)
                }
                ToolbarItem(placement: .bottomBar) {
                    Button(action: resolveRound) {
                        HStack {
                            Image(systemName: "goforward")
                            Text(NSLocalizedString("New round", comment: ""))
                        }
                    }
                    .disabled(fighters.isEmpty)
                }
            }
            .sheet(isPresented: $isShowingAddEnemy, content: {
                AddFighterView(isShowingAddFighter: $isShowingAddEnemy)
            })
            .alert(isPresented: $showingClearAlert) {
                Alert(
                    title: Text(NSLocalizedString("Warning", comment: "")),
                    message: Text(NSLocalizedString("Do you want to clear the encounter?", comment: "")),
                    primaryButton: .destructive(Text(NSLocalizedString("Delete", comment: "")), action: clearList),
                    secondaryButton: .default(Text(NSLocalizedString("Cancel", comment: "")))
                )
            }
            .navigationTitle(NSLocalizedString("Encounter ⚔️", comment: ""))
        }
    }
    
    // MARK: - Private methods
    
    private func resolveRound() {
        
        fighters.forEach { fighter in
            fighter.fighterStatesArray.forEach { fighterState in
                if fighterState.roundsLeft == 0 {
                    viewContext.delete(fighterState)
                } else {
                    fighterState.roundsLeft = fighterState.roundsLeft - 1
                }
            }
        }
        
        do {
            try viewContext.save()
        } catch {
            print("Error in DB")
        }
    }
    
    private func clearList() {
        fighters.forEach { viewContext.delete($0) }
        do {
            try viewContext.save()
        } catch {
            print("Error in DB")
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fighters[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error in DB")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        EncounterView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
