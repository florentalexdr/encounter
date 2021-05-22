//
//  HeroCell.swift
//  encounter
//
//  Created by Florent Alexandre on 11/05/2021.
//

import SwiftUI

struct HeroCell: View {
    
    @ObservedObject var hero: Fighter
    
    var body: some View {
        VStack {
            HStack {
                
                HealthBar(barColor: .green, maximumHealthPoints: Int(hero.healthPoints), currentHealthPoints: Int(hero.currentHealthPoints))
                    .frame(width: 3)
                    .cornerRadius(2)
                
                Text(hero.name ?? "")
                    .foregroundColor(.primary)
                
                Text("(Init: \(hero.initiative))")
                    .foregroundColor(.secondary)
                
                TextField("0", value: $hero.currentHealthPoints, formatter: NumberFormatter(), onCommit: { PersistenceController.shared.save() })
                    .multilineTextAlignment(.trailing)
                
                Text("/ \(hero.healthPoints) HP")
                
            }
            ForEach(hero.fighterStatesArray) { state in
                HStack {
                    Spacer()
                        .frame(width: 11)
                    FighterStateView(fighterState: state)
                }
            }
        }
    }
}

struct HeroCell_Previews: PreviewProvider {
    static var previews: some View {
        let hero = Fighter()
        hero.name = "Ogion"
        hero.healthPoints = 10
        return HeroCell(hero: hero)
    }
}
