//
//  AddEnemy.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import Foundation
import SwiftUI

struct AddEnemyView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext

    @Environment(\.presentationMode) var presentationMode
    
    @State private var enemyType: String = ""
    
    @State private var numberOfEnemies: Int = 0
    
    @State private var healthPoints: Int = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enemy type", text: $enemyType)
                TextField("Number of enemies", value: $numberOfEnemies, formatter: NumberFormatter())
                TextField("HP", value: $healthPoints, formatter: NumberFormatter())
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        for index in 1...numberOfEnemies {
                            let enemy = Enemy(context: managedObjectContext)
                            enemy.type = enemyType
                            enemy.healthPoints = Int64(healthPoints)
                            enemy.number = Int64(index)
                        }
                        PersistenceController.shared.save()
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        
    }
    
}
