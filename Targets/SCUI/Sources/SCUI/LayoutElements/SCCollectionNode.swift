//
//  SCCollectionNode.swift
//
//
//  Created by Nikita Arutyunov on 02.01.2022.
//

import AsyncDisplayKit
import DifferenceKit
import UIKit

open class SCCollectionNode: ASCollectionNode, SCElement, UIScrollViewDelegate {

    // MARK: - Shimmer

    open var isShimmering = false {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                guard let self = self else { return }

                self.view.isUserInteractionEnabled = !self.isShimmering

                self.setContentOffset(.zero, animated: false)

                UIView.transition(
                    with: self.view,
                    duration: 0.24,
                    options: [
                        .beginFromCurrentState,
                        .transitionCrossDissolve,
                    ]
                ) { [weak self] in
                    self?.reloadData()
                } completion: { [weak self] _ in

                }
            }
        }
    }

    // MARK: - Content Inset

    var storedContentInset = UIEdgeInsets.zero

    open var needsUpdateHeightToFit = true

    open override var contentInset: UIEdgeInsets {
        willSet {
            storedContentInset = newValue
        }
    }

    // MARK: - Automatically Manages Height

    open var automaticallyManagesHeightToFitContent = false {
        didSet {
            ASPerformBlockOnMainThread { [weak self] in
                guard let self = self else { return }

                self.view.isScrollEnabled = !self.automaticallyManagesHeightToFitContent
            }
        }
    }

    open override func layoutDidFinish() {
        defer {
            super.layoutDidFinish()
        }

        guard automaticallyManagesHeightToFitContent else { return }

        ASPerformBlockOnMainThread { [weak self, shouldAnimateSizeChanges] in
            guard let self = self else { return }

            let contentHeight = self.collectionViewLayout.collectionViewContentSize.height

            guard
                self.needsUpdateHeightToFit
                    || contentHeight > self.style.height.value
            else { return }

            self.needsUpdateHeightToFit = false

            let fullContentHeight = contentHeight + self.contentInset.top + self.contentInset.bottom

            self.style.height = .points(fullContentHeight)

            self.transitionLayout(
                with: ASSizeRange(
                    min: CGSize(
                        width: self.constrainedSizeForCalculatedLayout.min.width,
                        height: fullContentHeight
                    ),
                    max: CGSize(
                        width: self.constrainedSizeForCalculatedLayout.max.width,
                        height: fullContentHeight
                    )
                ),
                animated: shouldAnimateSizeChanges,
                shouldMeasureAsync: false
            ) {
                self.supernode?.setNeedsLayout()
            }

            //            guard self.calculatedSize.height > 0 else {
            //                return self.setNeedsLayout()
            //            }
        }
    }

    // MARK: - Batch

    open var batchDirections: [ASScrollDirection] {
        [.down]
    }

    open var isFirstPageLoaded = false
    open var isLastPageLoaded = false

    open func shouldBatchFetch(with scrollDirection: ASScrollDirection) -> Bool {
        let isBatchDirection = batchDirections.contains(scrollDirection)

        let shouldBatchFetch = isBatchDirection && isFirstPageLoaded && !isLastPageLoaded

        return shouldBatchFetch
    }

    open func updateBatchParameters(isFirstPageLoaded: Bool, isLastPageLoaded: Bool) {
        if isFirstPageLoaded {
            self.isFirstPageLoaded = isFirstPageLoaded
        }

        self.isLastPageLoaded = isLastPageLoaded
    }

    // MARK: - Diffable

    open var diffableDelegate: SCCollectionDiffable?

    open var modelsHashes: [ArraySection<Int, Int>] {
        let arraySections = (0..<max(1, numberOfSections))
            .map { section -> ArraySection<Int, Int> in
                let hashes = (0..<numberOfItems(inSection: section))
                    .compactMap { item -> Int? in
                        let indexPath = IndexPath(item: item, section: section)

                        guard let node = nodeForItem(at: indexPath) as? SCCellNode else {
                            return nil
                        }

                        return node.modelHash
                    }

                return ArraySection(model: section, elements: hashes)
            }

        return arraySections
    }

    open func reloadDiffable() async -> Bool {
        needsUpdateHeightToFit = true

        guard let updatedModelsHashes = diffableDelegate?.modelsHashes(in: self) else {
            return false
        }

        let stagedChangeset = StagedChangeset(
            source: modelsHashes,
            target: updatedModelsHashes
        )

        guard stagedChangeset.count > 0 else {
            return true
        }

        await withTaskGroup(of: Bool.self) { [weak self] taskGroup in
            guard let self = self else { return }

            for changeset in stagedChangeset {
                taskGroup.addTask(priority: .userInitiated) {
                    await self.performBatchUpdates {
                        Task {
                            if !changeset.sectionDeleted.isEmpty {
                                await self.deleteSections(IndexSet(changeset.sectionDeleted))
                            }

                            if !changeset.sectionInserted.isEmpty {
                                await self.insertSections(IndexSet(changeset.sectionInserted))
                            }

                            if !changeset.sectionUpdated.isEmpty {
                                await self.reloadSections(IndexSet(changeset.sectionUpdated))
                            }

                            for (source, target) in changeset.sectionMoved {
                                await self.moveSection(source, toSection: target)
                            }

                            if !changeset.elementDeleted.isEmpty {
                                await self.deleteItems(
                                    at: changeset.elementDeleted.map {
                                        IndexPath(item: $0.element, section: $0.section)
                                    }
                                )
                            }

                            if !changeset.elementInserted.isEmpty {
                                await self.insertItems(
                                    at: changeset.elementInserted.map {
                                        IndexPath(item: $0.element, section: $0.section)
                                    }
                                )
                            }

                            if !changeset.elementUpdated.isEmpty {
                                await self.reloadItems(
                                    at: changeset.elementUpdated.map {
                                        IndexPath(item: $0.element, section: $0.section)
                                    }
                                )
                            }

                            for (source, target) in changeset.elementMoved {
                                await self.moveItem(
                                    at: IndexPath(item: source.element, section: source.section),
                                    to: IndexPath(item: target.element, section: target.section)
                                )
                            }
                        }
                    }
                }
            }
        }

        return true
    }

    // MARK: - Initialization

    public required override init(
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(collectionViewLayout: layout)
    }

    public override init(
        frame: CGRect,
        collectionViewLayout layout: UICollectionViewLayout
    ) {
        super.init(frame: frame, collectionViewLayout: layout)
    }

    public override init(
        frame: CGRect,
        collectionViewLayout: UICollectionViewLayout,
        layoutFacilitator: ASCollectionViewLayoutFacilitatorProtocol?
    ) {
        super
            .init(
                frame: frame,
                collectionViewLayout: collectionViewLayout,
                layoutFacilitator: layoutFacilitator
            )
    }

    public override init(
        layoutDelegate: ASCollectionLayoutDelegate,
        layoutFacilitator: ASCollectionViewLayoutFacilitatorProtocol? = nil
    ) {
        super.init(layoutDelegate: layoutDelegate, layoutFacilitator: layoutFacilitator)
    }

    // MARK: - Reload Data

    open func reloadData(animated: Bool = false, completion: (() -> Void)? = nil) {
        needsUpdateHeightToFit = true

        if animated {
            performBatch(animated: true) { [weak self] in
                let sections = IndexSet(0..<(self?.numberOfSections ?? 0))

                self?.reloadSections(sections)
            } completion: { _ in
                completion?()
            }
        } else {
            reloadData(completion: completion)
        }
    }

    // MARK: - Automatically Hide Keyboard

    open var automaticallyHideKeyboardOnScroll = true

    open func scrollViewDidScroll(_: UIScrollView) {
        guard automaticallyHideKeyboardOnScroll else { return }

        ASPerformBlockOnMainThread { [weak self] in
            guard let self = self else { return }

            self.view.endEditing(false)
        }
    }

    open func moveItems(at indexPaths: [(IndexPath, IndexPath)]) {
        indexPaths.forEach { [moveItem] in
            moveItem($0.0, $0.1)
        }
    }
}
