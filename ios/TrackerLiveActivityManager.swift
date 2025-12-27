import Foundation
import ActivityKit

@available(iOS 16.1, *)
@objc(TrackerLiveActivityManager)
class TrackerLiveActivityManager: NSObject {
    static func startTestActivity() {
        // Live Activities sistemde açık mı?
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities disabled")
            return
        }

        let attributes = TrackerAttributes(
            recordID: 1,
            authToken: "bearer"
        )

        let chargeInfo = TrackerAttributes.ContentState.ChargeInfo(
            percent: 42.5,
            chargeRate: 20,
            amount: 30
        )

        let contentState = TrackerAttributes.ContentState(chargeInfo: chargeInfo)

        do {
            let content = ActivityContent(state: contentState, staleDate: nil)
            let activity = try Activity<TrackerAttributes>.request(
                attributes: attributes,
                content: content,
                pushType: nil // şimdilik push yok
            )
            print("✅ Live Activity started, id:", activity.id)
        } catch {
            print("❌ Error requesting Live Activity:", error)
        }
    }
}

