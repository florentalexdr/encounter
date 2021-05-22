//
//  EditFighterView.swift
//  encounter
//
//  Created by Florent Alexandre on 22/05/2021.
//

import SwiftUI

extension Fighter {
    
    var fighterStatesArray: [FighterState] {
        let set = states as? Set<FighterState> ?? []
        return set.sorted {
            $0.id < $1.id
        }
    }
    
}

struct EditFighterView: View {
    
    // MARK: - Public Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @State var isShowingAddState = false

    @ObservedObject var fighter: Fighter
    
    // MARK: - Private Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(NSLocalizedString("Current HP", comment: ""))) {
                    TextField("100", value: $fighter.currentHealthPoints, formatter: NumberFormatter(), onCommit: { PersistenceController.shared.save() })
                }
                Section(header: Text(NSLocalizedString("States", comment: ""))) {
                    List {
                        ForEach(fighter.fighterStatesArray) { state in
                            FighterStateView(fighterState: state)
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isShowingAddState.toggle()
                }) {
                    AddButton(title: NSLocalizedString("Add State", comment: ""))
                }
            }
        }
        .navigationTitle(
            fighter.name ?? NSLocalizedString("Fighter", comment: "")
        )
        .sheet(isPresented: $isShowingAddState, content: {
            AddFighterStateView(isShowingAddFighterState: $isShowingAddState, fighter: fighter)
        })
    }
    
    // MARK: - Private methods
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { fighter.fighterStatesArray[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error in DB")
            }
        }
    }
    
}

