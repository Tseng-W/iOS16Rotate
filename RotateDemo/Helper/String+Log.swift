//
//  String+Log.swift
//  RotateDemo
//
//  Created by 曾問 on 2022/9/3.
//

import Foundation

func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
    print("\(file) \(function) \(line): \(message)")
}

func debug<K, V>(root: K, _ keyPath: KeyPath<K, V>, file: String = #file, function: String = #function, line: Int = #line) {
    print("\(file) \(function) \(line): \(K.self) \(root[keyPath: keyPath])")
}
