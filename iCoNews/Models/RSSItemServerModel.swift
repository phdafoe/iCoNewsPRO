//
//  RSSItemServerModel.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 2/11/22.
//

import Foundation


// MARK: - ResponseCalendarServerModel
struct RSSServerModel: Codable {
    let rss: RSS?

    enum CodingKeys: String, CodingKey {
        case rss = "rss"
    }
}

// MARK: - RSS
struct RSS: Codable {
    let channel: Channel?

    enum CodingKeys: String, CodingKey {
        case channel = "channel"
    }
}

// MARK: - Channel
struct Channel: Codable {
    let title: String?
    let link: [String]?
    let channelDescription: String?
    let language: String?
    let copyright: String?
    let lastBuildDate: String?
    let pubDate: String?
    let image: ImageRss?
    let item: [Item]?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case channelDescription = "description"
        case language = "language"
        case copyright = "copyright"
        case lastBuildDate = "lastBuildDate"
        case pubDate = "pubDate"
        case image = "image"
        case item = "item"
    }
}

// MARK: - Image
struct ImageRss: Codable {
    let title: String?
    let url: String?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case url = "url"
        case link = "link"
    }
}

// MARK: - Item
struct Item: Codable, Identifiable {
    var id = UUID()
    let title: String?
    let link: String?
    let guid: String?
    let itemDescription: String?
    let creator: String?
    let pubDate: String?
    let category: [String]?
    let content: String?
    let credit: String?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case link = "link"
        case guid = "guid"
        case itemDescription = "description"
        case creator = "creator"
        case pubDate = "pubDate"
        case category = "category"
        case content = "content"
        case credit = "credit"
    }
}


class FeedParser: NSObject {
    
    private var rssItems: [Item] = []
    private var currentElement = ""
    private var currentLink = "" {
        didSet{
            currentLink = currentLink.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCredit = "" {
        didSet{
            currentCredit = currentCredit.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentCreator = "" {
        didSet{
            currentCreator = currentCreator.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentTitle = "" {
        didSet{
            currentTitle = currentTitle.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentDescription = ""{
        didSet{
            currentDescription = currentDescription.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var currentPubDate = "" {
        didSet{
            currentPubDate = currentPubDate.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        }
    }
    private var parserCompletionHandler: (([Item]) -> Void)?
    
    func parseFeed(pUrl: String, completionHanndler: (([Item]) -> Void)?) {
        self.parserCompletionHandler = completionHanndler
        
        let request = URLRequest(url: URL(string: pUrl)!)
        let urlsession = URLSession.shared
        urlsession.dataTask(with: request) { data, response, error in
            guard let dataUnw = data else {
                if let errorUnw = error {
                    print(errorUnw.localizedDescription)
                }
                return
            }
            
            // Parser our xml data
            let parser = XMLParser(data: dataUnw)
            parser.delegate = self
            parser.parse()
        }.resume()
        
    }
}

extension FeedParser: XMLParserDelegate {
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        
        self.currentElement = elementName
        if self.currentElement == "item" {
            self.currentTitle = ""
            self.currentDescription = ""
            self.currentPubDate = ""
            self.currentCreator = ""
            self.currentCredit = ""
            self.currentLink = ""
        }
    }
    
    func parser(_ parser: XMLParser,
                foundCharacters string: String) {
        switch currentElement {
        case "title": currentTitle += string
        case "description": currentDescription += string
        case "pubDate": currentPubDate += string
        case "dc:creator": currentCreator += string
        case "media:credit": currentCredit += string
        case "link": currentLink += string
        default: break
        }
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        if elementName == "item" {
            let rssItemObject = Item(title: self.currentTitle,
                                     link: self.currentLink,
                                     guid: nil,
                                     itemDescription: self.currentDescription,
                                     creator: self.currentCreator,
                                     pubDate: self.currentPubDate,
                                     category: nil,
                                     content: nil,
                                     credit: self.currentCredit)
            
            self.rssItems.append(rssItemObject)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.parserCompletionHandler?(self.rssItems)
    }
    
    func parser(_ parser: XMLParser,
                parseErrorOccurred parseError: Error) {
        
        print(parseError.localizedDescription)
    }
    
}
