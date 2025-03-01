//
//  ContentView.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 2/28/25.
//

import SwiftUI

struct SegueOptionView: View {
   @Environment(\.router) var router
    
    var body: some View {
        List {
            segueSection
            alertSection
        }
        .navigationTitle("Router Examples")
    }
    
    private var segueSection: some View {
        Section {
            Button {
                router.showScreen(.push) { _ in
                    SegueOptionView()
                }
            } label: {
                Text("Push")
            }
            Button {
                router.showScreen(.sheet) { _ in
                    SegueOptionView()
                }
            } label: {
                Text("Sheet")
            }
            Button {
                router.showScreen(.fullScreenCover) { _ in
                    SegueOptionView()
                }
            } label: {
                Text("Full Cover Screen")
            }
            Button {
                router.dismissScreen()
            } label: {
                Text("Dismiss")
            }
        } header: {
            Text("Push")
        }
    }
    
    private var alertSection: some View {
        Section {
            Button {
                router.showAlert(.alert, title: "Alert 1", subtitle: "Alert Subtitle", buttons: nil)
            } label: {
                Text("Alert")
            }
            
            Button {
                router.showAlert(.confirmationDialog, title: "Alert 2", subtitle: "Alert 2 subtitle", buttons:  {
                    AnyView(
                        Group {
                            Button("ONE", action: {})
                            Button("TWO", action: {})
                            Button("THREE", action: {})
                        }
                    )
                })
            } label: {
                Text("Confirmation Dialog")
            }

        } header: {
            Text("Alert")
        }
    }
}

#Preview {
    RouterModel { _ in
        SegueOptionView()
    
    }
}
