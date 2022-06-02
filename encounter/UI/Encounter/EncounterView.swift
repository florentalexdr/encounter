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
        ]) var fighters: FetchedResults<Fighter>
            
    // MARK: - UI
    
    var body: some View {
        NavigationView {
            List {
                ForEach(fighters) { fighter in
                    NavigationLink(destination: EditFighterView(viewModel:
                            .init(
                                fighter: fighter,
                                onSave: { edit in
                                    fighter.currentHealthPoints = Int64(edit.currentHealthPoints)
                                    fighter.healthPoints = Int64(edit.healthPoints)
                                    PersistenceController.shared.save()
                                }
                            ))) {
                        FighterCell(fighter: fighter)
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
                    Button(action: resolveTurn) {
                        HStack {
                            Image(systemName: "arrow.forward")
                            Text(NSLocalizedString("Next turn", comment: ""))
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
    
    private func resolveTurn() {
        
        guard let activePlayerIndex = fighters.firstIndex(where: { $0.isCurrentTurn }) else {
            
            fighters[0].isCurrentTurn = true
            
            do {
                try viewContext.save()
            } catch {
                print("Error in DB")
            }
            
            return
        }
        
        var newActivePlayerIndex = 0
        if activePlayerIndex < fighters.count - 1 {
            newActivePlayerIndex = activePlayerIndex + 1
        }
        
        fighters[activePlayerIndex].isCurrentTurn = false
        decreaseStates(of: fighters[activePlayerIndex])
        fighters[newActivePlayerIndex].isCurrentTurn = true
        
        do {
            try viewContext.save()
        } catch {
            print("Error in DB")
        }
    }
    
    private func decreaseStates(of fighter: Fighter) {
        fighter.fighterStatesArray.forEach { state in
            if state.turnsLeft <= 1 {
                viewContext.delete(state)
            } else {
                state.turnsLeft = state.turnsLeft - 1
            }
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
