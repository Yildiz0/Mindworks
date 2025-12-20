//
//  FullScreenCoverUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 16.04.2025.
//

import SwiftUI

struct FullScreenImageUI: View {
    let image: UIImage
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .onTapGesture {
                    dismiss()
                }
        }.overlay(alignment: .topLeading) {
            btnSystemIconTransparent(iconSystemName: "xmark", color: Color.white) {
                dismiss()
            }.padding()
        }
    }
}
#Preview {
    FullScreenImageUI(image: UIImage())
}

