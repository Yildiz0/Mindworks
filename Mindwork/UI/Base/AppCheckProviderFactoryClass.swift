//
//  AppCheckProviderFactory.swift
//  Tendria
//
//  Created by Yakup Kavak on 23.02.2025.
//

import Foundation
import FirebaseCore
import FirebaseAppCheck

class AppCheckProviderFactoryClass: NSObject, AppCheckProviderFactory {
  func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
    return AppAttestProvider(app: app)
  }
}
