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
            Text((enemy.type ?? "") + " " + "\(enemy.number)")
                .foregroundColor(.primary)
            Text("(Init: \(enemy.initiative))")
                .foregroundColor(.secondary)
            TextField("0", value: $enemy.currentHealthPoints, formatter: NumberFormatter(), onCommit: { PersistenceController.shared.save() })
                .multilineTextAlignment(.trailing)
            Text("/ \(enemy.healthPoints) HP")
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
