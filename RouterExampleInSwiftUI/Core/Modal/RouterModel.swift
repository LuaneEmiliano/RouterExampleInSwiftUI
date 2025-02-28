//
//  RouterModel.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 2/28/25.
//
import SwiftUI

extension EnvironmentValues {
    @Entry var router: Router = MockRouter()
}

protocol Router {
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping(Router)-> T)
    func dismissScreen()
}

struct MockRouter: Router {
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) {
        print("Mock Router does not work")
    }
    
    func dismissScreen() {
        print("Mock Router does not work")
    }
}

//<Content: View >: View, Router
struct RouterModel<Content: View>: View, Router {
    @Environment(\.dismiss) private var dismiss
    @State private var path: [AnyDestination] = []
    
    @State private var showSheet: AnyDestination? = nil
    @State private var showFullScreenSheet: AnyDestination? = nil
    
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
        NavigationStackIfNeeded(path: $path, addNavigationView: addNavigationView) {
            content(self)
                .sheetViewModifier(screen: $showSheet)
                .fullScreenCoverViewModifier(screen: $showFullScreenSheet)
        }
        .environment(\.router, self)
    }
    
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping(Router)-> T) {
        let screen = RouterModel<T>(
            screenStack: option.addNewNavigationView ? nil : screenStack.isEmpty ? $path : $screenStack, addNavigationView: option.addNewNavigationView
        ){ newRouter in
            destination(newRouter)
            
        }
        let destination = AnyDestination(destination: screen)
        
        switch option {
        case .push:
            if screenStack.isEmpty {
                path.append(destination)
            } else {
                screenStack.append(destination)
            }
        case .sheet:
            showSheet = destination
        case .fullScreenCover:
            showFullScreenSheet = destination
        }
    }
    
    func dismissScreen() {
        dismiss()
    }
}
