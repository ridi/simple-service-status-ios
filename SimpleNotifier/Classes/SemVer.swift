//
//  SemVer.swift
//  Ridibooks
//
//  Created by kgwangrae on 2017. 3. 30..
//  Copyright © 2017년 Ridibooks. All rights reserved.
//

public struct SemVer {
    private(set) var isValid = false
    private(set) var major: String?
    private(set) var minor: String?
    private(set) var patch: String?
    
    public init(versionString: String) {
        guard let regex = try? NSRegularExpression(pattern: "^([0-9]+)(?:\\.([0-9]+)(?:\\.([0-9]+))?)?"),
            let match = regex.matches(in: versionString, options: [], range: NSRange(location: 0, length: versionString.characters.count)).first else {
                return
        }
        
        isValid = true
        major = versionString.substring(with: match.rangeAt(1))
        minor = versionString.substring(with: match.rangeAt(2))
        patch = versionString.substring(with: match.rangeAt(3))
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
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location, limitedBy: utf16.endIndex),
            let to16 = utf16.index(utf16.startIndex, offsetBy: nsRange.location + nsRange.length, limitedBy: utf16.endIndex),
            let from = from16.samePosition(in: self),
            let to = to16.samePosition(in: self) else {
                return nil
        }
        return self.substring(with: from ..< to)
    }
}
