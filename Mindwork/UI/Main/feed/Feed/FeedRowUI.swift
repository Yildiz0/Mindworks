//
//  FeedRowUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 15.07.2025.
//

import SwiftUI

struct FeedRowUI: View {
    var foregroundColor: Color
    var backgroundColor: Color
    var title: Text
    
    var body: some View {
        VStack(spacing: -20){
            ZStack{
                CurvedCorner(xLocation: getLocation(), yLocation: getLocation())
                    .fill(backgroundColor.opacity(0.7))
                        .frame(width: 100, height: 100)
                Text(":").foregroundStyle(.white).font(.system(size: 40,weight: .bold))
                    .offset(x: 25,y:-25)
            }.frame(maxWidth: .infinity, alignment: .trailing)
            title.font(.custom("Mali-Bold", size: 20)).foregroundStyle(.white).padding(20).lineLimit(1).truncationMode(.tail)
        }.background(foregroundColor).frame(maxWidth: Width.screenFourtyTwoWidth).clipShape(RoundedRectangle(cornerRadius: 20))
    }
    private func getLocation() -> CGFloat{
        return CGFloat(Int.random(in: 10...40))
    }
}

struct CurvedCorner: Shape {
    var xLocation: CGFloat
    var yLocation: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX, y: rect.minY ))
        path.addCurve(to: CGPoint(x: rect.maxX, y: rect.maxY - 40), control1: CGPoint(x: rect.minX + xLocation, y: rect.minY + yLocation), control2: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        
        return path
    }
}
#Preview {
    FeedRowUI(foregroundColor: .blue, backgroundColor: .orange, title: Text("math"))
}
