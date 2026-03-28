//
//  NumUtil.swift
//  CompoApp
//
//  Created by GH w on 3/28/26.
//

import Foundation
import AdapterSwift

extension Int {
    var webPx:CGFloat {
        CGFloat(self.adapter)
    }
}

extension Double {
    var webPx:CGFloat {
        CGFloat(self.adapter)
    }
}
