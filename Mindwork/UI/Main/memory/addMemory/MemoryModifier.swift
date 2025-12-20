//
//  MemoryModifier.swift
//  Tendria
//
//  Created by Yakup Kavak on 16.04.2025.
//

import Foundation
import SwiftUI

struct MemoryPhotoModifier: ViewModifier {
    var index: Int
    var isImageSelected: Bool

    func body(content: Content) -> some View {
        content
            .scaleEffect(index == 0 ? Scale.main : Scale.sub)
            .zIndex(index == 0 ? ZIndex.top : ZIndex.below)
            .padding(.top, isImageSelected ? 0 : Padding.horizontalNormalPlusPadding)
            .padding(.bottom, isImageSelected ? 0 : Padding.horizontalNormalPadding)
    }
}
