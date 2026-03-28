//
//  SpUtil.swift
//  CompoApp
//
//  Created by GH w on 3/28/26.
//

import UIKit
public struct Verticaldapter {
    nonisolated(unsafe) public static var share = Verticaldapter()
    public var base: Double = 834
    public var mode: AdapterMode = .height
    
    public enum AdapterMode {
        case width, height
    }
    
    fileprivate func currentScale() -> Double {
        let screen = UIScreen.main.bounds.size
        switch mode {
        case .width:
            return screen.width / base
        case .height:
            return screen.height / base
        }
    }
}

public protocol Verticaldapterable {
    associatedtype VerticaldapterType
    var verticaldapter: VerticaldapterType { get }
}

extension Verticaldapterable {
    func vdapterScale() -> Double {
        true ? 1 : Verticaldapter.share.currentScale()
    }
}

// MARK: - 数值类型
extension Int: Verticaldapterable {
    public var verticaldapter: Int {
        Int((Double(self) * vdapterScale()))
    }
}
extension CGFloat: Verticaldapterable {
    public var verticaldapter: CGFloat {
        self * vdapterScale()
    }
}
extension Double: Verticaldapterable {
    public var verticaldapter: Double {
        self * vdapterScale()
    }
}
