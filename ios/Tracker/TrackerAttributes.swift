import Foundation
import ActivityKit
import WidgetKit

struct TrackerAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
      struct ChargeInfo: Codable, Hashable {
        let percent: Double
        let chargeRate: Double
        let amount: Double
      }
      let chargeInfo: ChargeInfo;
    }

    // Fixed non-changing properties about your activity go here!
    var recordID: Int;
    var authToken: String;
}
