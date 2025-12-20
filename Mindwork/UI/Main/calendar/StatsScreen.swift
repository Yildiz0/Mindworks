
import SwiftUI
import Charts
import Kingfisher

struct CalendarUI: View {
    @StateObject private var vm = StatsViewModel()
    
    var body: some View {
        NavigationStack {
            VStack{
                header
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 16) {
                        rangePicker
                        chartCard
                        scoresSection
                        badgesSection
                        gamesSection
                    }
                    
                }.background(Color(.systemGroupedBackground))
                    .navigationBarTitleDisplayMode(.inline)
                    .refreshable {
                                    await vm.reloadAsync()
                                    }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

// MARK: - Sections
private struct RangePill: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)                // type checker'ı rahatlat
                .fontWeight(.semibold)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(backgroundView)        // ayrı ViewBuilder
                .foregroundColor(isSelected ? .white : .primary)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var backgroundView: some View {
        let fillColor: Color = isSelected ? .black : Color(.secondarySystemBackground)
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(fillColor)
    }
}

private extension CalendarUI {
    var header: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("Hi, \(vm.user.name)")
                        .font(.title3).fontWeight(.semibold)
                    Text("👋")
                }
                Text("This is your progress report")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            KFImage.profile(urlString: vm.user.profileImageUrl, size: 60)
        }
        .padding(.top, 8)
    }
    
    var rangePicker: some View {
        HStack(spacing: 8) {
            ForEach(StatsRange.allCases, id: \.self) { r in
                RangePill(
                    title: r.rawValue,
                    isSelected: vm.selected == r,
                    action: {
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                            vm.selected = r
                        }
                    }
                )
            }
        }
        .padding(6)
        .background(
            RoundedRectangle(cornerRadius: 14).fill(Color(.tertiarySystemBackground))
        )
    }
    
    var chartCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Chart(vm.series) { point in
                AreaMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(Gradient(colors: [
                    Color.green.opacity(0.25),
                    Color.green.opacity(0.05)
                ]))
                
                LineMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .interpolationMethod(.catmullRom)
                .lineStyle(.init(lineWidth: 2))
                .foregroundStyle(.green)
                
                PointMark(
                    x: .value("Date", point.date),
                    y: .value("Value", point.value)
                )
                .symbolSize(10)
                .foregroundStyle(.green.opacity(0.6))
            }
            .chartXAxis { AxisMarks(values: .automatic(desiredCount: 5)) }
            .chartYAxis { AxisMarks(position: .leading) }
            .frame(height: 180)
            
            HStack {
                Label("Progress", systemImage: "chart.line.uptrend.xyaxis")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(vm.selected.rawValue)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.06), radius: 10, y: 6)
    }
    
    var scoresSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Scores")
                .font(.headline)
            
            VStack(spacing: 10) {
                scoreRow(icon: "timer", title: labelForTimeTitle(), value: formatMinutesDouble(vm.totalMinutes))
                scoreRow(icon: "checkmark.seal", title: "Success Rate", value: "\(Int(vm.successRate * 100))%")
                scoreRow(icon: "flag.checkered", title: goalTitle(), value: vm.goalDone ? "Done" : "Pending")
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 5)
    }
    func formatMinutesDouble(_ minutes: Double) -> String {
        String(format: "%.2f min", minutes)
    }
    func scoreRow(icon: String, title: String, value: String) -> some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Color.green.opacity(0.15)))
                .foregroundStyle(.green)
                .clipShape(Circle())
            VStack(alignment: .leading) {
                Text(title).font(.subheadline)
                Text(value).font(.footnote).foregroundStyle(.secondary)
            }
            Spacer()
        }
    }
    
    var badgesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Badges")
                .font(.headline)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(vm.badges) { b in
                        VStack(spacing: 8) {
                            Image(systemName: b.systemImage)
                                .font(.title2)
                                .foregroundStyle(b.earned ? .yellow : .secondary)
                                .frame(width: 56, height: 56)
                                .background(
                                    Circle()
                                        .fill(b.earned ? Color.yellow.opacity(0.15) : Color(.secondarySystemBackground))
                                )
                            Text(b.title)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(8)
                        .background(RoundedRectangle(cornerRadius: 14).fill(.background))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(b.earned ? Color.yellow.opacity(0.4) : Color.clear, lineWidth: 1)
                        )
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 5)
    }
    
    var levelSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Label("Level 4 • XP", systemImage: "star.fill")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("\(vm.levelXP.current)/\(vm.levelXP.max)")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: Double(vm.levelXP.current), total: Double(vm.levelXP.max))
                .tint(.green)
                .animation(.easeInOut(duration: 0.35), value: vm.levelXP.current)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 5)
    }
    
    var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Categories")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(vm.categories) { c in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Label(c.name, systemImage: c.icon)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text("Level XP \(c.levelXP.current)/\(c.levelXP.max)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        ProgressView(value: c.progress)
                            .tint(.green)
                            .animation(.easeInOut(duration: 0.35), value: c.progress)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 5)
    }
    
    var gamesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Game Statistics")
                .font(.headline)
            
            VStack(spacing: 12) {
                ForEach(vm.games) { g in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(g.name)
                                .font(.subheadline.weight(.semibold))
                            Spacer()
                            Text(String(format: "Avg %.2f s", g.avgSeconds))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        
                        ProgressView(value: g.successRate)
                            .tint(.green)
                            .animation(.easeInOut(duration: 0.35), value: g.successRate)
                            .clipShape(RoundedRectangle(cornerRadius: 6))
                        
                        Text("Success Rate \(Int(g.successRate * 100))%")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 14).fill(Color(.secondarySystemBackground)))
                }
            }
        }
        .padding(14)
        .background(RoundedRectangle(cornerRadius: 18).fill(.background))
        .shadow(color: .black.opacity(0.04), radius: 8, y: 5)
    }
}

// MARK: - Helpers

private extension CalendarUI {
    func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 { return "\(minutes) minute" }
        let h = minutes / 60
        let m = minutes % 60
        return "\(h)h \(m)m"
    }
    func labelForTimeTitle() -> String {
        switch vm.selected {
        case .today: return "Today's Time"
        case .week:  return "This Week's Time"
        case .month: return "This Month Time"
        }
    }
    func goalTitle() -> String {
        switch vm.selected {
        case .today: return "Daily Goal"
        case .week:  return "Weekly Goal"
        case .month: return "Monthly Goal"
        }
    }
}

// MARK: - Preview

struct StatsScreen_Previews: PreviewProvider {
    static var previews: some View {
        CalendarUI()
            .environment(\.colorScheme, .light)
    }
}
