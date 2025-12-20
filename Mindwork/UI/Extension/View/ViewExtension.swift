//
//  ViewExtension.swift
//  Mindwork
//
//  Created by Yakup Kavak on 2.08.2025.
//

import Foundation
import SwiftUI
import Kingfisher
import SwiftyCrop

extension View {
    func normalShadow() -> some View {
        self.shadow(color: Color.black.opacity(0.2), radius: Constants.Radius.shadowRadius, x: 0, y: 5)
    }
    func gradientBackground() -> some View{
        self.background(LinearGradient(
            gradient: Gradient(colors: [
                Color.orange700, Color.red300]),
            startPoint: .leading,
            endPoint: .trailing
        ))
    }
    func customPadding(horizontal: CGFloat, vertical: CGFloat) -> some View {
        self
            .padding(.horizontal, horizontal)
            .padding(.vertical, vertical)
    }
    func btnStyle() -> some View{
        self.customPadding(horizontal: Padding.mediumPadding, vertical: Padding.smallPadding).gradientBackground().normalShadow().cornerRadius(Constants.Radius.xLargeRadius)
    }
    func btnCircleStyle() -> some View{
        self.customPadding(horizontal: Padding.mediumPadding, vertical: Padding.smallPadding).background(Color.black).normalShadow().clipShape(.circle)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
            // Aktif windowScene'e ve onun içindeki ilk window'a erişiyoruz
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first else { return } // Eğer erişim olmazsa çık

            // Bir UITapGestureRecognizer oluşturuyoruz. Hedef: window. Aksiyon: klavyeyi kapat
            let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))

            // Diğer dokunma türleriyle çakışmaması için false yapılıyor
            tapGesture.requiresExclusiveTouchType = false
            
            // Diğer dokunmaların çalışmasını engelleme. Örn: ScrollView scroll edebilsin
            tapGesture.cancelsTouchesInView = false
            
            // Gesture’ın delegate'ini UIApplication’a veriyoruz (bu sayede kontrol bizde)
            tapGesture.delegate = self
            
            // Gesture’ı window’a ekliyoruz
            window.addGestureRecognizer(tapGesture)
        }
}

extension UIApplication: @retroactive UIGestureRecognizerDelegate {
    // Bu fonksiyon, birden fazla gesture’ın aynı anda tanınmasını kontrol eder
        public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
            // Eğer diğer gesture bir LongPress değilse, ikisi aynı anda çalışabilir
            return !otherGestureRecognizer.isKind(of: UILongPressGestureRecognizer.self)
        }
}
extension UINavigationController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
extension KFImage{
    func findTrueSize(uiImage: UIImage,maxHeight: CGFloat, maxWidth: CGFloat) -> some View{
        if(isWidthHigher(uiImage: uiImage)){
            self.resizable().scaledToFit().frame(width: maxWidth).clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius))
        }else{
            self.resizable().scaledToFit().frame(height: maxHeight).clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius))
        }
    }

}
extension Image{
    func findTrueSize(uiImage: UIImage,maxHeight: CGFloat, maxWidth: CGFloat) -> some View{
        if(isWidthHigher(uiImage: uiImage)){
            self.resizable().scaledToFit().frame(width: maxWidth).clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius))
        }else{
            self.resizable().scaledToFit().frame(height: maxHeight).clipShape(RoundedRectangle(cornerRadius: Radius.mediumRadius))
        }
    }
}

private func isWidthHigher(uiImage: UIImage) -> Bool {
    let width = uiImage.size.width
    let height = uiImage.size.height

    if(width >= height){
        return true
    }else {
        return false
    }
}

extension View{
    func smallCorner() -> some View{
        self.clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
    func mediumCorner() -> some View{
        self.clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
    func paddingHorizontal(value: CGFloat = 8) -> some View{
        self.padding([.leading,.trailing], value)
    }
    func DoubleSpacer() -> some View{
        Group{
            Spacer()
            Spacer()
        }
    }
    
    @ViewBuilder func isHidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if remove {
                EmptyView()
            } else {
                self.hidden()
            }
        } else {
            self
        }
    }

