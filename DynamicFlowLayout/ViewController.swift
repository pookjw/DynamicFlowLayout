//
//  ViewController.swift
//  DynamicFlowLayout
//
//  Created by Jinwoo Kim on 5/24/23.
//

import UIKit

@MainActor
final class ViewController: UIViewController {
    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Int, String>!
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.delegate = self
        
        let cellRegistration: UICollectionView.CellRegistration<DynamicCollectionViewCell, String> = .init { cell, indexPath, itemIdentifier in
            let contentConfiguration: ContentConfiguration = .init(text: itemIdentifier)
            cell.contentConfiguration = contentConfiguration
            
            cell.configurationUpdateHandler = { cell, state in
                var backgroundConfiguration: UIBackgroundConfiguration = .clear()
                backgroundConfiguration.backgroundColor = (state.isSelected || state.isHighlighted) ? .secondarySystemBackground : .clear
                cell.backgroundConfiguration = backgroundConfiguration
            }
        }
        
        let dataSource: UICollectionViewDiffableDataSource<Int, String> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        self.dataSource = dataSource
        
        Task.detached { [dataSource] in
            var snapshot: NSDiffableDataSourceSnapshot<Int, String> = .init()
            snapshot.appendSections([.zero])
            snapshot.appendItems(["💁🏻‍♀️", "🐣", "🐥", "🐤"], toSection: .zero)
            await dataSource.apply(snapshot)
        }
    }
}

extension ViewController: UICollectionViewDelegate {
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
}
