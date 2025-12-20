//
//  AlertUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 23.01.2025.
//

import SwiftUI

struct AlertUI: View {
    @State private var showingSimpleAlert = false
    
    var body: some View {
        VStack{
            Button {
                self.showingSimpleAlert = true
            } label: {
                Text("Simple Alert")
            }.alert("Error", isPresented: $showingSimpleAlert) {
            } message: {
                Text("The request fail")
            }

        }
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    AlertUI()
}
