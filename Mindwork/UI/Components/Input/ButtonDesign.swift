//
//  ButtonDesign.swift
//  Tendria
//
//  Created by Yakup Kavak on 20.01.2025.
//

import Foundation
import SwiftUI

struct btnOnlyText<Content: View>: View {
    var customView: Content
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            customView
        }
    }
}
struct btnSystemIconGradient: View {
    var iconSystemName: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconSystemName).foregroundColor(color)
        }.btnStyle()
    }
}
struct btnSystemIconCircle: View {
    var iconSystemName: String
    var color: Color
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconSystemName).foregroundColor(color)
        }.btnCircleStyle()
    }
}
struct btnSystemIconTransparent: View {
    var iconSystemName: String
    var color: Color
    var font: Font = .body
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconSystemName).foregroundColor(color).font(font)
        }
    }
}
struct btnSignIcon: View {
    var iconName: String
    var width: CGFloat? = IconWidth.mediumHeight
    var action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(iconName).resizable().scaledToFit()
                .frame(width: width,height: width)
        }
    }
}
struct btnAddIcon: View {
    var iconName: String
    var backgroundColor: Color? = Color.orange500
    var foregroundColor: Color? = Color.white
    var shadow: CGFloat? = IconWidth.smallHeight
    var width: CGFloat? = IconWidth.normalHeight
    var paddingWidth: CGFloat? = IconWidth.smallHeight

    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: iconName)
                .resizable()
                .scaledToFit()
                .font(.system(size: 16, weight: .heavy))
                .scaleEffect(0.7)
                .padding(paddingWidth!)
                .gradientBackground() //padding önce olmalı background algılamaz.
                .frame(width: width,height: width)
                .foregroundColor(foregroundColor)
                .clipShape(Circle())
                .shadow(radius: shadow!)
        }
    }
}
struct btnTextGradientInfinity: View {
    
    var foregroundColor: Color? = Color.btnForeground
    var shadow: CGFloat? = Radius.shadowConstantRadiud
    var action: () -> Void
    var text: LocalizedStringKey
    var edgeSet: Edge.Set = .all
    var paddingValue: CGFloat = 16
    
    var body: some View {
        Button {
            action()
        } label: {
            tvHeadline(text: text, color: foregroundColor!).frame(maxWidth: .infinity).padding(edgeSet,paddingValue).gradientBackground().clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius)).shadow(radius: shadow!)
        }
    }
}
struct btnBadge: View {
    var text: String
    var backgroundColor: Color
    var onClick: () -> Void
    
    var body: some View {
        Button {
            onClick()
        } label: {
            Text(text)
                .font(.subheadline)
                .foregroundColor(.black)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(backgroundColor)
                .clipShape(Capsule())
        }
    }
}
struct btnIconText: View {
    let stringKey: LocalizedStringKey
    let systemName: String
    let action: () -> Void
    @Binding var selected: Bool
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack{
                Image(systemName: systemName).foregroundStyle(.generalText)
                tvFootnote(text: stringKey, color: .generalText)
            }.padding(6)
        }.background(selected ? Color.selectButton : Color.unselectButton).mediumCorner()
    }
}

struct btnTextGradientSmall: View {
    
    var foregroundColor: Color? = Color.btnForeground
    var shadow: CGFloat? = Radius.shadowConstantRadiud
    var action: () -> Void
    var text: LocalizedStringKey
    var edgeSet: Edge.Set = .all
    var paddingValue: CGFloat = 16
    var maxWidth: CGFloat = .infinity
    
    var body: some View {
        Button {
            action()
        } label: {
            tvHeadline(text: text, color: foregroundColor!).fixedSize().padding(edgeSet,paddingValue).gradientBackground().clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius)).shadow(radius: shadow!)
        }
    }
}
struct SelectDateRow: View {
    var selected: Bool
    var number: String
    var text: String
    var body: some View {
        VStack(spacing: Padding.constantNormalPadding){
            tvColorString(text: number, color: selected ? Color.white : Color.black, font: .title3)
            tvColorString(text: text, color: selected ? Color.white : Color.black, font: .footnote)
        }.frame(maxWidth: 90,maxHeight: 90).background(selected ? Color.selectButton : Color.unselectButton).mediumCorner()
    }
}

struct ChipUI: View {
    @Binding var selected: Bool
    var text: String
    var body: some View {
        tvColorString(text: text, color: selected ? Color.white : Color.black, font: .title3).padding().background(selected ? Color.selectButton : Color.unselectButton).mediumCorner()
    }
}

struct btnTextTransparent: View {
    var action: () -> Void
    var text: LocalizedStringKey
    var textColor: Color? = Color.orange500
    var body: some View {
        Button {
            action()
        } label: {
            tvHeadline(text: text, color: Color.orange700).frame(maxWidth: .infinity).padding()
                .overlay(alignment: Alignment.trailing) {
                    RoundedRectangle(cornerRadius: Radius.mediumRadius).stroke(Color.orange,lineWidth: 2)
                }
            
        }
    }
}

#Preview{
    @State var selected = true
    
    btnIconText(stringKey: StringKey.add_memory, systemName: "bell", action: {print("yakup")}, selected: $selected)
    SelectDateRow(selected: false, number: "10", text: "Tuesday")
    /*
     btnTextTransparent(action: {
         print("yakup")
     }, text: StringKey.add )
     */
    
}
