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
    }
    
    static func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { sectionNumber, env in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1),
                                                                heightDimension: .fractionalHeight(1)))
            
            item.contentInsets.leading  = 16
            item.contentInsets.trailing = 16
            item.contentInsets.bottom   = 16
            
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize: .init(widthDimension: .fractionalWidth(1),
                                  heightDimension: .absolute(200)),
                subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }


    // MARK: UICollectionViewDataSource
 
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        cell.backgroundColor = .red
        // Configure the cell
    
        return cell
    }

    

}
