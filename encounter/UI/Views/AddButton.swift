//
//  AddFighterButton.swift
//  encounter
//
//  Created by Florent Alexandre on 11/05/2021.
//

import SwiftUI

struct AddButton: View {
    
    var title: String = NSLocalizedString("Add", comment: "")
    
    var body: some View {
        HStack {
            Image(systemName: "plus")
            Text(title)
        }
    }
}

struct AddFighterButton_Previews: PreviewProvider {
    static var previews: some View {
        AddButton()
    }
}
