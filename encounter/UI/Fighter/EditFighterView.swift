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

    @ObservedObject var fighter: Fighter {
        didSet {
            healthPoints = Int(fighter.currentHealthPoints)
        }
    }
    
    // MARK: - Private Properties
    
    @Environment(\.managedObjectContext) private var viewContext

    @State private var healthPoints: Int?
    
    private var healthPointsProxy: Binding<String> {
        Binding<String>(
            get: {
                guard let numberOfEnemies = self.healthPoints else {
                    return ""
                }
                return  String(format: "%d", Int(numberOfEnemies))
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    healthPoints = value.intValue
                }
            }
        )
    }
    
    // MARK: - UI
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text(NSLocalizedString("Current HP", comment: ""))) {
                    TextField("100", text: healthPointsProxy)
                }
                Section(header: Text(NSLocalizedString("States", comment: ""))) {
                    List {
                        ForEach(fighter.fighterStatesArray) { state in
                            Text(FighterStateType(rawValue: state.stateType)?.localizedString ?? "")
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
                    AddFighterButton()
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

