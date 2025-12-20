//
//  HistoryViewModel.swift  (StatsViewModel gerçek veriye göre)
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore

struct ActivityPoint: Identifiable {
    let id = UUID()
    let date: Date
    let value: Double       // grafikte gösterilecek değer (dakika)
}

enum StatsRange: String, CaseIterable, Identifiable {
    case today = "Today"
    case week = "This Week"
    case month = "This Month"
    var id: String { rawValue }
}

struct Badge: Identifiable {
    let id = UUID()
    let systemImage: String
    let title: String
    let earned: Bool
}

struct CategoryProgress: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let progress: Double // 0...1
    let levelXP: (current: Int, max: Int)
}

struct GameStats: Identifiable {
    let id = UUID()
    let name: String
    let successRate: Double   // 0...1
    let avgSeconds: Double    // ✅ Firestore’daki averageTime (saniye/soru)
}

final class StatsViewModel: BaseViewModel {
    // Input
    @Published var selected: StatsRange = .today { didSet { compute() } }

    // Output
    @Published private(set) var series: [ActivityPoint] = []
    @Published private(set) var badges: [Badge] = []
    @Published private(set) var categories: [CategoryProgress] = []
    @Published private(set) var games: [GameStats] = []

    @Published var totalMinutes: Double = 0.0
    @Published var successRate: Double = 0.0
    @Published var goalDone: Bool = false
    @Published var levelXP: (current: Int, max: Int) = (0, 0)
    @Published var user: UserModel = UserModel(profileImageUrl: nil,
                                               relationId: "",
                                               userId: nil,
                                               fcmToken: "",
                                               name: "",
                                               surname: "",
                                               userLanguage: "en")
    // Data
    @Published private var allGames: [GameStoreModel] = []
    private let db = Firestore.firestore()

    override init() {
        super.init()
        Task { await reloadFromFirestore() }
    }

    // MARK: - Public
    func reload() {
        Task { await reloadFromFirestore() }
    }
    
