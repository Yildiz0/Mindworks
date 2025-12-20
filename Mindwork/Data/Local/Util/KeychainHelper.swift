//
//  KeychainHelper.swift
//  Tendria
//
//  Created by Yakup Kavak on 6.03.2025.
//

import Security
import Foundation

class KeychainHelper {
    
    static let shared = KeychainHelper()
    
    private init (){}
    
    func saveToken(_ token: String, key: String) {
        let data = token.data(using: .utf8)!
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary
        SecItemDelete(query)  // Önce eski kaydı sil
        SecItemAdd(query, nil)
    }

    func getToken(key: String) -> String? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        if SecItemCopyMatching(query, &dataTypeRef) == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
