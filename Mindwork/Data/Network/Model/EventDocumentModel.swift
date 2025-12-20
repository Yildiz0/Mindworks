//
//  EventModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 11.05.2025.
//

import Foundation
import FirebaseFirestore
import FirebaseCore

struct EventDocumentModel: Identifiable,Codable,Equatable,Hashable{
    @DocumentID var id: String?
    let relationId: String
    var title: String
    var comment: String
    var eventDate: Timestamp
    var startHour: Timestamp
    var finishHour: Timestamp
    var location: String
    var category: CategoryModel?
    var isRemind: Bool
    var createrProfileImage: String?
    var createrName: String
    
    enum CodingKeys: String, CodingKey {
      case id
      case relationId
      case title
      case comment
      case eventDate
      case startHour
      case location
      case finishHour
      case category
      case isRemind
      case createrProfileImage
      case createrName
    }
}
extension EventDocumentModel {
    var eventDay: Date { eventDate.dateValue()}
    
    var startText: String {
        DateFormatter.hourMinute.string(from: startHour.dateValue())
    }
    var finishText: String {
        DateFormatter.hourMinute.string(from: finishHour.dateValue())
    }
}

private extension DateFormatter {
    static let hourMinute: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        f.locale = Locale(identifier: "en_US_POSIX")   // 24-saat garantisi
        return f
    }()
}
