//
//  ViewController.swift
//  It's a Zoo in There
//
//  Created by Zhang on 2024/1/17.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var labelText: UILabel!
    @IBOutlet var scrollView: UIScrollView!
    
    var audioPlayer: AVAudioPlayer?
    var animals = [Animal]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scrollView.delegate = self
        
        animals = [
            Animal(name: "Cherry", species: "cat", age: 1, image: UIImage(named: "cherry")!, soundPath: "\(Bundle.main.path(forResource: "Cherry", ofType: "wav")!)"),
            Animal(name: "Brava", species: "dog", age: 6, image: UIImage(named: "brava")!, soundPath: "\(Bundle.main.path(forResource: "Brava", ofType: "wav")!)"),
            Animal(name: "Zane", species: "cat", age: 4, image: UIImage(named: "zane")!, soundPath: "\(Bundle.main.path(forResource: "Zane", ofType: "flac")!)")
        ]
        animals.shuffle()
        for animal in animals{
            print(animal)
        }
        
        scrollView.contentSize = CGSize(width: 1179, height: 600)
        scrollView.isPagingEnabled = true
        
        for index in 0...2 {
            //add image to scroll view
            let xCoordinate = CGFloat(index) * (scrollView.frame.width) + (scrollView.frame.width - 393) / 2
            let imageViewFrame = CGRect(x: xCoordinate, y: 0, width: 393, height: 320)
            let imageView = UIImageView(frame: imageViewFrame)
            imageView.image = animals[index].image
            imageView.contentMode = .scaleAspectFit
            scrollView.addSubview(imageView)
            
            //add button to scrollview
            var config = UIButton.Configuration.filled()
            config.title = animals[index].name
            config.baseBackgroundColor = UIColor(red: 255/255, green: 190/255, blue: 192/255, alpha: 1.0)
            config.baseForegroundColor = UIColor.white
            let button = UIButton(configuration: config, primaryAction: UIAction(){ _ in print("Custom Button tapped")})
            button.tag = index
            button.center = CGPoint.init(x: 150 + 393 * index, y: 400)
            button.frame.size = CGSize(width: 100.0, height: 30.0)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            scrollView.addSubview(button)
            
        }
    }
    
    @objc func buttonTapped(_ button: UIButton) {
        let animal = animals[button.tag]
        let alertController = UIAlertController(title: animal.name, message: "Age: \(animal.age)\nSpecies: \(animal.species)", preferredStyle: .alert)
        let playSoundAction = UIAlertAction(title: "Play Sound", style: .default) { [weak self] _ in
            self?.playSound(for: animal)
            print(animal.description)
        }
        alertController.addAction(playSoundAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    func playSound(for animal: Animal) {
        let soundURL = URL(fileURLWithPath: animal.soundPath)
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.play()
            print("Sound played!")
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}
    
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = 393
        let pageIndex = round(scrollView.contentOffset.x / CGFloat(pageWidth))

        if Int(pageIndex) < animals.count {
            let currentAnimal = animals[Int(pageIndex)]
            labelText.text = currentAnimal.species
        }

        let offset = scrollView.contentOffset.x.truncatingRemainder(dividingBy: CGFloat(pageWidth))
        let alpha = 2 * abs(offset - CGFloat(pageWidth) / 2) / CGFloat(pageWidth)
        labelText.alpha = alpha
    }
}


