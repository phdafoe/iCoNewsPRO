//
//  WorldView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import SwiftUI

struct WorldView: View {
    
    @SwiftUI.Environment(\.presentationMode) var presenterMode
    @StateObject var viewModel = WorldPresenter()
    @State private var presentModal = false
    
    var body: some View {
        NavigationStack{
            ScrollView {
                ZStack(alignment: .topLeading) {
                    headerView
                }
                
                ForEach(self.viewModel.arrayItems) { item in
                    worldPageView(item: item)
                        .loader(state: .ok)
                }
            }
            //.navigationTitle(Text("World - NYT"))
            .onAppear {
                self.viewModel.fetchData()
            }
        }
    }
    
    var headerView: some View {
        HStack{
            Button(action: {
                self.presenterMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.down")
            }
            .padding()
            .background(Color.black.opacity(0.7))
            .clipShape(Circle())
            .padding(EdgeInsets(top: 40,
                                leading: 20,
                                bottom: 0,
                                trailing: 0))
            Spacer()
            
        }
        .foregroundColor(.red)
    }
    
    @ViewBuilder
    func worldPageView(item: Item) -> some View {
        VStack(alignment: .leading, spacing: 20){
            Divider()
            Text(item.title ?? "")
                .font(.largeTitle)
            
            Text(item.pubDate ?? "")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text(item.itemDescription ?? "")
                .font(.title3)
            
            contentWorldPageView(item: item)
        }.padding(EdgeInsets(top: 2, leading: 5, bottom: 5, trailing: 2))
    }
    
    @ViewBuilder
    func contentWorldPageView(item: Item) -> some View{
        
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 5){
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

struct WorldView_Previews: PreviewProvider {
    static var previews: some View {
        WorldView()
    }
}
