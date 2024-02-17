//
//  Copyright © 2021 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Cubic Ease-In

/// Cubic (power of 3) ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func cubicEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    return t * t * t
}

// MARK: - Cubic Ease-Out

/// Cubic (power of 3) ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func cubicEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let p = t - 1
    return  p * p * p + 1
}

// MARK: - Cubic Ease-In-Ease-Out

/// Cubic (power of 3) ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func cubicEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    if t < (1 / 2) {
        return 4 * t * t * t
    } else {
        let f = ((2 * t) - 2)
        return (1 / 2) * f * f * f + 1
    }
}
