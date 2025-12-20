//
//  KeyboardObserver.swift
//  Tendria
//
//  Created by Yakup Kavak on 15.04.2025.
//

import Combine
import SwiftUI

final class KeyboardObserver: ObservableObject {
    static let shared = KeyboardObserver()
    private var cancellables = Set<AnyCancellable>()

    @Published var keyboardIsVisible: Bool = false

    init() {
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { _ in
                self.keyboardIsVisible = true
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { _ in
                self.keyboardIsVisible = false
            }
            .store(in: &cancellables)
    }
}
