//
//  UserManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 12.02.2025.
//

import Foundation
import SwiftUI

class UserManager: BaseViewModel {
    
    @Published var userInstance: UserModel?
    @Published var error = ""

    static let shared = UserManager()
    init(userInstance: UserModel? = nil, error: String = "") {
        self.userInstance = userInstance
        self.error = error
        super.init()
        fetchProfile()
    }
        
    func fetchProfile(){
        getDataCall {
            try await FirestorageManager.shared.fetchProfile()
        } onSuccess: { user in
            self.userInstance = user
        } onLoading: {
        } onError: { error in
            self.error = error?.localizedDescription ?? ""
        }
    }
    func getUser() -> UserModel?{
        return self.userInstance
    }
}
