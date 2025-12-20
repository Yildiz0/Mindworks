//
//  MakeRelationViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.02.2025.
//

import Foundation

class MakeRelationViewModel: BaseViewModel {
    @Published var showNotification = true
    @Published var inputText = ""
    @Published var showCopy = false
    @Published var isEditable = true
    @Published var loading = false
    @Published var error = ""
    @Published var isNotification = true

    func generateCode(){
        getDataCall {
            try await FirestorageManager.shared.generateConnectionCode()
        } onSuccess: { connectionCode in
            guard let code = connectionCode else {
                return
            }
            self.loading = false
            self.inputText = code
            self.showCopy = true
            self.isEditable = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.loading = false
            self.error = error?.localizedDescription ?? ""
        }
    }
    
    func checkCode(){
        self.isEditable = true
        self.showCopy = false
        getDataCall {
            try await FirestorageManager.shared.checkAndAddRelation(relationCode: self.inputText)
        } onSuccess: { successData in
            print("oluşan relation id ->", successData)
            self.loading = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.loading = false
            self.error = error?.localizedDescription ?? ""
        }
    }
    
}
