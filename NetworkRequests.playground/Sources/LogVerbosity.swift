import Foundation

public enum LogVerbosity: Int, Comparable {
    case off = 0
    case info = 1
    case debug = 2

    public static func < (lhs: LogVerbosity, rhs: LogVerbosity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
