//
//  Util.swift
//  Mindwork
//
//  Created by Yakup Kavak on 2.08.2025.
//

import Foundation
import SwiftUI
import UIKit

func getLocalizedString(_ key: LocalizedStringKey) -> String {
    let mirror = Mirror(reflecting: key)
    if let value = mirror.children.first?.value as? String {
        return NSLocalizedString(value, comment: "")
    }
    return ""
}

enum AlertType {
    case success, error
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)

        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255

        self.init(red: r, green: g, blue: b)
    }

    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: nil)
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}
import SwiftUI
import Combine

// MARK: - Kontrast hesaplama (WCAG luminance yaklaşımı)
extension Color {
    fileprivate var uiColor: UIColor {
        UIColor(self)
    }

    // 0 (siyah) - 1 (beyaz) algılanan parlaklık
    fileprivate var perceivedLuminance: CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
        func toLinear(_ c: CGFloat) -> CGFloat {
            (c <= 0.03928) ? (c / 12.92) : pow((c + 0.055) / 1.055, 2.4)
        }
        let R = toLinear(r), G = toLinear(g), B = toLinear(b)
        return 0.2126 * R + 0.7152 * G + 0.0722 * B
    }

    var contrastTextColor: Color {
        perceivedLuminance > 0.6 ? .black : .white
    }

    // Rengi gerçek anlamda biraz koyulaştır (Color -> Color)
    func darkened(by amount: CGFloat = 0.15) -> Color {
        var h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0, a: CGFloat = 0
        if uiColor.getHue(&h, saturation: &s, brightness: &v, alpha: &a) {
            return Color(hue: Double(h),
                         saturation: Double(s),
                         brightness: Double(max(v - amount, 0)),
                         opacity: Double(a))
        } else {
            var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
            uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)
            return Color(red: Double(max(r - amount, 0)),
                         green: Double(max(g - amount, 0)),
                         blue: Double(max(b - amount, 0)),
                         opacity: Double(a))
        }
    }

    // Çok açık renkleri biraz koyulaştır (CAST YOK!)
    var adjustedForLightBackground: Color {
        perceivedLuminance > 0.9 ? self.darkened(by: 0.15) : self
    }

    var adaptiveBorder: Color {
        perceivedLuminance > 0.85 ? Color.gray.opacity(0.5) : Color.clear
    }
}


struct ColorNumberButton: View {
    let title: LocalizedStringKey
    let color: Color
    let action: () -> Void

    var autoCycle: Bool = true
    var cycleInterval: TimeInterval = 1.8

    @State private var colorIndex = 0
    private let palette: [Color] = [.blue, .orange, .green, .red, .cyan]

    private var timer: Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: cycleInterval, on: .main, in: .common).autoconnect()
    }

    var body: some View {
        let baseColor = autoCycle ? palette[colorIndex % palette.count] : color
        let displayColor = baseColor.adjustedForLightBackground

        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(minWidth: 120)
                .background(displayColor)
                .foregroundColor(displayColor.contrastTextColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(displayColor.adaptiveBorder, lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
                .animation(.easeInOut(duration: 0.45), value: colorIndex)
        }
        .onReceive(timer) { _ in
            guard autoCycle else { return }
            colorIndex = (colorIndex + 1) % palette.count
        }
    }
}
// MARK: - Renkli cevap butonu
struct ColorAnswerButton: View {
    let title: LocalizedStringKey
    let color: Color
    let action: () -> Void

    var body: some View {
        let displayColor = color.adjustedForLightBackground
        Button(action: action) {
            Text(title)
                .font(.body.weight(.semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .frame(minWidth: 120)
                .background(displayColor)
                .foregroundColor(displayColor.contrastTextColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(displayColor.adaptiveBorder, lineWidth: 1)
                )
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 3)
        }
    }
}

struct DownSizedImageView<Content: View>: View {
    var image: UIImage?
    var size: CGSize
    @ViewBuilder var content: (Image) -> Content
    @State private var downsizedImageView: Image?
    
    var body: some View {
        ZStack{
            if let downsizedImageView {
                content(downsizedImageView)
            }
        }.onAppear {
            guard downsizedImageView == nil else { return }
            //Dynamic image changes
            createDownsizedImage(image: image)
        }.onChange(of: image) { oldValue, newValue in
            guard oldValue != newValue else { return }
            createDownsizedImage(image: newValue)
        }
    }
    
    private func createDownsizedImage(image: UIImage?){
        guard let image = image else { return }
        let aspectSize = image.size.aspectFit(to: size)
        Task.detached(priority: .high){
            let renderer = UIGraphicsImageRenderer(size: aspectSize)
            let resizedImage = renderer.image {ctx in
                image.draw(in: .init(origin: .zero, size: aspectSize))
            }
            
            await MainActor.run{
                downsizedImageView = .init(uiImage: resizedImage)
            }
        }
    }
}

extension CGSize {
    
    //This function will return a new size that fits the given size in aspect ratio
    func aspectFit(to: CGSize) -> CGSize{
        let scaleX = to.width / self.width
        let scaleY = to.height / self.height
        
        //Changed this to min to actually fit the image within the given size
        let aspectRatio = min(scaleX, scaleY)
        return .init(width: aspectRatio * width, height: aspectRatio * height)
    }
}
