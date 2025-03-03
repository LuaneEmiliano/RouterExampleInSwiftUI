//
//  Untitled.swift
//  RouterExampleInSwiftUI
//
//  Created by Luane Niejelski Emiliano on 3/3/25.
//

import SwiftUI

struct ModalSupportView<Content: View>: View {
    
    @Binding var showModal: Bool
    @ViewBuilder var content: Content
    
    var body: some View {
        ZStack {
            if showModal {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                    .transition(AnyTransition.opacity.animation(.smooth))
                    .onTapGesture {
                        showModal = false
                    }
                    .zIndex(1)

                content
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .zIndex(2)
            }
        }
        .zIndex(9999)
        .animation(.bouncy, value: showModal)
    }
}

extension View {
    
    func modalViewModifier(screen: Binding<AnyDestination?>) -> some View {
        //(ifNotNil: $showSheet): if  != nil showSheet
        self
            .overlay(
                ModalSupportView(showModal: Binding(ifNotNil: screen)) {
                    ZStack {
                        if let screen = screen.wrappedValue {
                            screen.destination
                        }
                    }
                }
            )
          }
    }
    
   
