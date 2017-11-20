//
//  DetailsViewController.swift
//  CONSTANTINOi95TestApp
//
//  Created by Joriel Oller Fronda on 20/11/2017.
//  Copyright © 2017 Rj Constantino. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SafariServices

class DetailsViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var releasedDateLabel: UILabel!
    @IBOutlet weak var contentAdvisoryLabel: UILabel!
    @IBOutlet weak var watchButton: UIButton!
    @IBOutlet weak var visitButton: UIButton!
    
    @IBOutlet weak var webView: UIWebView!
    var movie: MovieDetail?
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: DataManager.movieAlreadyExist(withID: (movie?.trackId)!) ? "favorite" : "not-favorite"), style: .plain, target: self, action: #selector(tappedFavorite))
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = backgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundImageView.addSubview(blurEffectView)
        
        backgroundImageView.kf.setImage(with: URL(string: (movie?.artworkUrl100)!))
        previewImageView.kf.setImage(with: URL(string: (movie?.artworkUrl100)!))
        titleLabel.text = movie?.trackName
        descriptionLabel.text = movie?.longDescription
        genreLabel.text = movie?.primaryGenreName
        let date = movie?.releaseDate.components(separatedBy: "T")
        releasedDateLabel.text = date![0]
        contentAdvisoryLabel.text = movie?.contentAdvisoryRating
        
        watchButton.border()
        visitButton.border()
    }

    func tappedFavorite() {
        
        if DataManager.movieAlreadyExist(withID: (movie?.trackId)!) {
            DataManager.deleteMovie(withId: (movie?.trackId)!)
        } else {
            let alert = UIAlertController(title: movie?.trackName!, message: "\(movie!.trackName!) has been added to Favorites", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            DataManager.add(movie: movie!)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: DataManager.movieAlreadyExist(withID: (movie?.trackId)!) ? "favorite" : "not-favorite"), style: .plain, target: self, action: #selector(tappedFavorite))
    }
    
    @IBAction func watchAction(_ sender: UIButton) {
        
        let player = AVPlayer(url: URL(string: (movie?.previewUrl)!)!)
        let playerController = AVPlayerViewController()
        playerController.player = player
        
        self.present(playerController, animated: true) {
            player.play()
        }
    }
    
    @IBAction func visitAction(_ sender: UIButton) {
        
        let safariVC = SFSafariViewController(url: URL(string: (movie?.trackViewUrl)!)!)
        self.present(safariVC, animated: true, completion: nil)        
    }
    
}

extension UIButton {
    
    func border() {
        self.layer.borderWidth = 2.0
        self.layer.borderColor = UIColor.orange.cgColor
        self.layer.cornerRadius = 5.0
    }
}
