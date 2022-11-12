//
//  HomeView.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/11/22.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTabItem){
            ForEach(viewModel.tabItemViewModels, id: \.self) { item in
                tabView(for: item.type)
                    .tabItem {
                        Image(systemName: item.imageName)
                        Text(item.title)
                    }
                    .tag(item.type)
            }
        }
        .accentColor(.yellow)
        .environment(\.colorScheme, .dark)
    }
    
    
    @ViewBuilder
    func tabView(for tabItemType: TabItemViewModel.TabItemType) -> some View {
        switch tabItemType{
        case .homePage:
            HomePageView()
        case .arts:
            ArtsView()
        case .business:
            ContentView()
        case .movies:
            ContentView()
        case .technology:
            ContentView()
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
