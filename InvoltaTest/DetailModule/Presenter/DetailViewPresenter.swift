import Foundation

protocol DetailViewPresenterProtocol: AnyObject {
    var message: Message { get }
    init(view: DetailViewProtocol, message: Message, coreDataService: CoreDataService, delegate: MainViewPresenterProtocol)
    func deleteMessage()
}

class DetailViewPresenter: DetailViewPresenterProtocol {
    private weak var view: DetailViewProtocol?
    var message: Message
    private let coreDataService: CoreDataService
    private weak var delegate: MainViewPresenterProtocol?
    
    required init(view: DetailViewProtocol, message: Message, coreDataService: CoreDataService, delegate: MainViewPresenterProtocol) {
        self.view = view
        self.message = message
        self.coreDataService = coreDataService
        self.delegate = delegate
    }
    
    func deleteMessage() {
        delegate?.deleteMessage(message: message)
        
        let localMessages = coreDataService.fetchMessagesEntity()
        localMessages.forEach { messageEntity in
            if messageEntity.title == message.title {
                coreDataService.removeMessageEntity(removeMessage: messageEntity)
            }
        }
    }
}
