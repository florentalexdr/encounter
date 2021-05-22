//
//  FighterStateView.swift
//  encounter
//
//  Created by Florent Alexandre on 22/05/2021.
//

import SwiftUI

struct FighterStateView: View {
    
    // MARK: - Public Properties
    
    @ObservedObject var fighterState: FighterState
    
    // MARK: - UI
    
    var body: some View {
        HStack {
            Text(FighterStateType(rawValue: fighterState.stateType)?.localizedString ?? "")
                .foregroundColor(.primary)
            Spacer()
            Text("\(fighterState.roundsLeft)" + " " + NSLocalizedString("rounds left", comment: ""))
                .foregroundColor(.secondary)
        }
    }
}