    func tabbarVisibility(visibility: Bool) -> some View{
        self.toolbar(visibility ? .visible : .hidden, for: .tabBar).animation(.default, value: visibility)
    }
    
    func positionLeading() -> some View{
        self.frame(maxWidth: .infinity,alignment: .leading)
    }
    
    func showNewRelation(
        isPresent: Binding<Bool>,
        onSuccess: @escaping () -> Void,
        messageText: String
    ) -> some View{
        
        self.overlay {
            if isPresent.wrappedValue {
                ZStack {
                    // Alert içeriği
                    BaseLottieAlertUI(uiLottieSource: LottieSet.BEAR_CAT_JSON,backgroundFirst: LottieSet.FIREWORK_JSON,backgroundSecond: LottieSet.CONFETTI_JSON, title: StringKey.new_relation_title, message: messageText, onSuccessText: StringKey.continue_text) {
                        onSuccess()
                    }
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isPresent.wrappedValue)
            }
        }
    }
    
    func navigateBackView(
        onClick: @escaping () -> Void
    ) -> some View{
        self.navigationBarBackButtonHidden(true).toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                btnSystemIconTransparent(iconSystemName: "chevron.left", color: Color.black) {
                    onClick()
                }
            }
        }
    }
    
    func cropImage(
        displayCrop: Binding<Bool>,
        beforeCropImage: UIImage?,
        onFinish: @escaping (UIImage) -> Void,
        maskShape: MaskShape,
        maskRadius: CGFloat,
        zoomSensitivity: CGFloat
    ) -> some View{
        self.fullScreenCover(isPresented: displayCrop, content: {
            if let selectedPhoto = beforeCropImage{
                SwiftyCropView(imageToCrop: selectedPhoto, maskShape: maskShape, configuration: SwiftyCropConfiguration.init(maskRadius:maskRadius,zoomSensitivity: zoomSensitivity,texts: SwiftyCropConfiguration.Texts(
                    cancelButton: getLocalizedString(StringKey.cancel),
                    interactionInstructions: getLocalizedString(StringKey.crop_title),
                    saveButton: getLocalizedString(StringKey.save)
                ))) { croppedImage in
                    guard let croppedImage else {
                        return
                    }
                    onFinish(croppedImage)
                    displayCrop.wrappedValue = false
                }
            }else {
                Text("Fotoğraf yüklenemedi")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                            displayCrop.wrappedValue = false
                        }
                    }
            }
        })
    }
    
    func showLoading(
        isPresent: Binding<Bool>
    ) -> some View{
        self.overlay {
            if isPresent.wrappedValue {
                ZStack {
                    // Alert içeriği
                    LoadingAlertUI()
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isPresent.wrappedValue)
            }
        }
    }
    
    func showRequestNotification(
        isPresent: Binding<Bool>,
        onSuccess: @escaping () -> Void,
        onDenied: @escaping () -> Void
        
    ) -> some View{
        self.overlay {
            if isPresent.wrappedValue {
                ZStack {
                    // Alert içeriği
                    BaseImageAlertUI(
                        onSuccess: {
                            onSuccess()
                        },
                        onDenied: {
                            onDenied()
                        }
                    )
                }
                .transition(.opacity)
                .animation(.easeInOut, value: isPresent.wrappedValue)
            }
        }
    }
    
    func keyboardAdaptive(canUpdate: Binding<Bool>) -> some View {
        ModifiedContent(content: self, modifier: KeyboardAdaptive(canUpdate: canUpdate))
    }
    
    func stackPosition(position: Int, zeroIndexWidth: CGFloat) -> some View {
        var offset = CGFloat(0)
        switch position {
        case 0: offset = 0
        case 1: offset = -zeroIndexWidth * 0.5
        case 2: offset = zeroIndexWidth * 0.5
        default: break
        }
        return self.offset(x: offset)
    }
}
