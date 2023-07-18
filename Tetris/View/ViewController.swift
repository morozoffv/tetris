import UIKit

protocol ViewInput: AnyObject {
    func redraw(string: String)
}

protocol ViewOutput {
    func onViewDidLoad()
    func left()
    func right()
    func rotate()
    func restart()
}

final class ViewController: UIViewController, ViewInput {
    
    var output: ViewOutput?
        
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Left", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Right", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let rotateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Rotate", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let retryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let gameField: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        output?.onViewDidLoad()
        
        addSubviews()
        setupConstraints()
                
        leftButton.addTarget(self, action: #selector(leftButtonDidTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonDidTapped), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(rotateButtonDidTapped), for: .touchUpInside)
        retryButton.addTarget(self, action: #selector(retryButtonDidTapped), for: .touchUpInside)
        
        view.backgroundColor = .white
    }
    
    func redraw(string: String) {
        gameField.text = string
    }
    
    private func addSubviews() {
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(rotateButton)
        view.addSubview(retryButton)
        view.addSubview(gameField)
    }
    
    private func setupConstraints() {
        view.addConstraints([
            leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            rightButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            rotateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            retryButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            retryButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),

            gameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gameField.leftAnchor.constraint(equalTo: view.leftAnchor),
            gameField.rightAnchor.constraint(equalTo: view.rightAnchor),
            gameField.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: 16)
        ])
    }
    
    @objc private func leftButtonDidTapped() {
        output?.left()
    }
    
    @objc private func rightButtonDidTapped() {
        output?.right()
    }
    
    @objc private func rotateButtonDidTapped() {
        output?.rotate()
    }
    
    @objc private func retryButtonDidTapped() {
        output?.restart()
    }
}
