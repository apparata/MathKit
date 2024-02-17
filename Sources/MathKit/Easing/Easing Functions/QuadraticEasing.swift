//
//  Copyright © 2022 Bontouch AB. All rights reserved.
//

import Foundation

// MARK: - Quadratic Ease-In

/// Quadratic (power of 2) ease-in function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quadraticEaseIn<T: BinaryFloatingPoint>(_ t: T) -> T {
    return t * t
}

// MARK: - Quadratic Ease-Out

/// Quadratic (power of 2) ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quadraticEaseOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    return -(t * (t - 2))
}

// MARK: - Quadratic Ease-In-Ease-Out

/// Quadratic (power of 2) ease-in-ease-out function.
///
/// - Parameter t: A progress parameter, typically in the closed range 0...1
///
/// - Returns: The progress value with the easing formula applied to it.
///
public func quadraticEaseInOut<T: BinaryFloatingPoint>(_ t: T) -> T {
    if t < (1 / 2) {
        return 2 * t * t
    } else {
        return (-2 * t * t) + (4 * t) - 1
    }
}
