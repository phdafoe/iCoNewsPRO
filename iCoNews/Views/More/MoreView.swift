//
//  MoreView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import SwiftUI

struct MoreView: View {
    
    @State private var isWorldPresented = false
    @State private var isSportsPresented = false
    
    var body: some View {
        Form{
            Section("Recommendations"){
                Button(action: {
                    self.isWorldPresented.toggle()
                }) {
                    Text("World news - NYT")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
                .font(.title3)
                .fullScreenCover(isPresented: self.$isWorldPresented) {
                    WorldView()
                }
                
                Button(action: {
                    self.isSportsPresented.toggle()
                }) {
                    Text("Sports news - NYT")
                        .font(.headline)
                        .foregroundColor(.yellow)
                }
                .font(.title3)
                .fullScreenCover(isPresented: self.$isSportsPresented) {
                    ContentView()
                }
            }
        }
    }
}

struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}
