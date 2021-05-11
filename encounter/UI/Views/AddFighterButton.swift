//
//  AddFighterButton.swift
//  encounter
//
//  Created by Florent Alexandre on 11/05/2021.
//

import SwiftUI

struct AddFighterButton: View {
    var body: some View {
        HStack {
            Image(systemName: "plus")
            Text(NSLocalizedString("Add", comment: ""))
        }
    }
}

struct AddFighterButton_Previews: PreviewProvider {
    static var previews: some View {
        AddFighterButton()
    }
}
