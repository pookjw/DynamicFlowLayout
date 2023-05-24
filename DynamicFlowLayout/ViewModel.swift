//
//  ViewModel.swift
//  DynamicFlowLayout
//
//  Created by Jinwoo Kim on 5/25/23.
//

import UIKit

actor ViewModel {
    private let dataSource: UICollectionViewDiffableDataSource<Int, String>
    
    
    init(dataSource: UICollectionViewDiffableDataSource<Int, String>) {
        self.dataSource = dataSource
    }
    
    func loadDataSource() async {
        var snapshot: NSDiffableDataSourceSnapshot<Int, String> = .init()
        snapshot.appendSections([.zero])
        snapshot.appendItems(["💁🏻‍♀️", "🐣", "🐥", "🐤"], toSection: .zero)
        await dataSource.apply(snapshot)
    }
}
