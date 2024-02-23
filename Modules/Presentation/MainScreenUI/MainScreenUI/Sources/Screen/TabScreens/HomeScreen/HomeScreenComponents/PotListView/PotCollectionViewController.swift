//
//  PotCollectionViewController.swift
//  MainScreenUI
//
//  Created by 최준영 on 2/23/24.
//

import UIKit
import GlobalObjects

class PotCollectionViewController: UICollectionViewController {
    
    var availableWidth: CGFloat = 0.0
    let horizontalSpacingBetweenItems: CGFloat = 1.0
    let verticalSpacingBetweenItems: CGFloat = 1.0
    let itemCountForRow: Int = 2
    var thumbNailSize: CGSize!
    
    // 모델오브젝트
    var models: [PotModel]
    
    // 레이아웃
    let flowLayout = UICollectionViewFlowLayout()
    
    public init(models: [PotModel]) {
        
        self.models = models
        
        super.init(collectionViewLayout: self.flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PotCollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 재사용 Cell타입들을 등록
        collectionView?.register(PotListViewCell.self, forCellWithReuseIdentifier: String(describing: PotListViewCell.self))
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let withOfThisViewController = view.bounds.inset(by: view.safeAreaInsets).width
        
        if availableWidth != withOfThisViewController {
            
            availableWidth = withOfThisViewController - horizontalSpacingBetweenItems * CGFloat(itemCountForRow-1)
            
            let itemWidth = availableWidth / CGFloat(itemCountForRow)
            let itemHeight = itemWidth * 1.3
            
            flowLayout.minimumInteritemSpacing = horizontalSpacingBetweenItems
            flowLayout.minimumLineSpacing = verticalSpacingBetweenItems
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 화면 비율
        let scale = UIScreen.main.scale
        
        let cellSize = flowLayout.itemSize
        
        let tnWidth = cellSize.width * scale
        let tnHeight = cellSize.height * scale
        
        self.thumbNailSize = CGSize(width: tnWidth, height: tnHeight)
        
    }
}

extension PotCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return self.models.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cellIdentifier = String(describing: PotListViewCell.self)
        
        guard let reusableCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? PotListViewCell else {
            
            fatalError("PotListViewCell")
        }
        
        reusableCell.model = models[indexPath.item]
        
        return reusableCell
    }
}
