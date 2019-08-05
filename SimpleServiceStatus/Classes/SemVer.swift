import Foundation

public struct SemVer {
    private(set) var isValid = false
    private(set) var major: String?
    private(set) var minor: String?
    private(set) var patch: String?
    
    public init(versionString: String) {
        let range = NSRange(location: 0, length: versionString.count)
        guard let regex = try? NSRegularExpression(pattern: "^([0-9]+)(?:\\.([0-9]+)(?:\\.([0-9]+))?)?"),
            let match = regex.matches(in: versionString, options: [], range: range).first else {
                return
        }
        
        isValid = true
        major = versionString.substring(with: match.range(at: 1))
        minor = versionString.substring(with: match.range(at: 2))
        patch = versionString.substring(with: match.range(at: 3))
    }
    
    /// Normalized version string in MAJOR.MINOR.PATCH format of [SemVer](http://semver.org/).
    /// 8 -> 8.0.0
    /// 8.4 -> 8.4.0
    /// 8.4.2_rc1 -> 8.4.2
    /// a.b.c (invalid) -> *
    /// NOTE : this takes valid part only at the beginning (if exists), for example
    /// 1.*.2 -> 1.0.0
    /// *.1.2 -> *
    /// 1.2.* -> 1.2.0
    public var normalizedString: String {
        if isValid {
            return "\(major ?? "0").\(minor ?? "0").\(patch ?? "0")"
        } else {
            return "*"
        }
    }
}

private extension String {
    func substring(with nsRange: NSRange) -> String? {
        let startIndex = utf16.startIndex
        let endIndex = utf8.endIndex
        guard let from16 = utf16.index(startIndex, offsetBy: nsRange.location, limitedBy: endIndex),
            let to16 = utf16.index(startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self) else {
                return nil
        }
        return String(self[from..<to])
    }
}
