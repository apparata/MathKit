//
//  Copyright © 2022 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Quartic Ease-In

/// Quartic (power of 4) ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quarticEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    return t * t * t * t
}

// MARK: - Quartic Ease-Out

/// Quartic (power of 4) ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quarticEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    let f = t - 1
    return f * f * f * (1 - t) + 1
}

// MARK: - Quartic Ease-In-Ease-Out

/// Quartic (power of 4) ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quarticEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    if t < (1 / 2) {
        return 8 * t * t * t * t
    } else {
        let f = (t - 1)
        return -8 * f * f * f * f + 1
    }
}
