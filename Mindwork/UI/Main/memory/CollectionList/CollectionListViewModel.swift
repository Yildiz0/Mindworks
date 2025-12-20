//
//  TaskViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.02.2025.
//

import Foundation

class CollectionListViewModel: BaseViewModel{
    @Published var success: IsCollectionExist?
    @Published var loading = true
    @Published var error = ""
    
    override init() {
        super.init()
        fetchCollectionList()
    }
    
    func fetchCollectionList(){
        getDataCall {
            try await FirestorageManager.shared.fetchCollectionList()
        } onSuccess: { isCollectionExist in
            self.success = isCollectionExist
            self.loading = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
            self.loading = false
        }
    }
}
