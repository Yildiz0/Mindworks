//
//  style.swift
//  Tendria
//
//  Created by Yakup Kavak on 19.01.2025.
//

import Foundation
import SwiftUI

struct BigSizeBoldGrad: View {
    var text: LocalizedStringKey
    var body: some View{
        tvGradient(text: text, gradientColors: GradientSet.mediumOrangeRed, font: .largeTitle, fontWeight: .bold)
    }
}

struct tvFootnote: View {
    var text: LocalizedStringKey
    var color: Color
    var textAlignment: TextAlignment = .center
    var body: some View {
        tvColorKey(text: text, color: color, weight: .regular, font: .footnote,textAlignment: textAlignment)
    }
}
struct tvFootnoteString: View {
    var text: String
    var color: Color
    var textAlignment: TextAlignment = .center
    var body: some View {
        tvColorKeyString(text: text, color: color, weight: .regular, font: .footnote,textAlignment: textAlignment)
    }
}

struct tvBodyline: View {
    var text: LocalizedStringKey
    var color: Color
    var body: some View {
        tvColorKey(text: text, color: color, weight: .regular, font: .body)
    }
}
struct tvBodylineString: View {
    var text: String
    var color: Color
    var body: some View {
        tvColorKeyString(text: text, color: color, weight: .regular, font: .title3)
    }
}

struct tvSubHeadline: View {
    var text: LocalizedStringKey
    var color: Color
    var body: some View {
        tvColorKey(text: text, color: color, weight: .regular, font: .subheadline)
    }
}
struct tvSubHeadlineString: View {
    var text: String
    var color: Color
    var body: some View {
        tvColorKeyString(text: text, color: color, weight: .regular, font: .title)
    }
}

struct tvHeadline: View {
    var text: LocalizedStringKey
    var color: Color
    var body: some View {
        tvColorKey(text: text, color: color, weight: .regular, font: .title3)
    }
}

struct tvTitle: View {
    var text: LocalizedStringKey
    var color: Color
    var body: some View {
        Text(text).font(.custom("Mali-Bold", size: 48))
    }
}
struct tvSubtitleFont: View {
    var text: LocalizedStringKey
    var color: Color
    var body: some View {
        Text(text).font(.custom("Mali-Bold", size: 36))
    }
}
struct tvHeadlineString: View {
    var text: String
    var color: Color
    var body: some View {
        tvColorKeyString(text: text, color: color, weight: .bold, font: .title3)
    }
}

struct tvSubTitle: View {
    var text: LocalizedStringKey
    var body: some View {
        tvColorKey(text: text, color: Color.blue500, weight: .medium, font: .headline)
    }
}

struct tvRowSubline: View {
    var text: String
    var color: Color
    var body: some View {
        tvColorString(text: text, color: color, weight: .regular, font: .system(size: 30))
    }
}

