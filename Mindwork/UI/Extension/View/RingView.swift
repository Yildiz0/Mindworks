import SwiftUI

struct NotificationAnimationView: View {
    @State private var animateBell = false
    
    var body: some View {
        ZStack {
            // Arka plan blob şekli
            BlobShape()
                .fill(Color.green.opacity(0.2))
                .frame(width: 140, height: 160)
                .offset(x: -10, y: 10)
            
            // Titreşim Dalgaları
            WaveLines()
            
            // Sallanan Çan
            Image(systemName: "bell.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundStyle(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.yellow, Color.orange]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
        }.rotationEffect(.degrees(animateBell ? 15 : -15), anchor: .top)
    }
}

// 🟢 Düzensiz Blob Arka Plan
struct BlobShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.midY),
                      control1: CGPoint(x: rect.maxX * 0.8, y: rect.minY - 0),
                      control2: CGPoint(x: rect.maxX + 20, y: rect.midY * 0.8))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.maxY),
                      control1: CGPoint(x: rect.maxX - 10, y: rect.maxY + 50),
                      control2: CGPoint(x: rect.midX + 0, y: rect.maxY + 10))
        path.addCurve(to: CGPoint(x: rect.minX, y: rect.midY),
                      control1: CGPoint(x: rect.midX - 20, y: rect.maxY - 20),
                      control2: CGPoint(x: rect.minX - 20, y: rect.midY + 20))
        path.addCurve(to: CGPoint(x: rect.midX, y: rect.minY),
                      control1: CGPoint(x: rect.minX + 40, y: rect.minY - 20),
                      control2: CGPoint(x: rect.midX - 10, y: rect.minY - 10))
        return path
    }
}

// 🟠 Çevresindeki Titreşim Dalgaları
struct WaveLines: View {
    var body: some View {
        HStack {
            Image(systemName: "wave.3.right.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.orange)
                .offset(x: -30, y: -10)  // Sol dalga
            
            Spacer()
            
            Image(systemName: "wave.3.right.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
                .foregroundColor(.orange)
                .offset(x: 30, y: -10)   // Sağ dalga
        }
    }
}

// 🛠 Önizleme
struct NotificationAnimationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationAnimationView()
    }
}
