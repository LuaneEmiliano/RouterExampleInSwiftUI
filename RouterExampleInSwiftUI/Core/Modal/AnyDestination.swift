//
//  AnyDestination.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 2/28/25.
//
import SwiftUI

struct AnyDestination: Hashable {
    let id = UUID().uuidString
    var destination: AnyView
    
    init<T: View>( destination: T) {
        self.destination = AnyView(destination)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func == (lhs: AnyDestination, rhs: AnyDestination) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}
