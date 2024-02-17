import Foundation

/// Calculate average of the last N accumulated values.
public struct MovingAverage {
    
    /// The current average value. Nil until all slots are filled.
    public private(set) var value: Double? = nil

    private var values: [Double]
    private let count: Int
    private var nextSlot: Int = 0
    
    /// - parameter count: The size of the window of accumulated values.
    public init(count: Int) {
        self.count = count
        values = []
    }

    /// Add a new value, overwriting the least recently added value.
    public mutating func addValue(_ value: Double) {
        if values.count < count {
            values.append(value)
        } else {
            values[nextSlot] = value
            nextSlot += 1
            nextSlot = nextSlot % count
        }

        if values.count == count {
            self.value = values.reduce(0.0) { $0 + $1 } / Double(count)
        }
    }

    /// Clear the accumulated values.
    public mutating func clear() {
        values = []
        value = nil
        nextSlot = 0
    }
}
