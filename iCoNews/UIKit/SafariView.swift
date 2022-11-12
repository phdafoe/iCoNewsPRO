//
//  SafariView.swift
//  AppCiceMovies
//
//  Created by Andres Felipe Ocampo Eljaiek on 6/11/21.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    
    let url: URL
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
    
    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariVC = SFSafariViewController(url: url)
        URLCache.shared.removeAllCachedResponses()
        if let cookies = HTTPCookieStorage.shared.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
        return safariVC
    }
}
