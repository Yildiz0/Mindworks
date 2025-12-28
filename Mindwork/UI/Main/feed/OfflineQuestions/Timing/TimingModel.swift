//
//  TimingModel.swift
//  Mindwork
//
//  Created by Cemre Bayer on 28.12.2025.
//

import SwiftUI

enum TimingResult: String {
    case perfect = "Mükemmel"
    case good = "Başarılı"
    case miss = "Başarısız"
    
    var color: Color {
        switch self {
        case .perfect: return .green
        case .good: return .orange
        case .miss: return .red
        }
    }
}
