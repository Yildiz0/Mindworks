//
//  KeyboardAdaptive.swift
//  Tendria
//
//  Created by Yakup Kavak on 26.03.2025.
//

import Foundation
import SwiftUI
import Combine

struct KeyboardAdaptive: ViewModifier {
    @State private var keyboardHeight: CGFloat = 0
    var canUpdate: Binding<Bool>
    
    func body(content: Content) -> some View {
        content
            .padding(.bottom, canUpdate.wrappedValue ? keyboardHeight : 0)
            .onReceive(Publishers.keyboardHeight) { self.keyboardHeight = $0}
    }
}
