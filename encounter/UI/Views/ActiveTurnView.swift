//
//  ActiveTurnView.swift
//  encounter
//
//  Created by Florent Alexandre on 23/05/2021.
//

import SwiftUI

struct ActiveTurnView: View {
    var body: some View {
        Circle()
            .frame(width: 8, height: 8)
            .foregroundColor(.purple)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
    }
}

struct ActiveTurnView_Previews: PreviewProvider {
    static var previews: some View {
        ActiveTurnView()
    }
}
