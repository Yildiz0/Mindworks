import SwiftUI

struct CustomWaveView: View {
    var gradient: Gradient
    var startPoint: UnitPoint
    var endPoint: UnitPoint
    
    var body: some View {
        CustomWaveShape()
            .fill(
                LinearGradient(
                    gradient: gradient,
                    startPoint: startPoint,
                    endPoint: endPoint
                )
            )
    }
}
struct CategoryTag: View {
    var model: CategoryModel
    var isSelected: Bool = false
    var isAddButton: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isAddButton {
                    Image(systemName: "plus")
                        .font(.body)
                        .foregroundColor(.blue)
                        .padding(8)
                } else {
                    Circle()
                        .fill(Color(hex: model.colorHex))
                        .frame(width: 12, height: 12)
                    Text(model.name)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(maxWidth: 100)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .layoutPriority(1)
                        .padding(.vertical, 6)
                        .padding(.trailing, 10)
                }
            }
            .padding(.leading, isAddButton ? 0 : 6)
            .background(backgroundView)
        }
        .buttonStyle(.plain)
    }

    private var backgroundView: some View {
        if isAddButton {
            return AnyView(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.blue, lineWidth: 2)
            )
        } else {
            return AnyView(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(hex: model.colorHex).opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                    )
            )
        }
    }
}

struct CustomWaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Noktaları Tanımlayın
        let P0 = CGPoint(x: 0, y: rect.height * 1.7) // Başlangıç noktası
        let P2 = CGPoint(x: rect.width * 0.4, y: rect.height * 2.3) // İlk dalganın inişi (yükseltilmiş)
        let P4 = CGPoint(x: rect.width * 2, y: rect.height * 10) // Bitiş noktası (yükseltilmiş)        // Çizim Başlangıcı
        path.move(to: P0)
        
        // Birinci Bezier Eğrisi (P0 -> P2)
        path.addCurve(
            to: P2, // Bitiş noktası
            control1: CGPoint(x: rect.width * 0.1, y: rect.height * 0.8), // İlk kontrol noktası (daha yukarı çekildi)
            control2: CGPoint(x: rect.width * 0.3, y: rect.height * 3.7) // İkinci kontrol noktası (daha aşağı çekildi)
        )
        
        // İkinci Bezier Eğrisi (P2 -> P4)
        path.addCurve(
            to: P4, // Bitiş noktası
            control1: CGPoint(x: rect.width * 0.53, y: rect.height * 0.9), // İlk kontrol noktası (daha yukarı çekildi)
            control2: CGPoint(x: rect.width * 0.7, y: rect.height * 2) // İkinci kontrol noktası (daha aşağı çekildi)
        )
        path.addCurve(
            to: P4, // Bitiş noktası
            control1: CGPoint(x: rect.width * 0.53, y: rect.height * 0.9), // İlk kontrol noktası (daha yukarı çekildi)
            control2: CGPoint(x: rect.width * 0.7, y: rect.height * 2) // İkinci kontrol noktası (daha aşağı çekildi)
        )
        
        // Sağ üst köşe
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        
        // Sol üst köşe
        path.addLine(to: CGPoint(x: 0, y: 0))
        
        // Şekli kapatma
        path.closeSubpath()
        
        return path
    }
}

struct RoundedTopLeftShape: Shape {
    var radius: CGFloat = 32
    
    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        path.addQuadCurve(to: CGPoint(x: rect.minX + radius, y: rect.minY),
                          control: CGPoint(x: rect.minX, y: rect.minY))

        path.closeSubpath()
        return path
    }
}
