//
//  HomeCoordinator.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 10/4/23.
//

import SwiftUI

final class HomeCoordinator: BaseCoordinator {
    
    typealias ContentView = HomePageView
    typealias ViewModel = HomePagePresenter
    typealias Provider = HomeProvider
    
    static func navigation() -> NavigationView<ContentView> {
        NavigationView {
            self.view()
        }
    }
    
    static func view() -> ContentView {
        let mvvm = BaseCoordinator.coordinator(viewModel: ViewModel.self, provider: Provider.self)
        let view = ContentView(viewModel: mvvm.viewModel)
        return view
    }
}
