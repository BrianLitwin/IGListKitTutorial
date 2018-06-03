//
//  FeedViewController.swift
//  Marslink
//
//  Created by B_Litwin on 6/3/18.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import IGListKit
import UIKit

class FeedViewController: UIViewController {
    
    let pathfinder = Pathfinder()
    let loader = JournalEntryLoader()
    let wxScanner = WxScanner()
    
    lazy var adapter: IGListAdapter = {
       return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    let collectionView: IGListCollectionView = {
        let view = IGListCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .black
        return view
    }()
    
    override func viewDidLoad() {
        loader.loadLatest()
        view.addSubview(collectionView)
        adapter.collectionView = collectionView
        adapter.dataSource = self
        pathfinder.delegate = self
        pathfinder.connect()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension FeedViewController: IGListAdapterDataSource {
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        var items: [IGListDiffable] = [wxScanner.currentWeather]
        items += pathfinder.messages as [IGListDiffable]
        items += loader.entries as [IGListDiffable]
        return items.sorted(by: { (left: Any, right: Any) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date > right.date
            }
            return false
        })
    }
    
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        if object is Message {
            return MessageSectionController()
        } else if object is JournalEntry {
            return JournalSectionController()
        } else {
            return WeatherSectionController()
        }
    }
    
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
}
extension FeedViewController: PathfinderDelegate {
    func pathfinderDidUpdateMessages(pathfinder: Pathfinder) {
        adapter.performUpdates(animated: true)
    }
}
