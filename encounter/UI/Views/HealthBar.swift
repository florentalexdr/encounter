//
//  HealthBar.swift
//  encounter
//
//  Created by Florent Alexandre on 12/05/2021.
//

import Foundation

import SwiftUI

struct HealthBar: View {
    
    var barColor: Color
    
    var maximumHealthPoints: Int?

    var currentHealthPoints: Int?

    var body: some View {
        ZStack {
            GeometryReader { (geometry) in
                Rectangle()
                    .frame(width: 3)
                    .foregroundColor(barColor)
                Rectangle()
                    .frame(
                        width: 3,
                        height: geometry.size.height - (geometry.size.height * (CGFloat(currentHealthPoints ?? 1) / CGFloat(maximumHealthPoints ?? 1)))
                    )
                    .foregroundColor(.black)
                    .opacity(0.4)
            }
        }
    }
}

struct HealthBar_Previews: PreviewProvider {
    static var previews: some View {
        HealthBar(barColor: .green, maximumHealthPoints: 100, currentHealthPoints: 20)
    }
}
