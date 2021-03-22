//
//  IdentifiableHashable.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/21/21.
//

import Foundation


/// Protocol composition with an extension to provide `Hashable` conformance to an object.
protocol IdentifiableHashable: Hashable & Identifiable {}
extension IdentifiableHashable {
    
    static func == (lhs: Self, rhs: Self) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
