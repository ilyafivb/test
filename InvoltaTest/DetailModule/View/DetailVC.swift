import UIKit

protocol DetailViewProtocol: AnyObject {
    
}

class DetailVC: UIViewController, DetailViewProtocol {
    var presenter: DetailViewPresenterProtocol!
    
    private let dateLabel = UILabel()
    private let avatarImageView = UIImageView()
    private let messageLabel = UILabel()
    private let deleteButton = UIButton()
    private let backButton = UIButton()
    
    private var startX = CGFloat()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAll()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 1) {
            self.dateLabel.alpha = 1
            self.avatarImageView.layer.opacity = 1
            self.messageLabel.layer.opacity = 1
            self.deleteButton.alpha = 1
            self.backButton.alpha = 1
        }
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        view.backgroundColor = .gray
        
        backButton.alpha = 0
        var backButtonConfig = UIButton.Configuration.plain()
        backButtonConfig.title = "Назад"
        backButtonConfig.image = UIImage(systemName: "chevron.backward")
        backButtonConfig.imagePadding = 8
        backButtonConfig.baseForegroundColor = Palette.color(for: .lDark_dWhite)
        backButton.configuration = backButtonConfig
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        dateLabel.alpha = 0
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: date)
        dateLabel.text = dateString
        dateLabel.textColor = Palette.color(for: .lDark_dWhite)
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.layer.opacity = 0
        avatarImageView.startDownload(from: presenter.message.imageString ?? "")
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.layer.opacity = 0
        messageLabel.text = presenter.message.title
        messageLabel.numberOfLines = 0
        messageLabel.textColor = Palette.color(for: .lDark_dWhite)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        deleteButton.alpha = 0
        var deleteButtonConfig = UIButton.Configuration.bordered()
        deleteButtonConfig.title = "Удалить сообщение"
        deleteButtonConfig.baseForegroundColor = .red
        deleteButton.configuration = deleteButtonConfig
        deleteButton.translatesAutoresizingMaskIntoConstraints = false
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setupLayout() {
        view.addSubview(backButton)
        view.addSubview(dateLabel)
        view.addSubview(avatarImageView)
        view.addSubview(messageLabel)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
            
            avatarImageView.topAnchor.constraint(equalTo: backButton.bottomAnchor, constant: 30),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            
            messageLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20),
            messageLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            messageLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            
            dateLabel.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: messageLabel.trailingAnchor),
            
            deleteButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 20),
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    //MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func deleteButtonTapped() {
        presenter.deleteMessage()
        navigationController?.popViewController(animated: true)
    }
}
