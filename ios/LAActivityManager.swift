import Foundation
import ActivityKit

@objcMembers
class LAActivityManager: NSObject {

    @available(iOS 18.6, *)
    static func startTestActivity() {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("❌ Live Activities disabled")
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
            let activity = try Activity<TrackerAttributes>.request(
                attributes: attributes,
                contentState: contentState,
                pushType: nil
            )
            print("✅ Live Activity started with id:", activity.id)
        } catch {
            print("❌ Error requesting Live Activity:", error.localizedDescription)
        }
    }
}
