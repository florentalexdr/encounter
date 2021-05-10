//
//  EnnemyCell.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI

struct EnnemyCell: View {
    
    
    @State private var enemy: Enemy = Enemy(id: 5, type: "gnome", number: "1", healthPoints: 10)

    var body: some View {
        HStack {
            Text(enemy.type + " " + enemy.number)
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
        EnnemyCell()
    }
}
