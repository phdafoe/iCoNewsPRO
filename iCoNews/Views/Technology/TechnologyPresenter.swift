//
//  TechnologyPresenter.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import Foundation


class TechnologyPresenter: ObservableObject {
    
    @Published var arrayItems: [Item] = []
    
    func fetchData () {
        let feedParser = FeedParser()
        self.arrayItems.removeAll()
        feedParser.parseFeed(pUrl: "https://api.nytimes.com/services/xml/rss/nyt/Technology.xml") { items in
            DispatchQueue.main.async {
                self.arrayItems = items
            }
            
        }
    }
}
