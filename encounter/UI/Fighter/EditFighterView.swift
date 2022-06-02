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
    
    struct ViewModel {
        
        var name: String
        
        var healthPoints: Int
        
        var currentHealthPoints: Int
        
        var isShowingAddState: Bool = false
        
        var onSave: (ViewModel) -> Void
        
        init(fighter: Fighter, onSave: @escaping (ViewModel) -> Void) {
            name = fighter.name ?? NSLocalizedString("Fighter", comment: "")
            healthPoints = Int(fighter.healthPoints)
            currentHealthPoints = Int(fighter.currentHealthPoints)
            self.onSave = onSave
        }
        
        func save() {
            onSave(self)
        }
        
    }
    
    // MARK: - Public Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @State var viewModel: ViewModel
    
    // MARK: - Private Properties
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                    TextField("100", value:  $viewModel.healthPoints, format: .number)
                }
                Section(header: Text(NSLocalizedString("Current HP", comment: ""))) {
                    TextField("100", value:  $viewModel.currentHealthPoints, format: .number)
                }
                Section(header: Text(NSLocalizedString("States", comment: ""))) {
                    List {
                       /* ForEach(fighter.fighterStatesArray) { state in
                            FighterStateView(fighterState: state)
                        }
                        .onDelete(perform: deleteItems)*/
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    viewModel.isShowingAddState.toggle()
                }) {
                    AddButton(title: NSLocalizedString("Add State", comment: ""))
                }
            }
        }
        .navigationTitle(
            viewModel.name
        )
        .sheet(isPresented: $viewModel.isShowingAddState, content: {
           // AddFighterStateView(isShowingAddFighterState: $viewModel.isShowingAddState, fighter: fighter)
        })
        .onDisappear {
            viewModel.save()
        }
    }
    
    // MARK: - Private methods
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
        /*    offsets.map { fighter.fighterStatesArray[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error in DB")
            }*/
        }
    }
    
}

