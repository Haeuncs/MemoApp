//
//  MemoAppWidget.swift
//  MemoAppWidget
//
//  Created by user on 2020/07/12.
//  Copyright © 2020 LEE HAEUN. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
  public func snapshot(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (SimpleEntry) -> ()) {
    let entry = SimpleEntry(date: Date(), configuration: configuration)
    completion(entry)
  }

  public func timeline(for configuration: ConfigurationIntent, with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
    var entries: [SimpleEntry] = []

    // Generate a timeline consisting of five entries an hour apart, starting from the current date.
    let currentDate = Date()
    for hourOffset in 0 ..< 5 {
      let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
      let entry = SimpleEntry(date: entryDate, configuration: configuration)
      entries.append(entry)
    }

    let timeline = Timeline(entries: entries, policy: .atEnd)
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  public let date: Date
  public let configuration: ConfigurationIntent
}

struct PlaceholderView : View {
  var body: some View {
    Text("Placeholder View")
  }
}

struct MemoAppWidgetEntryView : View {
  var entry: Provider.Entry

  var body: some View {
    VStack(alignment: .leading) {
      Text("토요일")
        .font(.system(size: 12))
        .fontWeight(.semibold)
        .padding(.top, 4)
      Text("7월 11일")
        .font(.system(size: 14))
        .fontWeight(.semibold)
        .padding(.top, 9)
        .padding(.bottom, 20)
      Group {
        Text("빠르게 메모 추가")
          .font(.system(size: 14 ))
          .fontWeight(.heavy)
          .foregroundColor(.white)
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
      .background(Color.black)
      .cornerRadius(14)
    }
    .padding([.bottom], 20)
    .padding([.top, .leading, .trailing], 20)
  }
}

@main
struct MemoAppWidget: Widget {
  private let kind: String = "MemoAppWidget"

  public var body: some WidgetConfiguration {
    IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider(), placeholder: PlaceholderView()) { entry in
      MemoAppWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("My Widget")
    .description("This is an example widget.")
  }
}

struct MemoAppWidget_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      MemoAppWidgetEntryView(entry: SimpleEntry(date: Date(), configuration: ConfigurationIntent()))
        .previewContext(WidgetPreviewContext(family: .systemSmall))
      PlaceholderView()
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
  }
}
