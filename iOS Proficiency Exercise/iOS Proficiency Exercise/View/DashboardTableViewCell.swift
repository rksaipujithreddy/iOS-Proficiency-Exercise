//
//  DashboardTableViewCell.swift
//  iOS Proficiency Exercise
//
//  Created by Saipujith on 26/06/20.
//  Copyright © 2020 Saipujith. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    var imageWidthAnchor:NSLayoutConstraint!
    var imageHeightAnchor:NSLayoutConstraint!

    let viewCellBg: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1
        view.layer.cornerRadius = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
    let lblTitle: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.backgroundColor =  UIColor.clear
        label.textAlignment = .center
        label.textColor =  UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let imgDisplay: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
    let lblDescription: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byWordWrapping // or NSLineBreakMode.ByWordWrapping
        label.numberOfLines = 0
        label.textColor =  #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        label.backgroundColor =  UIColor.clear
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(viewCellBg)
        
        NSLayoutConstraint.activate([
        viewCellBg.topAnchor.constraint(equalTo:self.contentView.topAnchor,constant: 8),
        viewCellBg.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor,constant: 8),
        viewCellBg.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor,constant: -8),
        viewCellBg.bottomAnchor.constraint(equalTo:self.contentView.bottomAnchor,constant: -8)
            ])
        
            viewCellBg.addSubview(imgDisplay)
                NSLayoutConstraint.activate([
                imgDisplay.topAnchor.constraint(equalTo:viewCellBg.topAnchor),
                imgDisplay.leadingAnchor.constraint(equalTo:viewCellBg.leadingAnchor),
                ])
        imageWidthAnchor = imgDisplay.widthAnchor.constraint(equalToConstant:100)
        imageWidthAnchor.isActive = true
        imageHeightAnchor = imgDisplay.heightAnchor.constraint(equalToConstant:100)
        imageHeightAnchor.isActive = true
        
        
        viewCellBg.addSubview(lblTitle)
        NSLayoutConstraint.activate([
        lblTitle.topAnchor.constraint(equalTo:viewCellBg.topAnchor),
        lblTitle.leadingAnchor.constraint(equalTo:imgDisplay.trailingAnchor),
        lblTitle.trailingAnchor.constraint(equalTo:viewCellBg.trailingAnchor),
        lblTitle.heightAnchor.constraint(equalToConstant:100)
            ])
        

        viewCellBg.addSubview(lblDescription)
        NSLayoutConstraint.activate([
        lblDescription.topAnchor.constraint(equalTo:lblTitle.bottomAnchor,constant: 0),
    lblDescription.leadingAnchor.constraint(equalTo:viewCellBg.leadingAnchor,constant: 8),
        lblDescription.trailingAnchor.constraint(equalTo:viewCellBg.trailingAnchor,constant: -8),
        lblDescription.bottomAnchor.constraint(equalTo:viewCellBg.bottomAnchor,constant: -8)
        ])

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    func  displayDataInCell(using viewModel: DashboardViewModel) {
    lblTitle.text = viewModel.title
    lblDescription.text = viewModel.description
  
    imgDisplay.loadImageUsingCacheWithURLString(viewModel.imageURL, placeHolder: nil) { (bool) in
        //perform actions if needed
    }
        if(viewModel.imageURL.isEmpty){
            imageWidthAnchor = imgDisplay.widthAnchor.constraint(equalToConstant:0)
            imageHeightAnchor = imgDisplay.heightAnchor.constraint(equalToConstant:0)
            imageWidthAnchor.isActive = true
            imageHeightAnchor.isActive = true

        }else
        {
              imageWidthAnchor = imgDisplay.widthAnchor.constraint(equalToConstant:100)
              imageWidthAnchor.isActive = true
              imageHeightAnchor = imgDisplay.heightAnchor.constraint(equalToConstant:100)
              imageHeightAnchor.isActive = true
        }
    }
}
