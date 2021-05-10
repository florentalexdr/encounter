//
//  EnnemyCell.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI

struct EnnemyCell: View {

    @ObservedObject var enemy: Enemy

    var body: some View {
        HStack {
            Text(enemy.type! + " " + "\(enemy.number)")
            TextField("HP", value: $enemy.healthPoints, formatter: NumberFormatter())
            Stepper(
                onIncrement: {
                    enemy.healthPoints += 1
                },
                onDecrement: {
                    enemy.healthPoints -= 1
                }
                ,
                label: {
                    
                }
            )
        }
    }
}

struct EnnemyCell_Previews: PreviewProvider {
    static var previews: some View {
        let newEnemy = Enemy()
        newEnemy.type = "Gnome"
        newEnemy.number = 1
        newEnemy.healthPoints = 10
        return EnnemyCell(enemy: newEnemy)
    }
}
