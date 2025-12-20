//
//  FeedRouter.swift
//  Tendria
//
//  Created by Yakup Kavak on 30.07.2025.
//

import Foundation
import SwiftUI

final class RouterFeed: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        case feedView
        case catch_pair
        case firefly_title
        case colorful_words
        case was_it_there
        case which_different
        case reflex
        case word_cube
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
