//
//  TrackerLiveActivity.swift
//  Tracker
//
//  Created by Merve on 7.12.2025.
//

import ActivityKit
import WidgetKit
import SwiftUI


@DynamicIslandExpandedContentBuilder
private func showExpandedUI(
  percent: Double,
  recordID: Int
) -> DynamicIslandExpandedContent<some View> {
  DynamicIslandExpandedRegion(.bottom) {
    ExpandedUI(
      percent: percent,
      recordID: recordID,
      isLockScreenView: false
    )
  }
}

private struct ExpandedUI: View {
  let percent: Double
  let recordID: Int
  let isLockScreenView: Bool
  
  var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      // İlerleme Çubuğu
      HStack(spacing: 12) {
        ProgressView(value: min(max(percent / 100.0, 0), 1))
          .progressViewStyle(.linear)
          .tint(.green)
        
        Text("\(Int(percent))%")
          .monospacedDigit()
          .bold()
      }
      
      if !isLockScreenView {
        HStack {
          Text("Record ID: \(recordID)")
            .font(.caption2)
            .foregroundStyle(.gray)
          Spacer()
          Text("Remaining: 20m") // Örnek veri
            .font(.caption2)
            .foregroundStyle(.gray)
        }
      }
    }
    .padding(.horizontal, 10)
    .padding(.bottom, 5)
  }
}

struct TrackerLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: TrackerAttributes.self) { context in
      // Lock screen/banner UI goes here
      HStack {
        Image(systemName: "bolt.fill")
          .font(.title)
          .foregroundStyle(.yellow)
        
        VStack(alignment: .leading) {
          Text("Vehicle Charging")
            .font(.headline)
          Text("\(Int(context.state.chargeInfo.percent))% Charged")
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        Spacer()
        // İlerleme çubuğu
        Gauge(value: context.state.chargeInfo.percent, in: 0...100) {
          Text("")
        }
        .gaugeStyle(.accessoryCircularCapacity)
        .tint(.green)
      }
      .padding()
      .activityBackgroundTint(Color.white.opacity(0.2))
      .activitySystemActionForegroundColor(Color.white)
      
    } dynamicIsland: { context in
      DynamicIsland { 
        // MARK: - Expanded UI (Ada genişlediğinde)
        // Burası kullanıcı adaya uzun bastığında açılan yerdir.
        
        // 1. Üst Sol (Leading) - Genellikle ikon veya başlık
        DynamicIslandExpandedRegion(.leading) {
          HStack {
            Image(systemName: "bolt.fill")
              .foregroundStyle(.yellow)
            Text("Charging")
              .font(.caption)
              .bold()
          }
        }
        
        // 2. Üst Sağ (Trailing) - Genellikle süre veya ikincil bilgi
        DynamicIslandExpandedRegion(.trailing) {
          Text("\(Int(context.state.chargeInfo.chargeRate)) kW")
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        
        // 3. Alt Kısım (Bottom) - Ana içerik buraya gelir
        // Sizin yazdığınız ExpandedUI yapısını burada kullanıyoruz!
        DynamicIslandExpandedRegion(.bottom) {
          ExpandedUI(
            percent: context.state.chargeInfo.percent,
            recordID: context.attributes.recordID,
            isLockScreenView: false
          )
        }
        
      } compactLeading: {
        // MARK: - Compact Leading (Kapalı Ada Sol)
        HStack {
          Image(systemName: "bolt.fill")
          .foregroundStyle(.yellow)
          .padding(.leading, 4)
          Text("Charging")
            .font(.caption)
            .bold()
            .foregroundStyle(.white)
        }
        
      } compactTrailing: {
        // MARK: - Compact Trailing (Kapalı Ada Sağ)
        Text("\(Int(context.state.chargeInfo.percent))%")
          .foregroundStyle(.green)
          .padding(.trailing, 4)
        
      } minimal: {
        // MARK: - Minimal (Çoklu aktivite varsa görünen küçük ikon)
        Image(systemName: "bolt.circle.fill")
          .foregroundStyle(.green)
      }
      .widgetURL(URL(string: "tracker://open")) // Uygulamayı açmak için deeplink
      .keylineTint(Color.yellow) // Ada etrafındaki ince çizgi rengi
    }
  }
}

// MARK: - Previews & Mock Data

extension TrackerAttributes {
    fileprivate static var preview: TrackerAttributes {
        TrackerAttributes(recordID: 123, authToken: "mock-token")
    }
}

extension TrackerAttributes.ContentState {
    fileprivate static var charging: TrackerAttributes.ContentState {
        let chargeInfo = TrackerAttributes.ContentState.ChargeInfo(
            percent: 65.0,
            chargeRate: 22.0,
            amount: 15.5
        )
        return TrackerAttributes.ContentState(chargeInfo: chargeInfo)
    }
}

// Canvas üzerinde Dynamic Island'ı görmek için bu preview'ı kullanın
#Preview("Dynamic Island Compact", as: .dynamicIsland(.compact), using: TrackerAttributes.preview) {
    TrackerLiveActivity()
} contentStates: {
    TrackerAttributes.ContentState.charging
}

#Preview("Dynamic Island Expanded", as: .dynamicIsland(.expanded), using: TrackerAttributes.preview) {
    TrackerLiveActivity()
} contentStates: {
    TrackerAttributes.ContentState.charging
}

#Preview("Lock Screen", as: .content, using: TrackerAttributes.preview) {
    TrackerLiveActivity()
} contentStates: {
    TrackerAttributes.ContentState.charging
}

/*extension TrackerAttributes {
 fileprivate static var preview: TrackerAttributes {
 TrackerAttributes(name: "World")
 }
 }
 
 extension TrackerAttributes.ContentState {
 fileprivate static var smiley: TrackerAttributes.ContentState {
 TrackerAttributes.ContentState(emoji: "😀")
 }
 
 fileprivate static var starEyes: TrackerAttributes.ContentState {
 TrackerAttributes.ContentState(emoji: "🤩")
 }
 }
 
 #Preview("Notification", as: .content, using: TrackerAttributes.preview) {
 TrackerLiveActivity()
 } contentStates: {
 TrackerAttributes.ContentState.smiley
 TrackerAttributes.ContentState.starEyes
 }
 */

