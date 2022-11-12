//
//  BusinessPresenter.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import Foundation

class BusinessPresenter: ObservableObject {
    
    @Published var arrayItems: [Item] = []
    
    func fetchData () {
        let feedParser = FeedParser()
        self.arrayItems.removeAll()
        feedParser.parseFeed(pUrl: "https://rss.nytimes.com/services/xml/rss/nyt/Business.xml") { items in
            DispatchQueue.main.async {
                self.arrayItems = items
            }
            
        }
    }
}
