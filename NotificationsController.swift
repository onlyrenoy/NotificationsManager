//
//  NotificationsController.swift
//  BaseProject
//
//  Created by Renoy Chowdhury on 27/09/24.
//

import Foundation
import UIKit
import Stevia

class NotificationCell: UICollectionViewCell {
    var title = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .green
        
        subviews(title)
        
        title.centerInContainer()
        
    }
    
    func config(title : String) {
        self.title.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class NotificationsController: UIViewController {
    var collection: UICollectionView!
    
    var notifications = NotificationCounter.shared.notifications
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notifications.reverse()
        
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.scrollDirection = .vertical
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 10
        collection = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        collection.showsVerticalScrollIndicator = false
        
        collection.register(NotificationCell.self,
                            forCellWithReuseIdentifier: "NotificationCell")
        
        collection.delegate = self
        collection.dataSource = self
        
        view.subviews(collection)
        view.layout(
            40,
            |-0-collection-0-|,
            0
        )
    }
}

extension NotificationsController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension NotificationsController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        notifications.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.config(title: notifications[indexPath.row]["title"] as! String)
        return cell
    }
}

extension NotificationsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: 80)
    }
}

