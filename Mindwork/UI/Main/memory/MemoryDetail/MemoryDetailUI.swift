//
//  TaskDetailUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 4.02.2025.
//

import SwiftUI
import FirebaseCore

struct MemoryDetailUI: View {
    
    @EnvironmentObject var routerMemory: RouterMemory
    @StateObject private var viewModel = MemoryDetailViewModel(collectionId: "")
    var memoryData: MemoryDocumentModel
    @State private var position = 0
    @State private var maxSize = 0
    @State private var selectFirstComment = true
    
    var body: some View {
        VStack(alignment: .leading,spacing: Padding.rowPaddingSmall){
            HStack{
                btnSystemIconTransparent(iconSystemName: Icons.left_direction, color: Color.black) {
                    routerMemory.navigateBack()
                }
                tvHeadlineString(text: memoryData.title, color: Color.blue500)
                Spacer()
            }.padding(.horizontal,Padding.constantLightPadding).padding(.bottom)
            Spacer()
            
            HStack{
                Spacer()
                ZStack(){
                    MemoryImage(imageUrl: memoryData.imageUrls[position]).frame(width: Width.screenEightyWidth).clipShape(RoundedRectangle(cornerRadius: Radius.borderRadius))
                        .animation(.easeInOut, value: position)
                        HStack{
                            btnSystemIconCircle(iconSystemName: Icons.left_direction, color: .blue) {
                                position = (position == 0 ? maxSize : (position - 1))
                            }.offset(x:OffsetValue.leftIcon)
                            Spacer()
                            btnSystemIconCircle(iconSystemName: Icons.right_direction, color: .blue) {
                                position = (position == maxSize ? 0 : (position + 1))
                            }.offset(x:OffsetValue.rightIcon)
                        }
                }.frame(maxHeight: Height.ultraLargeHeight).aspectRatio(contentMode: .fit)
                Spacer()
            }

            Spacer()
            
            tvSubHeadlineString(text: getLocalizedString(StringKey.comment_title), color: .black).padding(.horizontal,Padding.customButtonPadding)
            
            tvFootnoteString(text: selectFirstComment ? memoryData.userOneDescription ?? getLocalizedString(StringKey.none_comment)  : memoryData.userTwoDescription ?? getLocalizedString(StringKey.none_comment), color: Color.black, textAlignment: .leading).padding(.horizontal,Padding.customButtonPadding)
            
            HStack(spacing: 12) {
                btnBadge(text: "Yakup", backgroundColor: selectFirstComment ? Color.selected : Color.unselected, onClick:{
                    selectFirstComment.toggle()
                    
                })
                btnBadge(text: "Melis", backgroundColor: selectFirstComment ? Color.unselected : Color.selected, onClick: {
                    selectFirstComment.toggle()
                    
                })
            }.padding(.top).padding(.horizontal,Padding.customButtonPadding)
            Spacer()
            Spacer()
        }.navigationBarHidden(true).onAppear {
            self.maxSize = self.memoryData.imageUrls.count - 1
        }
    }
}

#Preview {
    
    var memoryObjet = MemoryDocumentModel(collectionId: "bh46faLR6UN3XeAQmmNn", imageUrls: ["https://sm.ign.com/ign_tr/lists/t/the-top-25/the-top-25-greatest-anime-characters-of-all-time_hu2z.jpg","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQuDRLYWROjeljJ9ia3F0B8Ab16rBMX1ulo1Q&s","https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRC9Nn-bvBSd4Wswp0RSN9Mct6WrB02Eg-_uQ&s"], relationId: "z2TthSLdsIQ5WloKXfje", title: "Kırmızı", userOneDescription: "yakup yazısı", userTwoDescription: "melis yazısı", userOneImage: nil,userTwoImage: nil,createDate: Timestamp(date: Date()))
    MemoryDetailUI(memoryData: memoryObjet)
}
