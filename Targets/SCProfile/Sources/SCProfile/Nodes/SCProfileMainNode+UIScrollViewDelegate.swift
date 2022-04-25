//
//  SCProfileMainNode+UIScrollViewDelegate.swift
//  SCProfile
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import UIKit

extension SCProfileMainNode: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        delegate?.scrollViewDidScroll(scrollView)

        if skills != nil {
            skillsNode.selectedPieNodes = nil
            skillsNode.selectedTitleIndex = nil
        }
    }
}
