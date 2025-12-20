//
//  FireFunction.swift
//  Tendria
//
//  Created by Yakup Kavak on 25.02.2025.
//

import Foundation
import FirebaseFunctions

class FireFunction {
    
    static let shared = FireFunction()
    private let functions = Functions.functions()
    
    private init () {}
    
    func callCheckRelation(relationCode: String) async throws {
        let callable = functions.httpsCallable(FunctionName.CHECK_RELATION)
        do {
            let result = try await callable.call(["name": relationCode])
            if let data = result.data as? [String: Any], let message = data["message"] as? String {
                print("Mesaj: \(message)")
            }
        } catch {
            print("Hata: \(error.localizedDescription)")
        }
    }
}
