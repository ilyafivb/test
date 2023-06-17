import Foundation

protocol MainViewPresenterProtocol: AnyObject {
    var messages: [Message] { get set }
    init(view: MainViewProtocol, networkService: NetworkServiceProtocol, coreDataService: CoreDataService)
    func getMessages()
    func addMessage(message: Message)
    func deleteMessage(message: Message)
}

class MainViewPresenter: MainViewPresenterProtocol {
    private weak var view: MainViewProtocol?
    
    private let networkService: NetworkServiceProtocol
    private let coreDataService: CoreDataService
    
    var messages = [Message]() {
        didSet {
            successUpdateMessages()
        }
    }
    
    required init(view: MainViewProtocol, networkService: NetworkServiceProtocol, coreDataService: CoreDataService) {
        self.view = view
        self.networkService = networkService
        self.coreDataService = coreDataService
        getLocalMessages()
    }
    
    private func getLocalMessages() {
        let localMessages = coreDataService.fetchMessagesEntity()
        if !localMessages.isEmpty {
            var messages = [Message]()
            localMessages.forEach { messageEntity in
                let message = Message(title: messageEntity.title, imageString: messageEntity.imageString)
                messages.append(message)
            }
            self.messages.append(contentsOf: messages)
        }
    }
    
    func getMessages() {
        networkService.getMessage { [weak self] result in
            switch result {
            case .success(let messages):
                self?.messages.append(contentsOf: messages)
                self?.view?.isLoading = false
            case .failure(let error):
                print(error)
                self?.failureUpdateMessages()
                DispatchQueue.global().asyncAfter(deadline: .now() + 3) {
                    self?.getMessages()
                }
            }
        }
    }
    
    func successUpdateMessages() {
        view?.successUpdateMessages()
    }
    
    func failureUpdateMessages() {
        view?.failureUpdateMessages()
    }
    
    func addMessage(message: Message) {
        messages.insert(message, at: 0)
        let messageEntity = MessageEntity(context: coreDataService.context)
        messageEntity.title = message.title
        messageEntity.imageString = message.imageString
        coreDataService.saveContext()
    }
    
    func deleteMessage(message: Message) {
        for (index, value) in messages.enumerated() {
            if value == message {
                messages.remove(at: index)
            }
        }
    }
}
