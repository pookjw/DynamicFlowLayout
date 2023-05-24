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
    private var viewModel: ViewModel!
    private var task: Task<Void, Never>?
    
    deinit {
        task?.cancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = .init()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        
        let collectionView: UICollectionView = .init(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .systemBackground
        collectionView.contentInsetAdjustmentBehavior = .always
        
        let cellRegistration: UICollectionView.CellRegistration<DynamicCollectionViewCell, String> = .init { cell, indexPath, itemIdentifier in
            let contentConfiguration: ContentConfiguration = .init(text: itemIdentifier)
            cell.contentConfiguration = contentConfiguration
            
            cell.configurationUpdateHandler = { cell, state in
                var backgroundConfiguration: UIBackgroundConfiguration = .clear()
                backgroundConfiguration.backgroundColor = (state.isSelected || state.isHighlighted) ? .systemPurple : .systemPurple.withAlphaComponent(0.1)
                cell.backgroundConfiguration = backgroundConfiguration
            }
        }
        
        let dataSource: UICollectionViewDiffableDataSource<Int, String> = .init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            let cell: UICollectionViewCell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            return cell
        }
        
        let viewModel: ViewModel = .init(dataSource: dataSource)
        
        view.addSubview(collectionView)
        
        self.collectionView = collectionView
        self.viewModel = viewModel
        
        task = .detached { [viewModel] in
            await viewModel.loadDataSource()
        }
    }
}