    func fetchProfile(){
        getDataCall(dataCall: {
            try await FirestorageManager.shared.fetchProfile()
        }, onSuccess: { (user: UserModel) in
            self.user = user
        }, onLoading: {
            print("loading user image")
        }, onError: { error in
            print(error?.localizedDescription ?? "")
        })
    }
    // MARK: - Firestore
    private func reloadFromFirestore() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if let user = UserManager.shared.userInstance {
            self.user = user
        }
        fetchProfile()
        do {
            let snap = try await db.collection("Users")
                .document(uid)
                .collection("games")
                .order(by: "date", descending: true)
                .getDocuments()

            let items: [GameStoreModel] = try snap.documents.map { try $0.data(as: GameStoreModel.self) }
            DispatchQueue.main.async {
                self.allGames = items
                self.compute()
            }
        } catch {
            print("fetch games error:", error.localizedDescription)
        }
    }

    // MARK: - Compute
    private func compute() {
        let filtered = filter(allGames, by: selected)

        // toplam saniye = ortalama_saniye_soru_başı * 10 * oyun_sayısı
        let totalSec = filtered.reduce(0.0) { $0 + ($1.averageTime * 10.0) }

        // ✅ toplam dakika (Double)
        totalMinutes = totalSec / 60.0

        successRate = average(of: filtered.map { $0.successRate })

        // eşikler/puanlar Double'a göre
        goalDone = totalMinutes >= 10.0
        levelXP = (min(200, Int(totalMinutes * 3.2)), 200)

        series = buildSeries(for: selected, from: filtered)
        games  = buildGameStats(from: filtered)

        badges = [
            .init(systemImage: "flame.fill",  title: "Streak",  earned: playedToday(allGames)),
            .init(systemImage: "target",      title: "Focus",   earned: successRate >= 0.7),
            .init(systemImage: "hare.fill",   title: "Speed",   earned: average(of: filtered.map { $0.averageTime }) <= 1.0),
            .init(systemImage: "trophy.fill", title: "Winner",  earned: games.contains(where: { $0.successRate >= 0.9 }))
        ]

        categories = [
            .init(name: "Memory",       icon: "brain.head.profile",
                  progress: clamp(Double(countTypes(filtered, [.was_it_there, .which_different])) / 10.0),
                  levelXP: (min(120, Int(totalMinutes * 1.1)), 120)),
            .init(name: "Focus",        icon: "scope",
                  progress: clamp(Double(countTypes(filtered, [.colorful_words, .catch_pair])) / 10.0),
                  levelXP: (min(120, Int(totalMinutes * 0.9)), 120)),
            .init(name: "Place & Time", icon: "clock",
                  progress: clamp(Double(countTypes(filtered, [.firefly_title])) / 10.0),
                  levelXP: (min(120, Int(totalMinutes * 0.6)), 120))
        ]
    }

    // filter
    private func filter(_ items: [GameStoreModel], by range: StatsRange) -> [GameStoreModel] {
        let cal = Calendar.current
        let now = Date()
        switch range {
        case .today:
            let start = cal.startOfDay(for: now)
            return items.filter { $0.date.dateValue() >= start }
        case .week:
            let start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now))!
            return items.filter { $0.date.dateValue() >= start }
        case .month:
            let start = cal.date(byAdding: .day, value: -29, to: cal.startOfDay(for: now))!
            return items.filter { $0.date.dateValue() >= start }
        }
    }

    // buildSeries
    private func buildSeries(for range: StatsRange, from items: [GameStoreModel]) -> [ActivityPoint] {
        let cal = Calendar.current
        let now = Date()

        func bucketSum(from start: Date, to end: Date) -> Double {
            let sec = items
                .filter { let d = $0.date.dateValue(); return d >= start && d < end }
                .reduce(0.0) { $0 + $1.averageTime }
            return sec / 60.0
        }

        switch range {
        case .today:
            let dayStart = cal.startOfDay(for: now)
            return (0..<24).map { h in
                let s = cal.date(byAdding: .hour, value: h, to: dayStart)!
                let e = cal.date(byAdding: .hour, value: 1, to: s)!
                return ActivityPoint(date: s, value: bucketSum(from: s, to: e))
            }
        case .week:
            let start = cal.date(byAdding: .day, value: -6, to: cal.startOfDay(for: now))!
            return (0..<7).map { i in
                let s = cal.date(byAdding: .day, value: i, to: start)!
                let e = cal.date(byAdding: .day, value: 1, to: s)!
                return ActivityPoint(date: s, value: bucketSum(from: s, to: e))
            }
        case .month:
            let start = cal.date(byAdding: .day, value: -29, to: cal.startOfDay(for: now))!
            return (0..<30).map { i in
                let s = cal.date(byAdding: .day, value: i, to: start)!
                let e = cal.date(byAdding: .day, value: 1, to: s)!
                return ActivityPoint(date: s, value: bucketSum(from: s, to: e))
            }
        }
    }

    private func buildGameStats(from items: [GameStoreModel]) -> [GameStats] {
        let grouped = Dictionary(grouping: items, by: { $0.gameType })
        return grouped.keys.sorted(by: { $0.rawValue < $1.rawValue }).map { type in
            let arr = grouped[type] ?? []
            let avgSR     = average(of: arr.map { $0.successRate })
            let avgPerQ   = average(of: arr.map { $0.averageTime })   // saniye/soru (ham)
            return GameStats(
                name: prettyName(for: type),
                successRate: avgSR,
                avgSeconds: avgPerQ                                   // ✅ çarpma yok
            )
        }
    }
    private func prettyName(for type: GameType) -> String {
        switch type {
        case .which_different: return "Which One is Different"
        case .colorful_words:  return "Colorful Words"
        case .catch_pair:      return "Catch Number"
        case .was_it_there:    return "Was It There?"
        case .firefly_title:   return "Firefly"
        }
    }
    func reloadAsync() async {           // refreshable için async varyant
            await reloadFromFirestore()
        }
    private func secondsToMinutes(_ seconds: Double) -> Int {
        Int((seconds / 60.0).rounded()) // dakikaya yuvarla
    }

    private func average(of arr: [Double]) -> Double {
        guard !arr.isEmpty else { return 0 }
        return arr.reduce(0, +) / Double(arr.count)
    }

    private func playedToday(_ items: [GameStoreModel]) -> Bool {
        let start = Calendar.current.startOfDay(for: Date())
        return items.contains { $0.date.dateValue() >= start }
    }

    private func countTypes(_ items: [GameStoreModel], _ types: [GameType]) -> Int {
        items.filter { types.contains($0.gameType) }.count
    }

    private func clamp(_ v: Double) -> Double {
        min(1.0, max(0.0, v))
    }
}
