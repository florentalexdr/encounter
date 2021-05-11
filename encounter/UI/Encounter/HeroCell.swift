//
//  HeroCell.swift
//  encounter
//
//  Created by Florent Alexandre on 11/05/2021.
//

import SwiftUI

struct HeroCell: View {
    @ObservedObject var hero: Hero
    
    var body: some View {
        HStack {
            Text(hero.name ?? "")
            TextField("HP", value: $hero.healthPoints, formatter: NumberFormatter())
            Stepper(
                onIncrement: {
                    hero.healthPoints += 1
                },
                onDecrement: {
                    hero.healthPoints -= 1
                }
                ,
                label: {
                    
                }
            )
        }
    }
}

struct HeroCell_Previews: PreviewProvider {
    static var previews: some View {
        let hero = Hero()
        hero.name = "Ogion"
        hero.healthPoints = 10
        return HeroCell(hero: hero)
    }
}
