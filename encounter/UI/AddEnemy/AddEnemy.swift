//
//  AddEnemy.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import Foundation
import SwiftUI

struct AddEnemyView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            HStack {
                Text("Add enemy")
            }.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
        
    }
    
}
