//
//  ContentView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 2/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    
    var body: some View {
        
            ScrollView{
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(self.viewModel.arrayItems) { item in
                        Text(item.title ?? "")
                            .font(.title3)
                            .foregroundColor(.black)
                        
                        Text(item.pubDate ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(item.itemDescription ?? "")
                            .font(.subheadline)
                            .foregroundColor(.black)
                        
                        HStack{
                            Spacer()
                            VStack(alignment: .leading, spacing: 5){
                                Text("Credit:")
                                Text(item.credit ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Autor:")
                                Text(item.creator ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("Link:")
                                Text(item.link ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            
                        }.padding(.trailing, 2)
                    }
                }.padding(EdgeInsets(top: 2, leading: 5, bottom: 5, trailing: 2))
            }
        
        .onAppear {
            self.viewModel.fetchData()
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

class ContentViewModel: ObservableObject {
    
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
