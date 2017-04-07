//
//  DeviceManagementVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/4/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceManagementVC: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let itemWidth = (UIScreen.main.bounds.size.width - 24.0) / 2.0
        let itemHeight = itemWidth * 13.0 / 9.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        flowLayout.minimumLineSpacing = 8.0
        flowLayout.minimumInteritemSpacing = 1.0
        flowLayout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    }
    
}

extension DeviceManagementVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCellId",
            for: indexPath)
        return cell
    }
    
}

