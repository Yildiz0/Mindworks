//
//  BaseTabViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 8.03.2025.
//

import Foundation
class BaseTabViewModel: BaseViewModel {
    @Published var showRelationAlert: Bool = false
    @Published var alertMessage: String = ""
    
    override init() {
        super.init()
        print("init")
        NotificationCenter.default.addObserver(forName: NSNotification.Name(NotificationKey.SHOW_NEW_REALTION), object: nil, queue: .main) { notification in
            DispatchQueue.main.async {
                if let partnerModel = notification.object as? NotificationModel {
                    self.showAlert(partnerName: partnerModel.secondUserName)
                }
            }
        }
        fetchData()
    }

    deinit {
        print("deinit")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationKey.SHOW_NEW_REALTION), object: nil)
    }

    func onSuccessClick(){
        self.showRelationAlert = false
    }
    
    private func showAlert(partnerName: String){
        let formattedText = String(format: NSLocalizedString(StringKey.new_relation_subtext_string, comment: ""), partnerName)
        alertMessage.self = formattedText

        self.showRelationAlert = true
    }
    private func fetchData(){
        getDataCall {
            try await RelationRepository.shared.getRelationId()
        } onSuccess: { data in
            
        } onLoading: {
            
        } onError: { error in
            
        }
        
    }
}
