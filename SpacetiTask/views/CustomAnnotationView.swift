//
//  CustomAnnotationView.swift
//  SpacetiTask
//
//  Created by Radek Zmeskal on 05/06/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import UIKit
import Mapbox

class CustomAnnotationView: MGLAnnotationView {
    
    var label: UILabel = UILabel()
    
    var title:String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    init(reuseIdentifier: String?, title: String) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.title = title
        self.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.addCustomView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(title: String) {
        self.label.text = title
    }
    
    func addCustomView() {
        label.text = title
        label.textAlignment = .center
        label.textColor = UIColor.blue
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(label)
        
        let views = ["label": label]
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[label]|", options: .alignAllCenterY, metrics: nil, views: views)
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|[label]", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: views)
        self.addConstraints(horizontalConstraints)
        self.addConstraints(verticalConstraints)
        
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //        super.setSelected(selected, animated: animated)
    }
    
}
