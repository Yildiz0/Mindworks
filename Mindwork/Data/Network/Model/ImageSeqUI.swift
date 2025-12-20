//
//  ImageSeqUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 4.04.2025.
//

import UIKit
struct ImageSeqUI: Identifiable, Equatable{
    var id: Int { index }
    var index: Int
    var image: UIImage
    var isEmpty: Bool
    var offsetX: CGFloat = 0
}
