public class Weak<T: AnyObject>: Equatable {
    weak var value: T?
    
    public init(_ value: T?) {
        self.value = value
    }
    
    public static func == (lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.value === rhs.value
    }
}
