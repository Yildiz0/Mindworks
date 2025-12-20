//
//  TaskDetailViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import Foundation
class MemoryDetailViewModel: BaseViewModel{
    
    @Published var success: FetchDataList<MemoryDocumentModel>?
    @Published var loading = true
    @Published var error = ""
    private var collectionId: String
    
    init(collectionId: String) {
        self.collectionId = collectionId //First initalize value
        super.init() //
        fetchData()
    }
    
    func fetchData(){
        getDataCall {
            try await FirestorageManager.shared.fetchMemoryList(collectionId: self.collectionId)
        } onSuccess: { data in
            self.success = data
            self.loading = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? String(describing: StringKey.unknown_error)
            self.loading = false
        }
    }
}
