//
//  ShareManager.swift
//  Tendria
//
//  Created by Yakup Kavak on 26.02.2025.
//

import Foundation
import SwiftUI

class ShareManager {
    static func shareCode(_ code: String) {
        let textToShare = "İşte bağlantı kodum: \(code)"
        let activityVC = UIActivityViewController(activityItems: [textToShare], applicationActivities: nil)
        
        // iPad uyumluluğu için popover kaynağı ayarı
        if let topController = UIApplication.shared.windows.first?.rootViewController {
            activityVC.popoverPresentationController?.sourceView = topController.view
            topController.present(activityVC, animated: true, completion: nil)
        }
    }
}
