//
//  FeedViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 23.01.2025.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class FeedViewModel: BaseViewModel {
    
    // UI-de gösterilecek listeler
    @Published var questionList = questionTitles
    @Published var gameList     = gamesTitles
    
    // Aktif oturum (dinleyici buna göre ayarlanır)
    @Published var session: GameSessionModel?
    
    // Yarım oyun bulunduğunda ekrana sorulacak
    @Published var pendingGame: GameSessionModel?
    @Published var showResumeAlert = false
    
    // Hata
    @Published var errorMessage: String?
    /*
    // MARK: Public entry
    func createOrResumeQuestionGame(type: QuestionType) {
        Task {
            let relationId  = try await RelationRepository.shared.getRelationId()
            let relation    = try await FirestorageManager.shared.fetchUserRelationship(relationId: relationId)
            
            let result = await FirestorageManager.shared.checkAndCreateAnyGameSession(
                relationId:  relationId,
                newGameType: .question,
                questionType: type,
                firstName:  relation.firstUserName,
                firstImage: relation.firstUserImageUrl,
                secondName: relation.secondUserName ?? "",
                secondImage: relation.secondUserImageUrl ?? ""
            )
            
            await MainActor.run {
                switch result {
                case .existing(let game):
                    self.pendingGame     = game
                    self.showResumeAlert = true         // UI gösterecek
                case .created(let game):
                    activateSession(game)
                case .failure(let err):
                    self.errorMessage = err.localizedDescription
                }
            }
        }
    }
    
    // MARK: −  Alert seçimleri
    func resumePendingGame() {
        guard let game = pendingGame else { return }
        activateSession(game)
        pendingGame     = nil
        showResumeAlert = false
    }
    
    func cancelPendingGame() async {
        guard let game = pendingGame,
              let relationId = try? await RelationRepository.shared.getRelationId(),
              let gameId = game.id else { return }
        
        let ref = Firestore.firestore()
            .collection("Relationship")
            .document(relationId)
            .collection("games")
            .document(gameId)
        
        // fazı canceled yapıyoruz (silmek istersen delete())
        //Task { try? await ref.updateData(["phase": GamePhase.canceled.rawValue]) }
        
        pendingGame     = nil
        showResumeAlert = false
    }
    /*
    // MARK: −  Oturumu aktif edip dinleyici başlat
    private func activateSession(_ game: GameSessionModel) {
        self.session = game
        listenSessionChanges(game)          // senin mevcut dinleyici fonksiyonun
    }
     */*/
}
