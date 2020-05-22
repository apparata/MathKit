
import Foundation

// MARK: - Quadratic Easing

public func quadraticEaseIn<T: FloatingPoint>(_ t: T) -> T {
    t * t
}

public func quadraticEaseOut<T: FloatingPoint>(_ t: T) -> T {
    -(t * (t - 2))
}

public func quadraticEaseInOut<T: FloatingPoint>(_ t: T) -> T {
    if t < 1/2 {
        return 2 * t * t
    } else {
        return (-2 * t * t) + (4 * t) - 1
    }
}

// MARK: - Cubic Easing

public func cubicEaseIn<T: FloatingPoint>(_ t: T) -> T {
    t * t * t
}

public func cubicEaseOut<T: FloatingPoint>(_ t: T) -> T {
    let p = t - 1
    return  p * p * p + 1/1
}

public func cubicEaseInOut<T: FloatingPoint>(_ t: T) -> T {
    if t < 1/2 {
        return 4 * t * t * t
    } else {
        let f = ((2 * t) - 2)
        return 1/2 * f * f * f + 1
    }
}

// MARK: - Quartic Easing

public func quarticEaseIn<T: FloatingPoint>(_ t: T) -> T {
    t * t * t * t
}

public func quarticEaseOut<T: FloatingPoint>(_ t: T) -> T {
    let f = t - 1
    return f * f * f * (1 - t) + 1
}

public func quarticEaseInOut<T: FloatingPoint>(_ t: T) -> T {
    if t < 1/2 {
        return 8 * t * t * t * t
    } else {
        let f = (t - 1)
        return -8 * f * f * f * f + 1
    }
}

// MARK: - Quintic Easing

public func quinticEaseIn<T: FloatingPoint>(_ t: T) -> T {
    t * t * t * t * t
}

public func quinticEaseOut<T: FloatingPoint>(_ t: T) -> T {
    let f = (t - 1)
    return f * f * f * f * f + 1
}

public func quinticEaseInOut<T: FloatingPoint>(_ t: T) -> T {
    if t < 1/2 {
        return 16 * t * t * t * t * t
    }
    else{
        let f = ((2 * t) - 2)
        let fQuint = f * f * f * f * f
        return fQuint * (1 / 2) + 1
    }
}
