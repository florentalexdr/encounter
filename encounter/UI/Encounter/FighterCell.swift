//
//  EnnemyCell.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import SwiftUI

struct FighterCell: View {
    
    @ObservedObject var fighter: Fighter
    
    var body: some View {
        HStack {
            ActiveTurnView(fighter: fighter)
            VStack {
                HStack {
                    
                    HealthBar(
                        barColor: fighter.isHero ? .green : .red,
                        maximumHealthPoints: fighter.healthPoints > 0 ? Int(fighter.healthPoints) : nil,
                        currentHealthPoints: fighter.healthPoints > 0 ? Int(fighter.currentHealthPoints) : nil
                    )
                        .frame(width: 3)
                        .cornerRadius(2)
                    
                    Text(fighter.name ?? "")
                        .foregroundColor(.primary)
                        .layoutPriority(1)
                    
                    Text("(Init: \(fighter.initiative))")
                        .foregroundColor(.secondary)
                    
                    if fighter.healthPoints > 0 {

                        TextField("0", value: $fighter.currentHealthPoints, formatter: NumberFormatter(), onCommit: { PersistenceController.shared.save() })
                            .multilineTextAlignment(.trailing)

                        
                        Text("/ \(fighter.healthPoints) HP")
                            .lineLimit(1)

                    }

                }
                ForEach(fighter.fighterStatesArray) { state in
                    HStack {
                        Spacer()
                            .frame(width: 11)
                        FighterStateView(fighterState: state)
                    }
                }
            }
            .animation(.default)
        }
    }
}

