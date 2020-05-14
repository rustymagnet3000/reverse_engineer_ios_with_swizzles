import Foundation

class YDTimeHelper {
    var readable_date: String
    var epoch_time: Int
    
    convenience init(raw_date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "EEEE H:mm:ss"
        let easy_date = formatter.string(from: raw_date)
        let easy_epoch = Int(raw_date.timeIntervalSince1970 * 1000)
        self.init(readable_date: easy_date, epoch_time: easy_epoch)
    }
    
    init(readable_date: String, epoch_time: Int) {
        self.readable_date = readable_date
        self.epoch_time = epoch_time
    }
    
    static func start_minus_finish_epoch(start_time_epoch: Int, end_time_epoch: Int) -> String {
        
        let time_taken: Double = Double(end_time_epoch - start_time_epoch)
    
        
        return "🔥 ⏰ " + String(time_taken / 1000) + " Time taken"
    }
}
