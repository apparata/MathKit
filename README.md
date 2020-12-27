
# MathKit

## License

See the LICENSE file for licensing information.

## Table of Contents

- [Misc](#misc)
    - [`clamp(...)`](#clamp)
    - [`lerp(...)`](#lerp)
    - [`MovingAverage`](#movingaverage)
    - [`Noise`](#noise)
- [Custom Operators](#custom-operators)
    - [Degrees to Radians Operator](#degrees-to-radians-operator)
    - [Percent Operator](#percent-operator)
- [Easing Functions](#easing-functions)
    - [Quadratic Easing](#quadratic-easing)
    - [Cubic Easing](#cubic-easing)
    - [Quartic Easing](#quartic-easing)
    - [Quintic Easing](#quintic-easing)


## Misc

### `clamp(...)`

Clamps the value to the min...max range.

#### Signature

```swift
func clamp<T: Comparable> (_ value: T, min: T, max: T) -> T
```

#### Example

```swift
clamp(3.3, min: 2.0, max: 5.0)
```

### `lerp(...)`

Linear interpolation.

#### Signatures

```swift
func lerp(_ a: Float, _ b: Float, _ t: Float) -> Float
func lerp(_ a: CGFloat, _ b: CGFloat, _ t: CGFloat) -> CGFloat
func lerp(_ a: Double, _ b: Double, _ t: Double) -> Double
func lerp<T: SIMD>(_ a: T, _ b: T, _ t: T.Scalar) -> T
    where T.Scalar: FloatingPoint
```

### `MovingAverage`

Struct that calculates average of the last N accumulated values.

### `Noise`

Visually axis-decorrelated coherent noise algorithm based on the Simplectic honeycomb.

## Custom Operators

### Degrees to Radians Operator

Postfix degrees-to-radian operator named `°`

#### Example

```swift
let angleInRadians: Float = 90°
```

### Percent Operator

Postfix percent operator named `%`

#### Example

```swift
/// The quarter variable is assigned the value 0.25
let quarter: Float = 25%
```

## Easing

### Quadratic Easing

#### Signatures

```swift
func quadraticEaseIn<T: FloatingPoint>(_ t: T) -> T
func quadraticEaseOut<T: FloatingPoint>(_ t: T) -> T
func quadraticEaseInOut<T: FloatingPoint>(_ t: T) -> T
```

### Cubic Easing

#### Signatures

```swift
func cubicEaseIn<T: FloatingPoint>(_ t: T) -> T
func cubicEaseOut<T: FloatingPoint>(_ t: T) -> T
func cubicEaseInOut<T: FloatingPoint>(_ t: T) -> T
```

### Quartic Easing

#### Signatures

```swift
public func quarticEaseIn<T: FloatingPoint>(_ t: T) -> T
func quarticEaseOut<T: FloatingPoint>(_ t: T) -> T
func quarticEaseInOut<T: FloatingPoint>(_ t: T) -> T
```

### Quintic Easing

#### Signatures

```swift
func quinticEaseIn<T: FloatingPoint>(_ t: T) -> T
func quinticEaseOut<T: FloatingPoint>(_ t: T) -> T
func quinticEaseInOut<T: FloatingPoint>(_ t: T) -> T
```
