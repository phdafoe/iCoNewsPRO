//
//  HomeProvider.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation
import Combine

// Input
protocol HomeProviderInputProtocol {
    func fetchDataTitular()
}

final class HomeProvider {
    
    let homeViewPresenter: HomePagePresenterProtocol = HomePagePresenter()
    let networkService: Requestable = NetworkRequestable()
    var cancellable: Set<AnyCancellable> = []
    

    
    func transformDataResultNowPlayingToMoviesShowsModel(data: [DatumTitular]?) -> [TitularViewModel]? {
        var arrayTitularViewModel: [TitularViewModel] = []
        if let dataDes = data {
            for index in 0..<dataDes.count {
                let object = TitularViewModel(id: dataDes[index].id ?? 0,
                                              typedescription: dataDes[index].typedescription ?? "",
                                              title: dataDes[index].title ?? "",
                                              urlWeb: dataDes[index].url ?? "",
                                              activo: dataDes[index].active ?? false)
                arrayTitularViewModel.append(object)
            }
        }
        return arrayTitularViewModel
    }
}

extension HomeProvider: HomeProviderInputProtocol {
    func fetchDataTitular() {
        networkService.request(RequestModel(service: Service), model: TitularServerModel.self)
            .sink { completion in
                switch completion{
                case .finished: break
                case .failure(let error):
                    print(error)
                    self.homeViewPresenter.setTitularHome(completion: .failure(error))
                    //                self.interactor?.setInfoPopular(completionData: .failure(error))
                }
            } receiveValue: { resultData in
                self.homeViewPresenter.setTitularHome(completion: .success(self.transformDataResultNowPlayingToMoviesShowsModel(data: resultData)))
            }
            .store(in: &cancellable)
    }
}



                                    
