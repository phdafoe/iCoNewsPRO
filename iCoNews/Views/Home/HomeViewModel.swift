//
//  HomeViewModel.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/11/22.
//

import Foundation

final class HomeViewModel: ObservableObject {
    
    @Published var selectedTabItem: TabItemViewModel.TabItemType = .homePage
    
    let tabItemViewModels = [
        TabItemViewModel(imageName: "house.circle.fill", title: "HomePage", type: .homePage),
        TabItemViewModel(imageName: "photo.artframe", title: "Arts", type: .arts),
        TabItemViewModel(imageName: "bahtsign.circle", title: "Business", type: .business),
        TabItemViewModel(imageName: "tv.circle.fill", title: "Movies", type: .movies),
        TabItemViewModel(imageName: "gear", title: "Technology", type: .technology)
        
    ]
}


struct TabItemViewModel: Hashable {
    let imageName: String
    let title: String
    let type: TabItemType
    
    enum TabItemType{
        case homePage
        case arts
        case business
        case movies
        case technology
    }
}
