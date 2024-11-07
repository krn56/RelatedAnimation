//
//  ViewController.swift
//  RelatedAnimation
//
//  Created by Роман Крендясов on 07.11.2024.
//

import UIKit

final class ViewController: UIViewController {
// MARK: - Properties
    private let squareView = UIView()
    private let slider = UISlider()
    private var initialSquareSize: CGFloat = 100.0
    private var finalSquareSize: CGFloat { return initialSquareSize * 1.5 }

// MARK: - View Lifecyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureSquareView()
        configureSlider()
    }
    
// MARK: - Setup UI
    private func configureSquareView() {
        view.addSubview(squareView)
        squareView.backgroundColor = .systemBlue
        squareView.layer.cornerRadius = 15
        squareView.frame = CGRect(x: view.layoutMargins.left + 20, y: (view.bounds.height - initialSquareSize) / 2, width: initialSquareSize, height: initialSquareSize)
    }
    
    private func configureSlider() {
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.value = 0
        
        NSLayoutConstraint.activate([
            slider.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -250),
            slider.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor)
        ])
        
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchEnded), for: [.touchUpInside, .touchUpOutside])
    }

// MARK: - Touch Processing Methods
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let progress = CGFloat(sender.value)
        
        let totalWidth = view.bounds.width - view.layoutMargins.left - view.layoutMargins.right - initialSquareSize - 50
        let newX = view.layoutMargins.left + totalWidth * progress
        let newSize = initialSquareSize + (finalSquareSize - initialSquareSize) * progress
        
        squareView.frame = CGRect(x: newX, y: (view.bounds.height - newSize) / 2, width: newSize, height: newSize)
    
        let rotationAngle = CGFloat.pi / 2 * progress
        let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 0.0001, 1)
        self.squareView.layer.transform = rotationTransform
    }
    
    @objc private func sliderTouchEnded(_ sender: UISlider) {
        UIView.animate(withDuration: 0.5) {
            self.slider.setValue(1, animated: true)
            self.sliderValueChanged(self.slider)
        }
    }
}

#Preview {
    ViewController()
}
