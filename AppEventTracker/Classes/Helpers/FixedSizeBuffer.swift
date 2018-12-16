//
//  FixedSizeBuffer.swift
//  AppEventTracker
//
//  Created by Ioannis Diamantidis on 12/16/18.
//

import Foundation

/// A fixed size buffer, implemented with an array and a writeIndex.
public struct FixedSizeBuffer<T> {

    /// Shorted list using the position of the "write" index.
    public var list: [T?] {
        return Array(array[writeIndex..<array.endIndex] + array[array.startIndex..<writeIndex])
    }

    /// Initialize a buffer with a fixed size.
    ///
    /// - Parameter count: The size of the buffer
    public init(count: Int) {
        array = [T?](repeating: nil, count: count)
    }

    public mutating func push(_ element: T) {
        defer {
            if writeIndex == array.count - 1 {
                writeIndex = 0
            } else {
                writeIndex += 1
            }
        }
        array[writeIndex] = element
    }

    private var array: [T?]
    private var writeIndex = 0
}
