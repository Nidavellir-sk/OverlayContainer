public class WeakOverlayScrollView<T: AnyObject>: Equatable {
    public weak var value: T?
    
    public init(_ value: T?) {
        self.value = value
    }
    
    public static func == (lhs: WeakOverlayScrollView<T>, rhs: WeakOverlayScrollView<T>) -> Bool {
        return lhs.value === rhs.value
    }
}
