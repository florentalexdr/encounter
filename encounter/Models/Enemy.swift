//
//  Enemy.swift
//  encounter
//
//  Created by Florent Alexandre on 10/05/2021.
//

import Foundation

struct Enemy: Hashable, Codable, Identifiable {
    var id: Int
    var type: String
    var number: String
    var healthPoints: Int
}
