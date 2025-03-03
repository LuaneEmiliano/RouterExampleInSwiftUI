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
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons:(@Sendable () -> AnyView)?)
    func showModal<T: View>(@ViewBuilder destination: @escaping () -> T)
    func dismissModal()
}

struct MockRouter: Router {
    func showScreen<T: View>(_ option: SegueOption, @ViewBuilder destination: @escaping (Router) -> T) {
        print("Mock Router does not work")
    }
    
    func dismissScreen() {
        print("Mock Router does not work")
    }
    
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons:(@Sendable () -> AnyView)?) {
        print("Mock Router does not work")
    }
    
    func showModal<T: View>(@ViewBuilder destination: @escaping () -> T) {
        print("Mock Router does not work")
    }
    
    func dismissModal() {
        print("Mock Router does not work")
    }
}

//<Content: View >: View, Router
struct RouterModel<Content: View>: View, Router {
    @Environment(\.dismiss) private var dismiss
    @State private var path: [AnyDestination] = []
    
    @State private var showSheet: AnyDestination? = nil
    @State private var showFullScreenSheet: AnyDestination? = nil
    @State private var modal: AnyDestination? = nil
    
    @State private var alertOption: AlertType = .alert
    @State private var alert: AnyAppAlert? = nil
    
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
                .showCustomAlert(type: alertOption, alert: $alert)
        }
        .modalViewModifier(screen: $modal)
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
    
    func showAlert(_ option: AlertType, title: String, subtitle: String?, buttons:(@Sendable () -> AnyView)?) {
        self.alertOption = option
        self.alert = AnyAppAlert(title: title, subtitle: subtitle, buttons: buttons)
    }
    
    func showModal<T: View>(@ViewBuilder destination: @escaping () -> T) {
        let destination = AnyDestination(destination: destination())
        self.modal = destination
    }
    
    func dismissModal() {
        modal = nil
    }
}
