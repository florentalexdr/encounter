//
//  AddEnemy.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import Foundation
import SwiftUI

struct AddEnemyView: View {
    
    // MARK: - Public Properties
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @Binding var isShowingAddEnemy: Bool

    @State private var enemyType: String = ""
    
    // MARK: - Private Properties
    
    @State private var numberOfEnemies: Int?
    
    @State private var healthPoints: Int?
    
    @State private var showingAlert = false
    
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
            Form {
                Section(header: Text(NSLocalizedString("Enemy type", comment: ""))) {
                    TextField("Gnome", text: $enemyType)
                }
                Section(header: Text(NSLocalizedString("Number of enemies", comment: ""))) {
                    TextField("5", text: numberOfEnemiesProxy)
                }
                Section(header: Text(NSLocalizedString("Maximum HP", comment: ""))) {
                    TextField("20", text: healthPointsProxy)
                }
            }.navigationTitle(
                NSLocalizedString("Add Enemy", comment: "")
            ).toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(NSLocalizedString("Add", comment: "")) {
                        guard addEnemiesToDB() else {
                            showingAlert = true
                            return
                        }
                        PersistenceController.shared.save()
                        isShowingAddEnemy.toggle()
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(NSLocalizedString("Cancel", comment: "")) {
                        isShowingAddEnemy.toggle()
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
    
    private func addEnemiesToDB() -> Bool {
        guard let numberOfEnemies = self.numberOfEnemies,
              let healthPoints = self.healthPoints else {
            return false
        }
        
        for index in 1...numberOfEnemies {
            let enemy = Enemy(context: managedObjectContext)
            enemy.type = enemyType
            enemy.healthPoints = Int64(healthPoints)
            enemy.number = Int64(index)
        }
        
        return true
    }
    
}
