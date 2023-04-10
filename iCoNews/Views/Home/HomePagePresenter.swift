//
//  HomePagePresenter.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 12/11/22.
//

import Foundation

// Output
protocol HomePagePresenterProtocol: BaseProviderOutputProtocol {
    func setTitularHome(completion: Result<[TitularViewModel]?, NetworkError>)
}

final class HomePagePresenter: BaseViewModel, ObservableObject {
        
    var provider: HomeProviderInputProtocol? {
        super.baseProvider as? HomeProviderInputProtocol
    }
    
    @Published var arrayItems: [Item] = []
    
    func fetchData () {
        provider?.fetchDataTitular()
//        let feedParser = FeedParser()
//        self.arrayItems.removeAll()
//        feedParser.parseFeed(pUrl: "https://api.nytimes.com/services/xml/rss/nyt/HomePage.xml") { items in
//            DispatchQueue.main.async {
//                self.arrayItems = items
//            }
//
//        }
    }
}

extension HomePagePresenter: HomePagePresenterProtocol {
    func setTitularHome(completion: Result<[TitularViewModel]?, NetworkError>) {
        switch completion{
        case .success(let data):
            debugPrint(data)
//            self.viewModel?.setInfoTrendingTopicViewModel(data: self.transformDataResultTrendingTopToMoviesShowsModel(data: data))
        case .failure(let error):
            debugPrint(error)
        }
    }
}

