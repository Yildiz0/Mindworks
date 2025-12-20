//
//  TaskRowUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 3.02.2025.
//

import SwiftUI

struct CollectionRowUI: View {
    var url: String
    var subText: String
    var shouldCancelOnDisappear: Bool
    var isFavorite: Bool
    var body: some View {
        ZStack(alignment: .bottom){
            RowURLImage(imageUrl: url,shouldCancelOnDisappear: shouldCancelOnDisappear)
            Rectangle().background(.ultraThinMaterial).frame(width: 180,height: 40).overlay(alignment: .leading) {
                HStack{
                    tvRowSubline(text: subText,color: Color.white)
                    Spacer()
                    btnSystemIconTransparent(iconSystemName: isFavorite ? "star.fill" : "star", color: Color.white) {
                        print("yakup")
                    }
                }
                .padding(.bottom,4).padding(.horizontal,20)
            }.clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius)).padding(.bottom,8)
            
        }.clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius)).shadow(radius: Radius.shadowRadius)
    }
}

#Preview {
    CollectionRowUI(url: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWPw5qeVm7nSfrA7lhl5OSKqsSyzL4eMD9Iw&s", subText: "goku", shouldCancelOnDisappear: true, isFavorite: true)
}
 /*
.overlay(alignment: .center) {
    
}
*/
