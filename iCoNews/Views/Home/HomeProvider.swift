//
//  HomeProvider.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 6/4/23.
//

import Foundation
import Combine

// Input
protocol HomeProviderInputProtocol: BaseProviderInputProtocol {
    func fetchDataTitular()
}

final class HomeProvider: BaseProvider {
    
    weak var viewModel: HomePagePresenterProtocol? {
        super.baseViewModel as? HomePagePresenterProtocol
    }
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
        networkService.request(RequestModel(service: HomeProviderService.homeProviderRequest), model: TitularServerModel.self)
            .sink { completion in
                switch completion{
                case .finished: break
                case .failure(let error):
                    print(error)
                    self.viewModel?.setTitularHome(completion: .failure(error))
                }
            } receiveValue: { resultData in
                self.viewModel?.setTitularHome(completion: .success(self.transformDataResultNowPlayingToMoviesShowsModel(data: resultData.data)))
            }
            .store(in: &cancellable)
    }
}

enum HomeProviderService {
    case homeProviderRequest
}

extension HomeProviderService: Service {
    var baseURL: String {
        return ""
    }
    
    var path: String {
        return "api.elconfidencial.com/service/home/ticker/1"
    }
    
    var parameter: [URLQueryItem]{
        return []
    }

    var headers: [String : String] {
        return ["Content-Type": HeaderType.applicationJson.rawValue]
    }

    var method: HTTPMethod {
        return .get
    }
}




                                    
