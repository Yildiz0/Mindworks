//
//  TaskNavigationManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import Foundation
import SwiftUI

final class RouterMemory: ObservableObject {
    
    public enum Destination: Codable, Hashable {
        //Group List
        case collectionList
        case addCollection
        case memoryList(collection: CollectionDocumentModel)
        case memoryDetail(memory: MemoryDocumentModel)
        case addMemory(collectionId: String)
    }
    
    @Published var navPath = NavigationPath()
    @Published var selectedCollectionId: String? = nil
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    func navigateWithClear(to destination: Destination) {
        navPath = NavigationPath()
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
