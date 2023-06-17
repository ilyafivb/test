import UIKit

protocol MainViewProtocol: AnyObject {
    var isLoading: Bool { get set }
    func successUpdateMessages()
    func failureUpdateMessages()
}

class MainVC: UIViewController {
    private let tableView = UITableView()
    private let staticTopLabel = UILabel()
    private let staticTopView = UIView()
    private let sendMessageField = UITextField()
    
    var presenter: MainViewPresenterProtocol!
    
    var isLoading = false
    private var isAnimating = false
    
    private let topIndexPath = IndexPath(row: 0, section: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.getMessages()
        setupAll()
    }
    
    //MARK: - Setup
    
    private func setupAll() {
        setupStyle()
        setupLayout()
        setupTableView()
    }
    
    private func setupStyle() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = Palette.color(for: .lWhite_dDark)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none

        staticTopView.translatesAutoresizingMaskIntoConstraints = false
        
        staticTopLabel.text = "Тестовое задание"
        staticTopLabel.font = .boldSystemFont(ofSize: 25)
        staticTopLabel.textAlignment = .center
        staticTopLabel.numberOfLines = 0
        staticTopLabel.textColor = Palette.color(for: .lDark_dWhite)
        staticTopLabel.translatesAutoresizingMaskIntoConstraints = false
        
        sendMessageField.borderStyle = .roundedRect
        sendMessageField.placeholder = "Введите сообщение"
        sendMessageField.delegate = self
        sendMessageField.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MainViewCell.self, forCellReuseIdentifier: MainViewCell.id)
        tableView.transform = CGAffineTransform(scaleX: -1,y: -1)
    }

    private func setupLayout() {
        view.addSubview(staticTopView)
        staticTopView.addSubview(staticTopLabel)
        view.addSubview(tableView)
        view.addSubview(sendMessageField)
        
        NSLayoutConstraint.activate([
            staticTopView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            staticTopView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            staticTopView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            staticTopView.heightAnchor.constraint(equalTo: staticTopLabel.heightAnchor),
            
            staticTopLabel.bottomAnchor.constraint(equalTo: staticTopView.bottomAnchor),
            staticTopLabel.leadingAnchor.constraint(equalTo: staticTopView.leadingAnchor),
            staticTopLabel.trailingAnchor.constraint(equalTo: staticTopView.trailingAnchor),
            
            sendMessageField.bottomAnchor.constraint(equalTo: view.keyboardLayoutGuide.topAnchor),
            sendMessageField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sendMessageField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sendMessageField.heightAnchor.constraint(equalToConstant: 40),
            
            tableView.topAnchor.constraint(equalTo: staticTopView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: sendMessageField.topAnchor)
        ])
    }
    
    private func createActivityFooterView() -> UIView {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.center = view.center
        view.addSubview(activityView)
        activityView.startAnimating()
        return view
    }
}

//MARK: - MainViewProtocol extension

extension MainVC: MainViewProtocol {
    func successUpdateMessages() {
        if isAnimating {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
                self?.tableView.endUpdates()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                self?.isAnimating = false
            }
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.tableView.tableFooterView = nil
                self?.tableView.reloadData()
            }
        }
    }
    
    func failureUpdateMessages() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
}

//MARK: - UITableViewDataSource, UITableViewDelegate extension

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MainViewCell.id, for: indexPath) as! MainViewCell
        cell.contentView.transform = CGAffineTransform(scaleX: -1,y: -1)
        cell.configure(message: presenter.messages[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = presenter.messages[indexPath.row]
        let detailVC = ModuleBuilder.createDetailModule(message: message, delegate: presenter)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

//MARK: - UIScrollViewDelegate extension

extension MainVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > tableView.contentSize.height - scrollView.frame.size.height {
            guard !isLoading else { return }
            isLoading = true
            tableView.tableFooterView = createActivityFooterView()
            presenter.getMessages()
        }
    }
}

//MARK: - UITextFieldDelegate extension

extension MainVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        isAnimating = true
        guard let messageString = textField.text, messageString != "" else { return false }
        let message = Message(title: messageString, imageString: AppConfiguration.staticImageUrl)
        presenter.addMessage(message: message)
        textField.text = ""
        return true
    }
}

