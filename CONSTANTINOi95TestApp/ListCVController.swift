//
//  ListCVController.swift
//  CONSTANTINOi95TestApp
//
//  Created by Guest User on 19/11/2017.
//  Copyright © 2017 Rj Constantino. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import SwiftyJSON

private let reuseIdentifier = "Cell"

class ListCVController: UICollectionViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    let searchBar = UISearchBar()
    let emptyLabel = UILabel()
    
    var movies: [MovieDetail] = []
    var isFavorite = false
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        navigationController?.navigationBar.tintColor = .orange
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        emptyLabel.frame = (self.collectionView?.bounds)!
        emptyLabel.textColor = .darkGray
        emptyLabel.font = UIFont.boldSystemFont(ofSize: 30.0)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.isHidden = true
        self.collectionView?.addSubview(emptyLabel)
        
        if isFavorite {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(tappedClose))
            navigationItem.titleView = nil
            title = "Favorites"
            activityIndicator.isHidden = true
        } else {
            searchBar.placeholder = "type a title of a movie"
            searchBar.sizeToFit()
            searchBar.delegate = self
            searchBar.barStyle = .blackTranslucent
            navigationItem.titleView = searchBar
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favorites", style: .plain, target: self, action: #selector(tappedFavorite))
        }
        
        reloadCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isFavorite {
            movies.removeAll()
            let favorites = DataManager.fetchData()
            for favorite in favorites {
                movies.append(MovieDetail(data: favorite))
            }
        }
        
        reloadCollectionView()
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView?.reloadData()
        }
        
        if movies.count == 0 {
            emptyLabel.isHidden = false
            emptyLabel.text = isFavorite ? "No Favorite Movies Yet" : "Search For Movies"
        } else {
            emptyLabel.isHidden = true
        }
    }
    
    func tappedClose() {
        dismiss(animated: true, completion: nil)
    }
    
    func tappedFavorite() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ListCVController") as! ListCVController
        vc.isFavorite = true
        let root = UINavigationController(rootViewController: vc)
        present(root, animated: true, completion: nil)
    }
    
    func fireMovies() {
        
        let url = "https://itunes.apple.com/search?country=PH&entity=movie&term=\(searchBar.text ?? "Wonder")"

        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
            .responseJSON { response in
                
                if let status = response.response?.statusCode {
                    switch(status) {
                    case 200:
                        if let value = response.result.value {
                            let results = JSON(value)["results"].array
                            for item in results! {
                                let movie = MovieDetail(json: item)
                                self.movies.append(movie)
                            }
                            
                            self.activityIndicator.isHidden = true
                            self.reloadCollectionView()
                        }
                    default:
                        print("default")
                    }
                }
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return movies.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCVCell", for: indexPath) as! MovieCVCell
        cell.backgroundColor = .white
        cell.delegate = self
        cell.tag = indexPath.row
        cell.backgroundColor = .clear
        
        cell.moviePhoto.kf.indicatorType = .activity
        cell.moviePhoto.kf.setImage(with: URL(string: movies[indexPath.row].artworkUrl100!))
        
        if isFavorite {
            cell.favoriteButton.isHidden = true
        } else {
            cell.favoriteButton.isHidden = false
            if DataManager.movieAlreadyExist(withID: movies[indexPath.row].trackId) {
                cell.favoriteButton.setImage(UIImage(named: "star"), for: .normal)
            } else {
                cell.favoriteButton.setImage(UIImage(named: "star-placeholder"), for: .normal)
            }
        }
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.resignFirstResponder()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "DetailsViewController") as! DetailsViewController
        vc.movie = movies[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ListCVController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (UIScreen.main.bounds.width / 3) - 2
        return CGSize(width: width, height: width + (width * 0.35))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}

extension ListCVController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if activityIndicator.isHidden == true {
           activityIndicator.isHidden = false
        }
        movies.removeAll()
        reloadCollectionView()
        fireMovies()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
}

extension ListCVController: MovieCVCellDelegate {
    
    func didTappedFavorite(cell: MovieCVCell) {
        
        if DataManager.movieAlreadyExist(withID: movies[cell.tag].trackId) {
            DataManager.deleteMovie(withId: movies[cell.tag].trackId)
        } else {
            DataManager.add(movie: movies[cell.tag])
        }
        
        self.collectionView?.reloadItems(at: [IndexPath(item: cell.tag, section: 0)])
    }
}
