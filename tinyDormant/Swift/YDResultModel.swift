import Foundation

class YDResultModel {
    var successCounter: Int = 0
    var failCounter: Int = 0
    var startTimeEpoch: Int
    var endTimeEpoch: Int = 0
    var totalTimeTaken: Double = 0.0
    
    init() {
        let startTime = YDTimeHelper(raw_date: Date())
        self.startTimeEpoch = startTime.epoch_time
    }
    
    private func timeTakenCalculation() {
        self.endTimeEpoch = YDTimeHelper(raw_date: Date()).epoch_time
        totalTimeTaken = Double(endTimeEpoch - startTimeEpoch)
        totalTimeTaken = totalTimeTaken / 1000
    }
}
