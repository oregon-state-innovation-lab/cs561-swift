public class MyLibrary {
    /// The class's initializer.
    ///
    /// Whenever we call the `MyLibrary()` constructor to instantiate a `MyLibrary` instance,
    /// the runtime then calls this initializer.  The constructor returns after the initializer returns.
    public init() {}

    public func isLucky(_ number: Int) -> Bool {
        if number == 3 || number == 5 || number == 8 {
            return true
        }

        return false
    }
}
