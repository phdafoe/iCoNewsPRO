//
//  BusinessView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import SwiftUI

struct BusinessView: View {
    
    @StateObject var viewModel = BusinessPresenter()
    @State private var presentModal = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ForEach(self.viewModel.arrayItems) { item in
                    headerBusinessPageView(item: item)
                        .loader(state: .ok)
                }
            }
            .navigationTitle(Text("Business - NYT"))
            .onAppear {
                self.viewModel.fetchData()
            }
        }
    }
    
    @ViewBuilder
    func headerBusinessPageView(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 20){
            Divider()
            Text(item.title ?? "")
                .font(.largeTitle)
            
            Text(item.pubDate ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(item.itemDescription ?? "")
                .font(.title3)
            
            contentBusinessPageView(item: item)
        }.padding(EdgeInsets(top: 2, leading: 5, bottom: 5, trailing: 2))
    }
    
    @ViewBuilder
    func contentBusinessPageView(item: Item) -> some View{
        
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
                } label: {
                    Image(systemName: "network")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .sheet(isPresented: self.$presentModal, content: {
                    SafariView(url: URL(string: item.link ?? "")!)
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

struct BusinessView_Previews: PreviewProvider {
    static var previews: some View {
        BusinessView()
    }
}
