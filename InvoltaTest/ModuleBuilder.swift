import UIKit

class ModuleBuilder {
    static func createMainModule() -> UIViewController {
        let view = MainVC()
        let networkService = NetworkService()
        let coreDataService = CoreDataService.shared
        let presenter = MainViewPresenter(view: view, networkService: networkService, coreDataService: coreDataService)
        view.presenter = presenter
        return view
    }
    
    static func createDetailModule(message: Message, delegate: MainViewPresenterProtocol) -> UIViewController {
        let view = DetailVC()
        let coreDataService = CoreDataService.shared
        let presenter = DetailViewPresenter(view: view, message: message, coreDataService: coreDataService, delegate: delegate)
        view.presenter = presenter
        return view
    }
}
