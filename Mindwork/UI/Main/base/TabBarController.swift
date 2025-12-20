//
//  TabBarController.swift
//  Tendria
//
//  Created by Yakup Kavak on 3.08.2025.
//

import Foundation

class TabBarController: ObservableObject{
    @Published var isVisible = true
    
    func hideTabbar(){
        isVisible = false
    }
    
    func showTabbar(){
        isVisible = true
    }
}
