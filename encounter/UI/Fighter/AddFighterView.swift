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

    enum FocusableField: Hashable {
        case name, enemyType, numberOfEnemies, healthPoints, initiative
    }

    @FocusState private var focusedField: FocusableField?

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
                                .focused($focusedField, equals: .name)
                                .onSubmit {
                                    focusedField = .initiative
                                }
                        }
                        Section(header: Text(NSLocalizedString("Initiative", comment: ""))) {
                            TextField("17", text: initiativeProxy)
                                .focused($focusedField, equals: .initiative)
                                .onSubmit {
                                    focusedField = .healthPoints
                                }
                        }
                        Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                            TextField("100", text: healthPointsProxy)
                                .focused($focusedField, equals: .healthPoints)
                        }
                    } else {
                        Section(header: Text(NSLocalizedString("Enemy type", comment: ""))) {
                            TextField("Gnome", text: $enemyType)
                                .focused($focusedField, equals: .enemyType)
                                .onSubmit {
                                    focusedField = .numberOfEnemies
                                }
                        }
                        Section(header: Text(NSLocalizedString("Number of enemies", comment: ""))) {
                            TextField("5", text: numberOfEnemiesProxy)
                                .focused($focusedField, equals: .numberOfEnemies)
                                .onSubmit {
                                    focusedField = .initiative
                                }
                        }
                        Section(header: Text(NSLocalizedString("Initiative", comment: ""))) {
                            TextField("17", text: initiativeProxy)
                                .focused($focusedField, equals: .initiative)
                                .onSubmit {
                                    focusedField = .healthPoints
                                }
                        }
                        Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                            TextField("100", text: healthPointsProxy)
                                .focused($focusedField, equals: .healthPoints)
                        }
                    }
                }
            }.navigationTitle(
                NSLocalizedString("Add fighter", comment: "")
            ).toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {

                        guard saveToDB() else {
                            showingAlert = true
                            return
                        }
                        isShowingAddFighter.toggle()
                    }) {
                        AddButton()
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

        var result: Bool = false
        if isHero {
            result = addHeroToDB()
        } else {
            result = addEnemiesToDB()
        }

        PersistenceController.shared.save()
        return result
    }

    private func addHeroToDB() -> Bool {
        guard name.isEmpty == false,
              let initiative = self.initiative else {
            return false
        }

        let hero = Fighter(context: managedObjectContext)
        hero.isHero = true
        hero.name = name
        if let healthPoints = self.healthPoints {
            hero.healthPoints = Int64(healthPoints)
            hero.currentHealthPoints = Int64(healthPoints)
        }
        hero.initiative = Int64(initiative)
        hero.index = 0

        return true
    }

    private func addEnemiesToDB() -> Bool {
        guard enemyType.isEmpty == false,
              let numberOfEnemies = self.numberOfEnemies,
              let initiative = self.initiative,
              let healthPoints = self.healthPoints else {
            return false
        }

        let startIndex = PersistenceController.shared.lastIndexForEnemy(type: enemyType) + 1
        let endIndex = startIndex + numberOfEnemies - 1
        for index in startIndex...endIndex {
            let enemy = Fighter(context: managedObjectContext)
            enemy.initiative = Int64(initiative)
            enemy.healthPoints = Int64(healthPoints)
            enemy.currentHealthPoints = Int64(healthPoints)
            enemy.index = Int64(index)
            enemy.name = enemyType + " " + "\(index)"
            enemy.isHero = false
        }

        return true
    }

}
