//
//  ActiveTurnView.swift
//  encounter
//
//  Created by Florent Alexandre on 23/05/2021.
//

import SwiftUI

struct ActiveTurnView: View {
    
    @ObservedObject var fighter: Fighter

    var body: some View {
        Circle()
            .foregroundColor(.purple)
            .frame(width: fighter.isCurrentTurn ? 8 : 0, height: fighter.isCurrentTurn ? 8 : 0)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: fighter.isCurrentTurn ? 8 : 0))
            .animation(.default)
    }
}


