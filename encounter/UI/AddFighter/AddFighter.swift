//
//  AddEnemy.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import Foundation
import SwiftUI

struct AddFighterView: View {
    
    // MARK: - Public Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var isShowingAddFighter: Bool
    
    // MARK: - Private Properties
    
    @State private var name: String = ""
    
    @State private var enemyType: String = ""
    
    @State private var numberOfEnemies: Int?
    
    @State private var healthPoints: Int?
    
    @State private var initiative: Int?
    
    @State private var showingAlert = false
    
    @State private var isHero: Bool = true
    
    private var numberOfEnemiesProxy: Binding<String> {
        Binding<String>(
            get: {
                guard let numberOfEnemies = self.numberOfEnemies else {
                    return ""
                }
                return  String(format: "%d", Int(numberOfEnemies))
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    numberOfEnemies = value.intValue
                }
            }
        )
    }
    
    private var initiativeProxy: Binding<String> {
        Binding<String>(
            get: {
                guard let initiative = self.initiative else {
                    return ""
                }
                return  String(format: "%d", Int(initiative))
            },
            set: {
                if let value = NumberFormatter().number(from: $0) {
                    initiative = value.intValue
                }
            }
        )
    }
    
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
        NavigationView {
            VStack {
                Picker(
                    selection: $isHero,
                    label:
                        Text("Picker Name")
                    , content: {
                        Text("🧙‍♀️ Hero").tag(true)
                        Text("🧟‍♀️ Enemy").tag(false)
                    }
                )
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Form {
                    if isHero {
                        Section(header: Text(NSLocalizedString("Name", comment: ""))) {
                            TextField("Ogion", text: $name)
                        }
                        Section(header: Text(NSLocalizedString("Initiative", comment: ""))) {
                            TextField("20", text: initiativeProxy)
                        }
                        Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                            TextField("20", text: healthPointsProxy)
                        }
                    } else {
                        Section(header: Text(NSLocalizedString("Enemy type", comment: ""))) {
                            TextField("Gnome", text: $enemyType)
                        }
                        Section(header: Text(NSLocalizedString("Number of enemies", comment: ""))) {
                            TextField("5", text: numberOfEnemiesProxy)
                        }
                        Section(header: Text(NSLocalizedString("Initiative", comment: ""))) {
                            TextField("20", text: initiativeProxy)
                        }
                        Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                            TextField("20", text: healthPointsProxy)
                        }
                    }
                }}.navigationTitle(
                    NSLocalizedString("Add fighter", comment: "")
                ).toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(NSLocalizedString("Add", comment: "")) {
                            
                            guard saveToDB() else {
                                showingAlert = true
                                return
                            }
                            PersistenceController.shared.save()
                            isShowingAddFighter.toggle()
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(NSLocalizedString("Cancel", comment: "")) {
                            isShowingAddFighter.toggle()
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
        if isHero {
            return addHeroToDB()
        }
        
        return addEnemiesToDB()
    }
    
    private func addHeroToDB() -> Bool {
        guard name.isEmpty == false,
              let healthPoints = self.healthPoints,
              let initiative = self.initiative else {
            return false
        }
        
        let hero = Hero(context: managedObjectContext)
        hero.name = name
        hero.healthPoints = Int64(healthPoints)
        hero.initiative = Int64(initiative)
        
        return true
    }
    
    private func addEnemiesToDB() -> Bool {
        guard enemyType.isEmpty == false,
              let numberOfEnemies = self.numberOfEnemies,
              let initiative = self.initiative,
              let healthPoints = self.healthPoints else {
            return false
        }
        
        for index in 1...numberOfEnemies {
            let enemy = Enemy(context: managedObjectContext)
            enemy.type = enemyType
            enemy.initiative = Int64(initiative)
            enemy.healthPoints = Int64(healthPoints)
            enemy.number = Int64(index)
        }
        
        return true
    }
    
}
