//
//  ViewController.swift
//  Tetris
//
//  Created by Vladislav Morozov on 09.07.2023.
//

import UIKit

class ViewController: UIViewController {
    
    private let gameLauncher = GameLauncher()
    
    let leftButton = UIButton(type: .system)
    let rightButton = UIButton(type: .system)
    let rotateButton = UIButton(type: .system)
    
    let label = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        gameLauncher.start()
        gameLauncher.delegate = self
        
        leftButton.addTarget(self, action: #selector(leftButtonDidTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonDidTapped), for: .touchUpInside)
        rotateButton.addTarget(self, action: #selector(rotateButtonDidTapped), for: .touchUpInside)
        
        leftButton.setTitle("Left", for: .normal)
        rightButton.setTitle("Right", for: .normal)
        rotateButton.setTitle("Rotate", for: .normal)
        
        label.numberOfLines = 0
        label.textAlignment = .center
        
        view.addSubview(leftButton)
        view.addSubview(rightButton)
        view.addSubview(rotateButton)
        view.addSubview(label)
        
        leftButton.translatesAutoresizingMaskIntoConstraints = false
        rightButton.translatesAutoresizingMaskIntoConstraints = false
        rotateButton.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            leftButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            leftButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            rightButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16),
            rightButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            rotateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            rotateButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),

            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.bottomAnchor.constraint(equalTo: leftButton.topAnchor, constant: 16)
        ])
    }

    @objc func leftButtonDidTapped() {
        gameLauncher.leftDidTapped()
    }
    
    @objc func rightButtonDidTapped() {
        gameLauncher.rightDidTapped()
    }
    
    @objc func rotateButtonDidTapped() {
        gameLauncher.rotateDidTapped()
    }

}

//TODO: do better
extension ViewController: GameLauncherDelegate {
    func didUpdate(string: String) {
//        let attributedString = NSMutableAttributedString(string: string)
//        attributedString.addAttribute(NSAttributedString.Key.kern,
//                                      value: 5,
//                                      range: NSMakeRange(0, string.count - 1))
//        label.attributedText = attributedString
        
        
        label.text = string
    }
}
