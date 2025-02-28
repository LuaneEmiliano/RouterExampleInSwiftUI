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
}

#Preview {
    RouterModel { _ in
        SegueOptionView()
    
    }
}
