//
//  UserViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.02.2025.
//

import Foundation
import Combine
import FirebaseAuth

class UserListViewModel: BaseViewModel {
    
    @Published var isRelationExist: Bool = false
    @Published var loading: Bool = false
    @Published var error: String = ""
    @Published var user: UserModel = UserModel(profileImageUrl: nil,
                                               relationId: "",
                                               userId: nil,
                                               fcmToken: "",
                                               name: "",
                                               surname: "",
                                               userLanguage: "en")
    override init() {
        super.init()
        updateRelation()
        if let user = UserManager.shared.userInstance {
            self.user = user
        }
        fetchProfile()
    }
    
    func fetchProfile(){
        getDataCall(dataCall: {
            try await FirestorageManager.shared.fetchProfile()
        }, onSuccess: { (user: UserModel) in
            self.user = user
            self.loading = false
        }, onLoading: {
            self.loading = true
        }, onError: { error in
            self.loading = false
            self.error = error?.localizedDescription ?? ""
        })
    }
    func signOut(){
        do {
            try Auth.auth().signOut()
        }catch {
            self.error = error.localizedDescription ?? ""
        }
    }
    
    private func updateRelation(){
        getDataCall {
             try await FirestorageManager.shared.checkUserRelation()
        } onSuccess: { success in
            if success {
                self.isRelationExist = true
                self.loading = false
            }else {
                self.isRelationExist = false
                self.loading = false
            }
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.isRelationExist = false
            self.error = error?.localizedDescription ?? "error"
        }
    }
}
