//
//  SelectionStepCellDataSource.swift
//  StoriesMaker
//
//  Created by Anton Poklonsky on 15/09/2024.
//

import UIKit

protocol SelectionStepCellDataSource {
    
    var id: Int { get }
    var selectionStepCellImage: UIImage { get }
    var selectionStepCellText: String? { get }
    var shouldShowFrame: Bool { get }
    var imageScaleMultiplier: CGFloat { get }
}
