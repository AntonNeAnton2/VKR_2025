//
//  SelectionStepCollectionAdapter.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 12/09/2023.
//

import UIKit

final class SelectionStepCollectionAdapter: NSObject {
        
    var config: SelectionStep.Models.Configuration? {
        didSet {
            self.collectionView.reloadData()
            self.config?.onCustomCharactersChange = { [weak self] in
                self?.collectionView.reloadData()
            }
        }
    }
    
    private let collectionView: UICollectionView
    private let onCellTap: (Int) -> Void
    private let onSelectRandomTap: () -> Void
    private let onAddCharacter: () -> Void
    private let onRemoveCharacter: (CustomCharacter) -> Void
    
    private var customCharactersCount: Int {
        self.config?.customCharacters.count ?? 0
    }
    
    private var cellDataModelsCount: Int {
        self.config?.cellDataModels.count ?? 0
    }
    
    init(
        collectionView: UICollectionView,
        onCellTap: @escaping (Int) -> Void,
        onSelectRandomTap: @escaping () -> Void,
        onAddCharacter: @escaping () -> Void,
        onRemoveCharacter: @escaping (CustomCharacter) -> Void
    ) {
        self.collectionView = collectionView
        self.onCellTap = onCellTap
        self.onSelectRandomTap = onSelectRandomTap
        self.onAddCharacter = onAddCharacter
        self.onRemoveCharacter = onRemoveCharacter
        super.init()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let nib = UINib(nibName: SelectionItemCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(nib, forCellWithReuseIdentifier: SelectionItemCollectionViewCell.reuseIdentifier)
        let selectRandomNib = UINib(nibName: SelectionRandomCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(selectRandomNib, forCellWithReuseIdentifier: SelectionRandomCollectionViewCell.reuseIdentifier)
        let customCharacterNib = UINib(nibName: CustomCharacterCollectionViewCell.nibName, bundle: nil)
        self.collectionView.register(customCharacterNib, forCellWithReuseIdentifier: CustomCharacterCollectionViewCell.reuseIdentifier)
        self.collectionView.register(
            AddCharacterCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: AddCharacterCollectionReusableView.reuseIdentifier
        )
    }
}

// MARK: - UICollectionViewDataSource
extension SelectionStepCollectionAdapter: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
    ) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: AddCharacterCollectionReusableView.reuseIdentifier,
            for: indexPath
        ) as? AddCharacterCollectionReusableView else {
            fatalError("Add character view could not be dequeued")
        }
        view.onAddCharacter = { [weak self] in
            self?.onAddCharacter()
        }
        return view
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        1 + self.customCharactersCount + self.cellDataModelsCount
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {        
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectionRandomCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? SelectionRandomCollectionViewCell else {
                fatalError("Random selection cell could not be dequeued")
            }
            cell.step = self.config?.step
            return cell
        } else if indexPath.item - 1 - self.customCharactersCount < 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CustomCharacterCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? CustomCharacterCollectionViewCell else {
                fatalError("Custom character cell could not be dequeued")
            }
            cell.customCharacter = self.config?.customCharacters[indexPath.item - 1]
            cell.onRemoveCustomCharacter = { [weak self] character in
                self?.onRemoveCharacter(character)
            }
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: SelectionItemCollectionViewCell.reuseIdentifier,
                for: indexPath
            ) as? SelectionItemCollectionViewCell else {
                fatalError("Cell could not be dequeued")
            }
            cell.dataModel = self.config?.cellDataModels[indexPath.item - 1 - self.customCharactersCount]
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension SelectionStepCollectionAdapter: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        guard let step = self.config?.step else { return .zero }
        switch step {
        case .characters:
            return CGSize(width: 0, height: 80)
        default:
            return .zero
        }
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        var size: CGSize = .zero
        switch self.config?.step {
            // TODO: Probably will be added in the future
//        case .universe:
//            let width = SelectionItemCollectionViewCell.imageWidth
//            let height = width + 10
//            size = .init(width: width, height: height)
        default:
            let width = SelectionItemCollectionViewCell.imageWidth
            let height = width + 40
            size = .init(width: width, height: height)
        }
        return size
    }
}

// MARK: - UICollectionViewDelegate
extension SelectionStepCollectionAdapter: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.impactFeedbackGenerator.impactOccurred()
        collectionView.deselectItem(at: indexPath, animated: false)
        if indexPath.item == 0 {
            self.onSelectRandomTap()
        } else if indexPath.item - 1 - self.customCharactersCount < 0 {
            return
        } else {
            self.onCellTap(indexPath.item - 1 - self.customCharactersCount)
        }
    }
}
