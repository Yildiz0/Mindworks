//
//  HistoryViewModel.swift
//  Tendria
//
//  Created by Yakup Kavak on 2.02.2025.
//

import Foundation
import SwiftUI

class CreateEventViewModel: BaseViewModel{
    
    @Published var dateList = [EventDateModel]()
    @Published var selectDate = Date(){
        didSet {
            print("date changed \(selectDate)")
            onDateChanged()
        }
    }
    
    @Published var startHour: Date {
        didSet {
            let combined = combineDateWithTime(time: startHour)
            if !Calendar.current.isDate(startHour, equalTo: combined, toGranularity: .minute) {
                startHour = combined
            }
        }
    }
    
    @Published var finishHour: Date {
        didSet {
            let combined = combineDateWithTime(time: finishHour)
            if !Calendar.current.isDate(finishHour, equalTo: combined, toGranularity: .minute) {
                finishHour = combined
            }
        }
    }
    
    @Published var categories = [CategoryModel]()
    @Published var selectedCategory: CategoryModel? = nil
    @Published var titleInput = ""
    @Published var commentInput = ""
    @Published var newCategoryName = ""
    @Published var newCategoryColor = Color.blue
    @Published var success = false
    @Published var loading = false
    @Published var location = ""
    @Published var error = ""
    @Published var tenMinuteSelected = false
    @Published var savedPalette: [Color] = []
    
    private let categoryKey = CalendarConstants.CATEGORYKEY
    
    override init() {
        let now = Date()
        let defaultStart = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: now)!
        let defaultFinish = Calendar.current.date(bySettingHour: 14, minute: 0, second: 0, of: now)!
        
        self.selectDate = now
        self.startHour = defaultStart
        self.finishHour = defaultFinish
        super.init()
        self.dateList = generateDateList(startDate: now)
        loadSavedCategories()
    }
    
    private func generateDateList(startDate: Date) -> [EventDateModel]{
        var dateList = [EventDateModel]()
        let calendar = Calendar.current
        for i in 0...2{
            guard let newDate = calendar.date(byAdding: .day, value: i, to: startDate) else { continue }
            let weekIndex = calendar.component(.weekday, from: newDate) - 1
            let day = calendar.component(.day, from: newDate)
            let eventModel = EventDateModel(number: String(day), text: getLocalizedString(Tables.days[weekIndex]))
            dateList.append(eventModel)
        }
        dateList.append(EventDateModel(number: getLocalizedString(StringKey.other), text: getLocalizedString(StringKey.date)))
        return dateList
    }
    
    func onDateChanged() {
        self.dateList = generateDateList(startDate: selectDate)
    }
    
    func addCategoryFromInput() {
        let hex = newCategoryColor.toHex() ?? "#000000"
        let newCategory = CategoryModel(colorHex: hex, name: newCategoryName)
        addCategory(category: newCategory)
        clearCategoryInput()
    }
    
    func addCategory(category: CategoryModel) {
        categories.append(category)
        selectedCategory = category
        saveCategoriesToUserDefaults()
    }
    
    func clearCategoryInput() {
        newCategoryName = ""
        newCategoryColor = .blue
    }
    
    private func saveCategoriesToUserDefaults() {
        let encoded = try? JSONEncoder().encode(categories)
        UserDefaults.standard.set(encoded, forKey: categoryKey)
    }
    
    private func loadSavedCategories() {
        guard let data = UserDefaults.standard.data(forKey: categoryKey),
              let decoded = try? JSONDecoder().decode([CategoryModel].self, from: data) else { return }
        categories = decoded
    }
    
    private func combineDateWithTime(time: Date) -> Date {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: time)
        let minute = calendar.component(.minute, from: time)
        
        var components = calendar.dateComponents([.year, .month, .day], from: selectDate)
        components.hour = hour
        components.minute = minute
        
        return calendar.date(from: components) ?? time
    }
    
    private func syncStartAndFinishDateToSelectedDate() {
        startHour = combineDateWithTime(time: startHour)
        finishHour = combineDateWithTime(time: finishHour)
    }
    
    func saveEvent(){
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: startHour)
        let finishComponents = calendar.dateComponents([.hour, .minute], from: finishHour)
        
        if startComponents.hour == finishComponents.hour &&
            startComponents.minute == finishComponents.minute {
            error = ""
            self.error = getLocalizedString(StringKey.sameTimeError) // ← Localized key
            return
        } else if titleInput.isEmpty {
            error = ""
            self.error = getLocalizedString(StringKey.titleEmpty)
        }
        /*
        getDataCall(dataCall: {try await FirestorageManager.shared.saveEvent(title: self.titleInput, description: self.commentInput, date: self.selectDate, startHour: self.startHour, endHour: self.finishHour, tenMinuteNotification: self.tenMinuteSelected, category: self.selectedCategory, location: self.location)}
        ) { _ in
            self.success = true
            self.loading = false
        } onLoading: {
            self.loading = true
        } onError: { error in
            self.error = error?.localizedDescription ?? getLocalizedString(StringKey.unknown_error)
            self.loading = false
        }*/
    }
}
