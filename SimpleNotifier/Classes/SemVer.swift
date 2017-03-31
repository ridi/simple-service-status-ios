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
        let versionNSString = versionString as NSString
        
        let majorRange = match.rangeAt(1)
        if majorRange.location != NSNotFound {
            major = versionNSString.substring(with: majorRange)
        }
        
        let minorRange = match.rangeAt(2)
        if minorRange.location != NSNotFound {
            minor = versionNSString.substring(with: minorRange)
        }
        
        let patchRange = match.rangeAt(3)
        if patchRange.location != NSNotFound {
            patch = versionNSString.substring(with: patchRange)
        }
    }
    
    /// Normalized version string in MAJOR.MINOR.PATCH format of SemVer.
    /// 8 -> 8.0.0
    /// 8.4 -> 8.4.0
    /// 8.4.2_rc1 -> 8.4.2
    /// a.b.c (invalid) -> *
    public var normalizedString: String {
        if isValid {
            return "\(major ?? "0").\(minor ?? "0").\(patch ?? "0")"
        } else {
            return "*"
        }
    }
}
