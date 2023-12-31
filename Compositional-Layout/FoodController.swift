//
//  FoodController.swift
//  Compositional-Layout
//
//  Created by Bahittin on 4.10.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class FoodController: UICollectionViewController {
    
    let resimArray: [String] = ["resim4","resim2","resim3","resim1"]
    
    static let API_KEY = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIzZjFjNzlmMDY5YjM4ZDI1NmMzYmExOTY2MDlkNDQ3ZCIsInN1YiI6IjY0Zjc2N2I1MWI3MjJjMDEzYTI1NjQyZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.vgMLzRMlTPrFzjc1HJqaphrO4UMJaMCvCMfkpFr1Xls"
    
    let baseUrl = "https://api.themoviedb.org"
    
    let headers = [
        "accept": "application/json",
        "Authorization": "Bearer \(FoodController.API_KEY)"
    ]
    
    var titlesArray = [Title]()
    
    
    init() {
        
        super.init(collectionViewLayout: FoodController.createLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        navigationItem.title = "Food Delivery"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "newColor")]
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView!.register(denemeCollectionViewCell.self, forCellWithReuseIdentifier: "denemeCell")
        collectionView.register(Header.self, forSupplementaryViewOfKind: FoodController.categoryHeaderId, withReuseIdentifier: headerId)
        
        getTrendingMovies { repsonse in
            switch repsonse {
            case .success(let titles):
                DispatchQueue.main.async {
                    self.titlesArray = titles
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print("error is \(error)")
            }
            
        }
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalHeight(1)))
                
                item.contentInsets.trailing = 5
                //item.contentInsets.bottom   = 16
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .absolute(200)),
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                
                section.orthogonalScrollingBehavior = .paging
                
                return section
            } else if sectionNumber == 1 {
                
                let item  = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.25),
                                                                     heightDimension: .absolute(150)))
                
                item.contentInsets.trailing = 16
                item.contentInsets.bottom   = 16
                
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1),
                                      heightDimension: .estimated(500)),
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.contentInsets.leading = 16
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(50)),
                          elementKind: categoryHeaderId,
                          alignment: .topLeading)
                ]
                
                return section
            } else if sectionNumber == 2 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalHeight(1)))
                
                item.contentInsets.trailing = 16
                item.contentInsets.bottom   = 16
                
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.75),
                                                                                 heightDimension: .absolute(125)),
                                                               subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                section.orthogonalScrollingBehavior = .continuous
                section.contentInsets.leading = 16
                
                section.boundarySupplementaryItems = [
                    .init(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                            heightDimension: .absolute(50)),
                          elementKind: categoryHeaderId,
                          alignment: .topLeading)
                ]
                
                return section
            } else {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                    heightDimension: .absolute(300)))
                item.contentInsets.bottom   = 16
                item.contentInsets.trailing = 16
                
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                                 heightDimension: .estimated(1000)),
                                                               subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                
                section.contentInsets = .init(top: 32, leading: 16, bottom: 0, trailing: 0)
                
                return section
            }
        }
    }
    
    func getTrendingMovies(completion: @escaping (Result<[Title], Error>) -> Void) {
        let request =  makeRequest(with: "\(baseUrl)/3/trending/movie/day?language=en-US")

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data, error == nil else { return }
            
            do {
                let results = try JSONDecoder().decode(TrendingTitleResponse.self, from: data)
                completion(.success(results.results))
    
            } catch {
                completion(.failure(error))
            }
            
        })

        dataTask.resume()
    }
    

    
    func makeRequest(with url: String) -> NSMutableURLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request
    }
    
    
    static let categoryHeaderId = "categoryHeaderId"
    let headerId = "headerId"
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        header.configure(with: "Categories")
        if indexPath.section == 1 {
            header.configure(with: "Category")
        } else {
            header.configure(with: "Category2")
        }
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return titlesArray.count
        }
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       
        
        if indexPath.section == 0 {
            
            let photo = titlesArray[indexPath.row].poster_path ?? "/fyuUJcUIsY0g5tHOC2UDmv1PiJL.jpg"
            let photoURL = "https://image.tmdb.org/t/p/w500/\(photo)"
            
            let url = URL(string: photoURL)
            
            print(photoURL)
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "denemeCell", for: indexPath) as! denemeCollectionViewCell
            cell.backgroundColor = .lightGray
            cell.configureImage(with: photoURL)
            return cell
            
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cell.backgroundColor = .lightGray
            return cell
        }
        
        
        
        
        
        //        switch indexPath.section {
        //        case 0:
        //            cell.backgroundColor = .blue
        //        default:
        //            cell.backgroundColor = .gray
        //        }
        //
        
        
        //        if indexPath.section == 0 {
        //            cell.backgroundColor = .red
        //        } else if indexPath.section == 1 {
        //            cell.backgroundColor = .purple
        //            cell.layer.cornerRadius = 10
        //        } else if indexPath.section == 2 {
        //            cell.backgroundColor = .blue
        //            cell.layer.cornerRadius = 10
        //        } else {
        //            cell.backgroundColor = .lightGray
        //            cell.layer.cornerRadius = 10
        //        }
        //
        
        // Configure the cell
        
        return UICollectionViewCell()
    }
}

class Header: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        label.text = "Categories"
        label.textColor = UIColor(named: "newColor")
        addSubview(label)
    }
    
    public func configure(with CategoryName: String) {
        label.text = CategoryName
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    
}
