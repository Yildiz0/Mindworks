//
//  ExistRelationUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.02.2025.
//

import SwiftUI

struct ExistRelationUI: View {
    
    @EnvironmentObject var routerUser: RouterUserInfo
    @ObservedObject var userManager: UserManager

    var body: some View {
        Text("ilişki var")
    }
}

#Preview {
    ExistRelationUI(userManager: UserManager())
}
