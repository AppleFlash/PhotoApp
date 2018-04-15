//
//  NoResultsView.swift
//  PhotoApp
//
//  Created by Vladislav Sedinkin on 16.04.18.
//  Copyright © 2018 Vlad. All rights reserved.
//

import UIKit

class NoResultsView: UIView {

    private var noResultLabel: UILabel
    
    init() {
        noResultLabel = UILabel()
        noResultLabel.text = "No results..."
        noResultLabel.textAlignment = .center
        
        super.init(frame: .zero)
        
        addSubview(noResultLabel)
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let edgeMargin: CGFloat = 16
        noResultLabel.topAnchor.constraint(equalTo: topAnchor, constant: edgeMargin).isActive = true
        noResultLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: edgeMargin).isActive = true
        noResultLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: edgeMargin).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
