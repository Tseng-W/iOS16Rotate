//
//  NSObject+Extensions.swift
//  RotateDemo
//
//  Created by 曾問 on 2022/9/3.
//

import Foundation

extension NSObject {
    static func create<T>(_ factory: (T) -> Void) -> T where T: NSObject {
        let t: T = .init()
        factory(t)
        return t
    }
}
