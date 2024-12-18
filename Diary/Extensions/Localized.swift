import Foundation

extension String {

    /// Localize string key
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }

    /// Localize plural string key
    func localized<T>(_ count: T) -> String? {
        guard let cVarArg = count as? CVarArg else { return nil }
        return String.localizedStringWithFormat(localized(), cVarArg)
    }

    /// Localize format string key
    func localized(arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
}
