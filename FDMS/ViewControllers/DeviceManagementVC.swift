//
//  DeviceManagementVC.swift
//  FDMS
//
//  Created by Nguyen Quoc Tinh on 4/4/17.
//  Copyright © 2017 Framgia. All rights reserved.
//

import UIKit

class DeviceManagementVC: UIViewController {

    @IBOutlet weak fileprivate var deviceCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deviceCollectionView.contentInset = UIEdgeInsets(top: 10, left: 7, bottom: 25, right: 7)
    }
    
}

extension DeviceManagementVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, 
                        numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, 
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = deviceCollectionView.dequeueReusableCell(withReuseIdentifier: "DeviceCellId", 
            for: indexPath)
        return cell
    }
    
}

