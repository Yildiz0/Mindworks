//
//  createEventUI.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.05.2025.
//

import SwiftUI
import Toasts

struct CreateEventUI: View {
    
    @StateObject private var viewModel = CreateEventViewModel()
    @FocusState private var focusedField: CreateEventState?
    @State private var showStartPicker = false
    @State private var showEndPicker = false
    @State private var showDatePicker = false
    @State private var selectIndex = 0
    @State private var showAddCategorySheet = false
    @Environment(\.presentToast) var presentToast
    
    let columns = [GridItem(.adaptive(minimum: 100), spacing: 12)]

    var body: some View {
        ScrollView(.vertical,showsIndicators: false){
            tvHeadline(text: StringKey.eventTitle, color: Color.black).positionLeading()
                .padding(.bottom, Padding.constantMediumPadding)
            
            tvSubTitle(text: StringKey.selectDate).positionLeading().padding(.bottom, Padding.constantXSmallPadding)
            
            HStack{
                ForEach(Array(viewModel.dateList.enumerated()), id: \.element.id){ index,model in
                    if(selectIndex == index){
                        SelectDateRow(selected: true, number: model.number, text: model.text).onTapGesture {
                            if(index == CalendarConstants.otherIndex){
                                showDatePicker = true
                            }
                            selectIndex = index
                        }
                    }else {
                        SelectDateRow(selected: false, number: model.number, text: model.text).onTapGesture {
                            if(index == CalendarConstants.otherIndex){
                                
                            }
                            selectIndex = index
                        }
                    }
                }
            }
            if selectIndex == CalendarConstants.otherIndex {
                DatePicker(StringKey.selectDate, selection: $viewModel.selectDate, displayedComponents: [.date])
                    .datePickerStyle(.graphical)
                    .padding(.vertical, 4).onChange(of: viewModel.selectDate) { newValue in
                        selectIndex = 0
                    }
            }
            
            tvSubTitle(text: StringKey.selectTime).positionLeading().padding(.top)
            
            HStack(spacing: Padding.constantLargePadding){
                VStack(spacing: 6){
                    tvFootnote(text: StringKey.from, color: Color.blue500)
                    tvHeadlineString(text: viewModel.startHour.formatted(date: .omitted, time: .shortened), color: .black)
                        .onTapGesture {
                            showStartPicker.toggle()
                        }
                }
                Image(systemName: "chevron.right")
                
                VStack(spacing: 6){
                    tvFootnote(text: StringKey.to, color: Color.blue500)
                    tvHeadlineString(text: viewModel.finishHour.formatted(date: .omitted, time: .shortened), color: .black).onTapGesture {
                        showEndPicker.toggle()
                    }
                }
            }.frame(maxWidth: .infinity).padding().background(Color.unselectButton).mediumCorner()
            
            btnIconText(stringKey: StringKey.tenMinuteTimer, systemName: "bell", action: {
                viewModel.tenMinuteSelected.toggle()
            }, selected: $viewModel.tenMinuteSelected).positionLeading()
            
            VStack(alignment: .leading) {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(viewModel.categories, id: \.self) { category in
                        CategoryTag(model: category, isSelected: viewModel.selectedCategory == category) {
                            viewModel.selectedCategory = category
                        }
                    }
                    CategoryTag(model: CategoryModel(colorHex: "#0000FF", name: ""), isAddButton: true) {
                        showAddCategorySheet = true
                    }
                }
            }
            
            tvSubTitle(text: StringKey.title).positionLeading().padding(.top)
            
            tfText(placeHolder: StringKey.title, textInput: $viewModel.titleInput)
            
            tvSubTitle(text: StringKey.comment_title).positionLeading().padding(.top)
            
            teText(placeHolder: StringKey.memory_comment, textInput: $viewModel.commentInput).frame(height: Height.xLargeHeight)
                .focused($focusedField, equals: .comment)
                .simultaneousGesture(
                    TapGesture().onEnded({ _ in
                        focusedField = nil
                    })
                )
            
            btnTextGradientInfinity(shadow: Radius.shadowSmallRadius, action: {
                viewModel.saveEvent()
            }, text: StringKey.add).padding(.top,Padding.constantMediumPadding)
        }.padding(20).ignoresSafeArea(.all,edges: .bottom).sheet(isPresented: $showStartPicker) {
            TimePickerBottomSheet(title: StringKey.startHour, date: $viewModel.startHour)
                .presentationDetents([.height(Height.bottomSheetHeight)])
        }
        .sheet(isPresented: $showEndPicker) {
            TimePickerBottomSheet(title: StringKey.endHour, date: $viewModel.finishHour)
                .presentationDetents([.height(Height.bottomSheetHeight)])
        }.sheet(isPresented: $showAddCategorySheet) {
            VStack(alignment: .leading, spacing: 20) {
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: 40, height: 5)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                Text(StringKey.addNewCategory)
                    .font(.title2)
                    .bold()
                TextField(StringKey.categoryName, text: $viewModel.newCategoryName)
                    .textFieldStyle(.roundedBorder)
                ColorPicker(getLocalizedString(StringKey.categoryColor), selection: $viewModel.newCategoryColor)
                Button(getLocalizedString(StringKey.add)) {
                    viewModel.addCategoryFromInput()
                    showAddCategorySheet = false
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.newCategoryName.trimmingCharacters(in: .whitespaces).isEmpty)
                Spacer()
            }
            .presentationDetents([.height(300)])
            .presentationDragIndicator(.visible)
            .padding()
        }
        .onChange(of: viewModel.error, perform: {newValue in
            let toast = ToastValue(message: getLocalizedString(StringKey.sameTimeError))
            presentToast(toast)
        })
        .onChange(of: viewModel.success, perform: {newValue in
            if newValue {
                let toast = ToastValue(message: getLocalizedString(StringKey.success))
                presentToast(toast)
            }
        })
    }
    enum CreateEventState {
        case comment
    }
}

#Preview {
    @State var select = true
    var num = "10"
    var text = "tuesday"
    CreateEventUI()
}
