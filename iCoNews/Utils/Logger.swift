//
//  Logger.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation

enum LogTag {
    case error
    case warning
    case info
    case debug
    case verbose
    
    var label: String {
        switch self {
        case .error   : return "🔴 ERROR"
        case .warning : return "🟡 WARNING"
        case .info    : return "🔵 INFO"
        case .debug   : return "🟢 DEBUG"
        case .verbose : return "🟣 VERBOSE"
        }
    }
}

func appLog(tag: LogTag = .debug, _ items: Any...,
            file: String = #file,
            function: String = #function,
            line: Int = #line ,
            separator: String = " ") {
    #if DEBUG
    let date = Date()
    let df = DateFormatter()
    df.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let dateString = df.string(from: date)
    
    let shortFileName = file.components(separatedBy: "/").last ?? "---"
    
    let output = items.map {
        if let itm = $0 as? CustomStringConvertible {
            return "\(itm.description)"
        } else {
            return "\($0)"
        }
    }.joined(separator: separator)
    
    print("")
    var msg = ""
    switch tag {
    case .verbose:
        msg = "\(dateString) \(tag.label) \(shortFileName) - \(function) - line \(line)"
        if !output.isEmpty { msg += "\n\(output)" }
    default:
        msg = "\(dateString) \(tag.label)"
        if !output.isEmpty { msg += ": \(output)" }
    }
    
    print(msg)
    print("")
    #endif
}

