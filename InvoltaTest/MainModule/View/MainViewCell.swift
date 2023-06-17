import UIKit

class MainViewCell: UITableViewCell {
    static let id = "MainViewCell"
    
    private let avatarImageView = UIImageView()
    private let messageLabel = UILabel()
    private let view = UIView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupAll()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        avatarImageView.stopDownload()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
    }
    
    private func setupStyle() {
        selectionStyle = .none
        
        view.backgroundColor = .gray
        view.layer.cornerRadius = 20
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.layer.cornerRadius = 15
        avatarImageView.clipsToBounds = true
        
        messageLabel.numberOfLines = 0
        messageLabel.textColor = Palette.color(for: .lDark_dWhite)
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupLayout() {
        contentView.addSubview(view)
        view.addSubview(avatarImageView)
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            avatarImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 30),
            avatarImageView.widthAnchor.constraint(equalToConstant: 30),
            
            messageLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            messageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            messageLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            messageLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    func configure(message: Message) {
        messageLabel.text = message.title
        avatarImageView.startDownload(from: message.imageString ?? "")
    }
}
