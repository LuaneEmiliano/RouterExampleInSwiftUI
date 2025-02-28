//
//  RouterModel.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 2/28/25.
//
import SwiftUI

protocol Router {
func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping(Router)-> T)
}
//<Content: View >: View, Router
struct RouterModel<Content: View>: View, Router {
    
    @State private var path: [AnyDestination] = []
    @Binding var screenStack: [AnyDestination]
    var addNavigationView: Bool = true
    @ViewBuilder var content: (Router) -> Content
    
    init(
        screenStack: (Binding<[AnyDestination]>)? = nil,
        addNavigationView: Bool = true,
        content: @escaping (Router) -> Content
    ) {
        
        self._screenStack = screenStack ?? .constant([])
        self.addNavigationView = addNavigationView
        self.content = content
    }
    
    var body: some View {
        content(self)
    }
    
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping(Router)-> T) {
        let screen = RouterModel<T>(
            screenStack: option.addNewNavigationView ? nil : screenStack.isEmpty ? $path : $screenStack, addNavigationView: option.addNewNavigationView
        ){ newRouter in
            destination(newRouter)
            
        }
        let destination = AnyDestination(destination: screen)
    }
}
