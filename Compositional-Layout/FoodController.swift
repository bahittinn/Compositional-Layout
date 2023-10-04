//
//  FoodController.swift
//  Compositional-Layout
//
//  Created by Bahittin on 4.10.2023.
//

import UIKit

private let reuseIdentifier = "Cell"

class FoodController: UICollectionViewController {
    
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
        
        collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(Header.self, forSupplementaryViewOfKind: FoodController.categoryHeaderId, withReuseIdentifier: headerId)
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            
            if sectionNumber == 0 {
                let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalHeight(1)))
                
                item.contentInsets.trailing = 2
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
            } else {
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
            }
        }
    }
    
    static let categoryHeaderId = "categoryHeaderId"
    let headerId = "headerId"
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! Header
        
        if indexPath[0] == 1 {
            header.configure(with: "Category")
        } else {
            header.configure(with: "Category2")
        }
        
        
            
        
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // MARK: UICollectionViewDataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        }
        return 8
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        cell.backgroundColor = .red
        // Configure the cell
        
        return cell
    }
}

class Header: UICollectionReusableView {
    let label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)

        label.text = "Categories"
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
