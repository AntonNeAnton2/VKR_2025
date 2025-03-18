//
//  SelectionStepCellDataModel.swift
//  StoriesMaker
//
//  Created by Anton Mitrafanau on 12/09/2023.
//

import UIKit
import Combine

final class SelectionStepCellDataModel {
    
    var isSelectedPublisher: AnyPublisher<Bool, Never> {
        self.isSelectedSubject.eraseToAnyPublisher()
    }
    
    var isSelected: Bool {
        self.isSelectedSubject.value
    }
    
    let dataSource: SelectionStepCellDataSource
    private let isSelectedSubject = CurrentValueSubject<Bool, Never>(false)
    
    init(dataSource: SelectionStepCellDataSource) {
        self.dataSource = dataSource
    }
    
    func toggleSelection() {
        self.isSelectedSubject.send(!self.isSelectedSubject.value)
    }
}
