//
//  HomePageView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import SwiftUI

struct HomePageView: View {
    
    @StateObject var viewModel = HomePagePresenter()
    @State private var presentModal = false
    @State private var selectedLink: Item?
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(self.viewModel.arrayItems) { item in
                    headerHomePageView(item: item)
                        .loader(state: .ok)
                }
            }
            .navigationTitle(Text("Home Page - NYT"))
            .onAppear {
                self.viewModel.fetchData()
            }
        }
    }
    
    @ViewBuilder
    func headerHomePageView(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 20){
            Divider()
            Text(item.title ?? "")
                .font(.largeTitle)
            
            Text(item.pubDate ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(item.itemDescription ?? "")
                .font(.title3)
            
            contentHomePageView(item: item)
        }.padding(EdgeInsets(top: 2, leading: 5, bottom: 5, trailing: 2))
    }
    
    @ViewBuilder
    func contentHomePageView(item: Item) -> some View{
        
        HStack(alignment: .bottom) {
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
                Text("More Info:")
                    .foregroundColor(.black)
                    .bold()
                Button() {
                    self.presentModal.toggle()
                    self.selectedLink = item
                } label: {
                    Image(systemName: "network")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .sheet(item: self.$selectedLink, content: { link in
                    SafariView(url: URL(string: link.link ?? "")!)
                })
            }
            .padding()
            Spacer()
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .padding(.trailing)
    }
}

struct HomePageView_Previews: PreviewProvider {
    static var previews: some View {
        HomePageView()
    }
}
