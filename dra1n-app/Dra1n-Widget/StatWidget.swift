//
//  DischargeWidget.swift
//  Dra1n-WidgetExtension
//
//  Created by Andromeda on 23/04/2021.
//

import WidgetKit
import SwiftUI

struct StatProvider: TimelineProvider {
    func placeholder(in context: Context) -> StatEntry {
        StatEntry(date: Date(), stats: Dra1nController.batteryData, averages: [500, 300, 134])
    }

    func getSnapshot(in context: Context, completion: @escaping (StatEntry) -> ()) {
        let entry = StatEntry(date: Date(), stats: Dra1nController.batteryData, averages: [500, 300, 134])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [StatEntry] = []
        let array = Dra1nDefaults.getObject(key: "DrainAvarageLog") as? [[String : Any]] ?? [[String : Any]]()
        var averages = [Int]()
        for item in array {
            let drain = item["drain"] as? Int ?? 0
            averages.append(abs(drain))
        }
        let entry = StatEntry(date: Date(), stats: Dra1nController.batteryData, averages: averages)
        entries.append(entry)
        let date = Calendar.current.date(byAdding: .minute, value: 5, to: Date())
        let timeline = Timeline(entries: entries, policy: .after(date!))
        completion(timeline)
    }
}

struct StatEntry: TimelineEntry {
    let date: Date
    let stats: BatteryStats?
    let averages: [Int]
}

struct StatWidgetView : View {
    var entry: StatProvider.Entry

    var body: some View {
        Text("\(entry.stats?.dischargeCurrent ?? 0) mAH")
    }
}

struct StatWidget: Widget {
    let kind: String = "Dra1n Stats Widget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: StatProvider()) { entry in
            StatWidgetView(entry: entry)
        }
        .configurationDisplayName("Battery Stats")
        .description("Battery Statistics")
        .supportedFamilies([.systemSmall])
    }
}

struct NextLessonWidget_Previews: PreviewProvider {
    static var previews: some View {
        StatWidgetView(entry: StatEntry(date: Date(), stats: Dra1nController.batteryData, averages: [500, 300, 134]))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
