//
//  EnnemyCell.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI

struct EnnemyCell: View {

    @ObservedObject var enemy: Fighter
    
    var body: some View {
        VStack {
            HStack {
                HealthBar(barColor: .red, maximumHealthPoints: Int(enemy.healthPoints), currentHealthPoints: Int(enemy.currentHealthPoints))
                    .frame(width: 3)
                    .cornerRadius(2)
                
                Text(enemy.name ?? "")
                    .foregroundColor(.primary)
                
                Text("(Init: \(enemy.initiative))")
                    .foregroundColor(.secondary)
                
                TextField("0", value: $enemy.currentHealthPoints, formatter: NumberFormatter(), onCommit: { PersistenceController.shared.save() })
                    .multilineTextAlignment(.trailing)
                
                Text("/ \(enemy.healthPoints) HP")
            }
            ForEach(enemy.fighterStatesArray) { state in
                HStack {
                    Spacer()
                        .frame(width: 11)
                    FighterStateView(fighterState: state)
                }
            }
        }
    }
}

struct EnnemyCell_Previews: PreviewProvider {
    static var previews: some View {
        let newEnemy = Fighter()
        newEnemy.name = "Gnome"
        newEnemy.healthPoints = 10
        return EnnemyCell(enemy: newEnemy)
    }
}
