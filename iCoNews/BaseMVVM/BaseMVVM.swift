//
//  BaseMVVM.swift
//  iCoNews
//
//  Created by TECDATA ENGINEERING on 10/4/23.
//

import Foundation

enum ViewModelState: String {
    case ok
    case loading
    case error
}

protocol BaseProviderInputProtocol: AnyObject {}
protocol BaseProviderOutputProtocol: AnyObject {}

class BaseViewModel {
    
    @Published var state: ViewModelState = .ok
    
    func changheState() {
        let option = Int.random(in: 0..<3)
        switch option {
        case 0: self.state = .ok
        case 1: self.state = .loading
        case 2: self.state = .error
        default: self.state = .ok
        }
    }
    
    
    internal var baseProvider: BaseProviderInputProtocol?
    required init() {}
}

class BaseProvider {
    internal weak var baseViewModel: BaseProviderOutputProtocol?
    required init() {}
}

class BaseCoordinator {
    
    static func coordinator<ViewModel: BaseViewModel,
                            Provider: BaseProvider>(viewModel: ViewModel.Type,
                                                    provider: Provider.Type) -> (viewModel: ViewModel,
                                                                                 provider: Provider) {
        let baseViewModel = ViewModel()
        let baseProvider = Provider()

        baseViewModel.baseProvider = baseProvider as? BaseProviderInputProtocol
        baseProvider.baseViewModel = baseViewModel as? BaseProviderOutputProtocol
        
        return (baseViewModel, baseProvider)
        
    }
}
