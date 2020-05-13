import UIKit

public enum Result<A> {
    case success(A)
    case failure(Error)
}



extension String {
    func validated() -> String {
        let copy = self
        let output = copy.trimmingCharacters(in: .whitespacesAndNewlines)
        return output
    }
}


// MARK: - LoginViewController
final class LogInViewController: UIViewController {
    
        
    // ui input
    public let usernameTextfield = UITextField()
    public let passwordTextField = UITextField()
    private let activityIndicator = UIActivityIndicatorView()
    public let button = UIButton()
    public let label = UILabel()
    
    private let service: ServiceProtocol
    
    
    required init(service: ServiceProtocol) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    public enum UX {
        static let signInButtonIdentifier = "sign_up"
        static let successAlertViewIdentifier = "success_alert_view"
        static let successAlertMessage = "Congrats, you are in"
        static let errorLabelIdentifier = "error_label"
        static let usernameFieldIdentifier = "usernameField"
        static let passwordFieldIdentifier  = "passwordIdentifier"
        static let spinnerIdentifier = "spinner"
    }
    
    private var safeArea: UILayoutGuide {
        if #available(iOS 11, *) {
           return view.safeAreaLayoutGuide
        } else {
           return view.layoutMarginsGuide
        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        activityIndicator.isHidden = true
        activityIndicator.accessibilityIdentifier = LogInViewController.UX.spinnerIdentifier
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .large // aka gray
        view.addSubview(activityIndicator)
        
        view.backgroundColor = .white
        let content = UIStackView()
        content.alignment = .fill
        content.distribution = .fill
        content.axis = .vertical
        content.spacing = 20
        content.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)
        
        // Do any additional setup after loading the view.
        usernameTextfield.placeholder = "Please enter Username"
        usernameTextfield.accessibilityIdentifier = LogInViewController.UX.usernameFieldIdentifier
        usernameTextfield.borderStyle = .line
        
        passwordTextField.placeholder = "Please enter Password"
        passwordTextField.isSecureTextEntry = true
        passwordTextField.borderStyle = .line
        passwordTextField.accessibilityIdentifier = LogInViewController.UX.passwordFieldIdentifier
        
        button.accessibilityIdentifier = LogInViewController.UX.signInButtonIdentifier
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .preferredFont(forTextStyle: .headline)
        button.addTarget(self, action: #selector(onToggle(_:)), for: .touchUpInside)
        
        [usernameTextfield, passwordTextField, button].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            content.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 50).isActive = true
            
        }
        
        label.isHidden = true 
        label.accessibilityIdentifier = LogInViewController.UX.errorLabelIdentifier
        label.numberOfLines = 4
        label.backgroundColor = .white
        label.textColor = .red
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        content.addArrangedSubview(label)
        
        content.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 20).isActive = true
        content.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 100).isActive = true
        content.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -20).isActive = true

    }
    
    @objc private func onToggle(_ sender: UIButton) {

        guard let username = usernameTextfield.text?.validated(),
              let password = passwordTextField.text?.validated(),
              !username.isEmpty && !password.isEmpty
            else {
                self.setErrorState(message: "Either username or password is empty")
                return
        }
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        service.signIn(username: username, password: password) { [weak self] (result) in
            DispatchQueue.main.async { [weak self] in
                guard let `self` = self else { return }
                self.activityIndicator.stopAnimating()

                if case .success(_) = result {
                    self.label.isHidden = true
                    self.showSuccessAlertView()
                }
                if case .failure(let error) = result {
                    self.setErrorState(message:error.localized())
                }
                
            }
        }
    }
    
    public func setErrorState(message: String) {
        self.label.isHidden = false
        self.label.text = message
    }

    private func showSuccessAlertView() {
        let alertController = UIAlertController(title: nil, message: UX.successAlertMessage, preferredStyle: .alert)
        alertController.accessibilityLabel = UX.successAlertViewIdentifier
        alertController.accessibilityValue = UX.successAlertMessage
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

}

