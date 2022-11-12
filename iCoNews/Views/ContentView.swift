//
//  ContentView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 2/11/22.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ContentViewModel()
    @State private var presentModal = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(self.viewModel.arrayItems) { item in
                        Divider()
                        Text(item.title ?? "")
                            .font(.largeTitle)
                        
                        Text(item.pubDate ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(item.itemDescription ?? "")
                            .font(.title3)
                        
                        contentHomeView(item: item)
                        
                    }
                }.padding(EdgeInsets(top: 2, leading: 5, bottom: 5, trailing: 2))
            }
            .navigationTitle(Text("Home Page"))
            .onAppear {
                self.viewModel.fetchData()
            }
        }
    }
    
    @ViewBuilder
    func contentHomeView(item: Item) -> some View{
        
        HStack(alignment: .bottom) {
            Spacer()
            VStack(alignment: .leading, spacing: 5){
                Text("Credit:")
                    .foregroundColor(.black)
                    .bold()
                    .padding(.top)
                Text(item.credit ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Autor:")
                    .foregroundColor(.black)
                    .bold()
                Text(item.creator ?? "")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text("Link:")
                    .foregroundColor(.black)
                    .bold()
                Button() {
                    self.presentModal.toggle()
                } label: {
                    Text(item.link ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: self.$presentModal, content: {
                    SafariView(url: URL(string: item.link ?? "")!)
                })
                .padding(.bottom)
            }
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.trailing)
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
        feedParser.parseFeed(pUrl: "https://api.nytimes.com/services/xml/rss/nyt/HomePage.xml") { items in
            DispatchQueue.main.async {
                self.arrayItems = items
            }
            
        }
    }
}
