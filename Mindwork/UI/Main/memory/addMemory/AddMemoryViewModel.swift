//
//  AddTaskViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 5.02.2025.
//

import Foundation
import _PhotosUI_SwiftUI
import UIKit
import FirebaseCore

class AddMemoryViewModel: BaseViewModel{
    @Published var selectedPhotos = [PhotosPickerItem]()
    @Published var imageSequence = [ImageSeqUI(index: 0, image: UIImage(named: Icons.imageUploadIcon)!,isEmpty: true),ImageSeqUI(index: 1, image: UIImage(named: Icons.imageUploadIcon)!, isEmpty: true),ImageSeqUI(index: 2, image: UIImage(named: Icons.imageUploadIcon)!, isEmpty: true)]
    @Published var titleInput = ""
    @Published var commentInput = ""
    @Published var success = false
    @Published var maxPhotoSelect = 3
    @Published var loading = false
    @Published var error = ""
    @Published var isImageSelected = false
    @Published var selectedDate: Date = Date()
    @Published var showKeyboard = false
    private var relationId: String?
    private var isAllFull = false
    private var emptyCount = 3
    
    @MainActor
    func convertDataToImage(selectedIndex: Int) {
        checkFull()
        guard !selectedPhotos.isEmpty else { return }
        
        Task{
            var previouslyimageSequence = imageSequence.sorted(by: {$0.index < $1.index})
            print("previouslyimageSequence -> \(previouslyimageSequence)")
            var imageList = [UIImage]()
            for eachItem in selectedPhotos {
                if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData){
                        imageList.append(image)
                    }
                }
            }
            addImages(selectedImages: imageList, list: &previouslyimageSequence, selectedIndex: selectedIndex)
            selectedPhotos = []
            imageSequence = []
            imageSequence = previouslyimageSequence
        }
    }
    
    func addImages(selectedImages: [UIImage], list: inout [ImageSeqUI],selectedIndex: Int){ //normal eklemede sondan başlayarak görseller ekleniyor
        let numberArray = (0..<3).map { (selectedIndex + $0) % 3} //seçilenden 0.eleman -> 1  1.eleman -> 2  2.eleman ->0
        var indexCounter = 0
        checkFull()
        if(isAllFull){
            for (index,image) in selectedImages.enumerated(){ // bu diğerleri boş ise çalışacak
                list[numberArray[index]].image = image
                list[numberArray[index]].isEmpty = false
                maxPhotoSelect = (maxPhotoSelect != 1) ? maxPhotoSelect - 1 : maxPhotoSelect
                emptyCount = (emptyCount != 0) ? emptyCount - 1 : emptyCount
            }
        }else {
            for id in numberArray{ // bu diğerleri boş ise çalışacak
                if(list[id].isEmpty == true){
                    list[id].image = selectedImages[indexCounter]
                    list[id].isEmpty = false
                    indexCounter += 1
                    maxPhotoSelect = (maxPhotoSelect != 1) ? maxPhotoSelect - 1 : maxPhotoSelect
                    emptyCount = (emptyCount != 0) ? emptyCount - 1 : emptyCount
                    if(indexCounter == selectedImages.count) {
                        break
                    }
                }
            }
        }
    }
    
    private func checkFull(){
        var isEmpty = true
        for i in imageSequence {
            if(i.isEmpty == true){
                isAllFull = false
                isEmpty = false
            }
        }
        if(isEmpty){
            isAllFull = true
        }
    }
    
    func getImage(selectedIndex: Int) -> UIImage{
        for i in imageSequence {
            if(i.index == selectedIndex){
                return i.image
            }
        }
        return UIImage()
    }
    
    func rotateRight() {
        for i in 0..<imageSequence.count {
            imageSequence[i].index = (imageSequence[i].index + 2) % 3
        }
        imageSequence.sort(by: {$0.index < $1.index})
    }

    func rotateLeft() {
        for i in 0..<imageSequence.count {
            imageSequence[i].index = (imageSequence[i].index + 1) % 3
        }
        imageSequence.sort(by: {$0.index < $1.index})
    }
    
    func setKeyboardVisibility(isVisible: Bool){
        if(isVisible){
            showKeyboard = true
        }else {
            showKeyboard = false
        }
    }
    
    func removeImage(selectedIndex: Int){
        imageSequence[selectedIndex].image = UIImage(named: Icons.imageUploadIcon)!
        imageSequence[selectedIndex].isEmpty = true
        if(emptyCount > 0){
            maxPhotoSelect += 1
        }
        emptyCount += 1
    }
    
    func putCroppedImage(croppedImage: UIImage){
        isImageSelected = true
    }
    
    func saveMemory(collectionId: String) {
        var imageDatas = [Data]()
        for imageSeq in imageSequence{
            if(!imageSeq.isEmpty){
                guard let imageData = imageSeq.image.jpegData(compressionQuality: 0.8) else { return }
                imageDatas.append(imageData)
            }
        }
        guard let relationId = RelationRepository.shared.relationId else {return}
        getDataCall {
            try await FirestorageManager.shared.addMemoryImages(imageDatas: imageDatas)
        } onSuccess: { downloadUrls in
            self.saveMemoryDocument(downloadUrls: downloadUrls,relationId: relationId, collectionId: collectionId)
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? ""
        }
    }
    
    func saveMemoryDocument(downloadUrls: [String], relationId: String,collectionId: String) {
        //TODO USER1 IMAGA EKLENECEK
        let memoryDocumentModel = MemoryDocumentModel(collectionId: collectionId, imageUrls: downloadUrls, relationId: relationId, title: self.titleInput, userOneDescription: self.commentInput, userTwoDescription: nil, userOneImage: nil, userTwoImage: nil, createDate: Timestamp(date: self.selectedDate))
        getDataCall {
            try await FirestorageManager.shared.addMemoryDocument(memoryDocumentModel: memoryDocumentModel)
        } onSuccess: { success in
            self.loading = false
            self.success = true
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? ""
        }
    }
}
