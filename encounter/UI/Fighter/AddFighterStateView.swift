//
//  AddFighterStateView.swift
//  encounter
//
//  Created by Florent Alexandre on 22/05/2021.
//

import SwiftUI

enum FighterStateType: Int64, CaseIterable, Identifiable {
    
    case prone
    case grappled
    case defeaned
    case blinded
    case charmed
    case frighetened
    case poisoned
    case restrained
    case stunned
    case incapacitated
    case unconscious
    case invisible
    case paralyzed
    case petrified
    
    var localizedString: String {
        switch self {
            case .prone: return NSLocalizedString("Prone", comment: "")
            case .grappled: return NSLocalizedString("Grappled", comment: "")
            case .defeaned: return NSLocalizedString("Defeaned", comment: "")
            case .blinded: return NSLocalizedString("Blinded", comment: "")
            case .charmed: return NSLocalizedString("Charmed", comment: "")
            case .frighetened: return NSLocalizedString("Frighetened", comment: "")
            case .poisoned: return NSLocalizedString("Poisoned", comment: "")
            case .restrained: return NSLocalizedString("Restrained", comment: "")
            case .stunned: return NSLocalizedString("Stunned", comment: "")
            case .incapacitated: return NSLocalizedString("Incapacitated", comment: "")
            case .unconscious: return NSLocalizedString("Unconscious", comment: "")
            case .invisible: return NSLocalizedString("Invisible", comment: "")
            case .paralyzed: return NSLocalizedString("Paralyzed", comment: "")
            case .petrified: return NSLocalizedString("Petrified", comment: "")
            
        }
    }
    
    var id: Int64 { self.rawValue }
}

struct AddFighterStateView: View {
    
    // MARK: - Public Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var isShowingAddFighterState: Bool
    
    @ObservedObject var fighter: Fighter

    // MARK: - Private Properties
    
    @State private var fighterState = FighterStateType.prone

    @State private var turnsLeft: Int?
    
    @State private var showingAlert = false
    
    private var turnsLeftProxy: Binding<String> {
        Binding<String>(
            get: {
                guard let turnsLeft = self.turnsLeft else {
                    return ""
                }
                return  String(format: "%d", Int(turnsLeft))
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    turnsLeft = value.intValue
                }
            }
        )
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text(NSLocalizedString("State", comment: ""))) {
                        Picker(NSLocalizedString("\(fighterState.localizedString)", comment: ""), selection: $fighterState) {
                            ForEach(FighterStateType.allCases) { stateType in
                                Text(stateType.localizedString).tag(stateType)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                    }
                    Section(header: Text(NSLocalizedString("Number of turns", comment: ""))) {
                        TextField("5", text: turnsLeftProxy)
                    }
                }}.navigationTitle(
                    NSLocalizedString("Add state", comment: "")
                ).toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            
                            guard saveToDB() else {
                                showingAlert = true
                                return
                            }
                            isShowingAddFighterState.toggle()
                        }) {
                            AddButton(title: NSLocalizedString("Add State", comment: ""))
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(NSLocalizedString("Cancel", comment: "")) {
                            isShowingAddFighterState.toggle()
                        }
                    }
                }.alert(isPresented: $showingAlert) {
                    Alert(
                        title: Text(NSLocalizedString("Error", comment: "")),
                        message: Text(NSLocalizedString("Fill all fields before adding.", comment: "")),
                        dismissButton: .default(Text(NSLocalizedString("Got it!", comment: "")))
                    )
                }
        }
    }
    
    // MARK : - Private Methods
    
    private func saveToDB() -> Bool {
        
        guard let turnsLeft = turnsLeft else {
            return false
        }
        
        let fighterState = FighterState(context: managedObjectContext)
        fighterState.turnsLeft = Int64(turnsLeft)
        fighterState.stateType = self.fighterState.rawValue
        
        fighter.addToStates(fighterState)
        
        PersistenceController.shared.save()
        return true
    }
}

