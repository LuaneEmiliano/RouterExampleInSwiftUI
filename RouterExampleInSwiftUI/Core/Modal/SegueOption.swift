//
//  SegueOption.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 2/28/25.
//
import SwiftUI

enum SegueOption {
    case push, sheet, fullScreenCover
    
    var addNewNavigationView: Bool {
        switch self {
        case .push, .fullScreenCover:
            return true
        case .sheet:
            return false
        }
    }
}
