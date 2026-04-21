//
//  NumUtil.swift
//  zswing
//
//  Created by GH w on 3/17/26.
//

import Foundation
import AdapterSwift

extension CGFloat {
  var webPx: CGFloat {
      return self.adapter
  }

  var xAbs: CGFloat {
    return self.isNaN ? 0 : self.magnitude
  }
}

extension Double {
  var webPx: CGFloat {
      return self.adapter
  }

  var priceFormatString: String {
      if self.truncatingRemainder(dividingBy: 1) == 0{
          return String(format: "%.0f", self)
      }
    return String(format: "%.2f", self)
  }
    
    func secondsDelayFn(_ fn:@escaping ()->Void) {
        DispatchQueue.main.asyncAfter(deadline: .now()+self, execute: {
            fn()
        })
    }
}

extension Int {
  var webPx: CGFloat {
      return CGFloat(self.adapter)
  }
    
  func defMinValue(_ n: Int) -> Int {
      return n > self ? n : self
  }
    
  func defMaxValue(_ n: Int) -> Int {
      return n < self ? n : self
  }
}


extension Int32 {

  func defMinValue(_ n: Int32) -> Int32 {
      return n > self ? n : self
  }
    
    func defMaxValue(_ n: Int32) -> Int32 {
        return n < self ? n : self
    }
    
  var isPayMethodHours:Bool {
        return self == 4001
    }
}

extension Int {
    var strValue: String {
        return String(self)
    }
    
    var playCountFormatedStr: String {
        if self < 10000 {
            return String(self)
        } else {
            let count = Double(self) / 10000.0
            return String(format: "%.1f万", count)
        }
    }
}

extension Int64 {
  var strValue: String {
    return String(self)
  }

  var playCountFormatedStr: String {
    if self < 10000 {
      return String(self)
    } else {
      let count = Double(self) / 10000.0
      return String(format: "%.1f万", count)
    }
  }

  /// 格式化为 yyyy-MM-dd HH:mm:ss
  var dateString: String {
    let date = Date(timeIntervalSince1970: TimeInterval(self) / 1000.0)
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.string(from: date)
  }
}

extension Date {
    var dateFormatStr:String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
        let dateStr = formatter.string(from: self)
        return dateStr
    }
}

extension Int32 {
  var strValue: String {
    return String(self)
  }

  var playCountFormatedStr: String {
    if self < 10000 {
      return String(self)
    } else {
      let count = Double(self) / 10000.0
      return String(format: "%.1f万", count)
    }
  }
}

extension String {
  var int64Value: Int64? {
    guard let value = Int64(self) else {
      return nil
    }
    return value
  }
 
  var int32Value: Int32? {
    guard let value = Int32(self) else {
      return nil
    }
    return value
  }
    
    var isTextEmpty:Bool {
        return self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    var isNotBlank:Bool {
        return !self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var priceFormatString:String {
        guard let value = Double(self) else {
            return 0.priceFormatString
        }
        return value.priceFormatString
    }
    
    var priceValue:Double {
        guard let value = Double(self) else {
            return 0.0
        }
        return value
    }
}


extension UUID {
    init(fromInt64 value: Int64) {
        // Create a 16-byte array (128 bits) initialized to 0
        var bytes = [UInt8](repeating: 0, count: 16)
        
        // Convert Int64 to Big Endian bytes to ensure consistency across platforms
        let bigEndianValue = value.bigEndian
        
        // Copy the 8 bytes of the Int64 into the last 8 slots of our byte array
        withUnsafeBytes(of: bigEndianValue) { buffer in
            for i in 0..<8 {
                bytes[i + 8] = buffer[i]
            }
        }
        
        // Initialize the UUID using the byte tuple
        let tuple = (
            bytes[0], bytes[1], bytes[2], bytes[3],
            bytes[4], bytes[5], bytes[6], bytes[7],
            bytes[8], bytes[9], bytes[10], bytes[11],
            bytes[12], bytes[13], bytes[14], bytes[15]
        )
        
        self.init(uuid: tuple)
    }
}
