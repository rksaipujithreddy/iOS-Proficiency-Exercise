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
    
     lazy var viewCellBg: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        view.clipsToBounds = true
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = CGSize.zero
        view.layer.shadowRadius = 1
        view.layer.cornerRadius = 10
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.borderWidth = 1
        return view
    }()
     lazy var lblTitle: UILabel = {
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
     lazy var imgDisplay: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = UIColor.black
        img.contentMode = .scaleToFill // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        img.clipsToBounds = true
        return img
    }()
     lazy var lblDescription: UILabel = {
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
        
        let constantWH = (self.contentView.frame.size.width/4)
        
        
        viewCellBg.addSubview(imgDisplay)
        viewCellBg.addSubview(lblTitle)
        viewCellBg.addSubview(lblDescription)
        NSLayoutConstraint.activate([
            
            imgDisplay.heightAnchor.constraint(equalToConstant: constantWH),
            imgDisplay.leftAnchor.constraint(equalTo: viewCellBg.leftAnchor, constant:20 ),
            imgDisplay.centerYAnchor.constraint(equalTo:lblTitle.centerYAnchor)
        ])
        imageWidthAnchor =  imgDisplay.widthAnchor.constraint(equalToConstant: constantWH)
        imageWidthAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo:imgDisplay.trailingAnchor,constant: 8),
            lblTitle.topAnchor.constraint(equalTo:viewCellBg.topAnchor,constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo:viewCellBg.trailingAnchor),
            lblTitle.heightAnchor.constraint(equalToConstant:constantWH)
        ])
        
        
        
        NSLayoutConstraint.activate([
            lblDescription.topAnchor.constraint(equalTo:lblTitle.bottomAnchor,constant: 20),
            lblDescription.leadingAnchor.constraint(equalTo:viewCellBg.leadingAnchor,constant: 8),
            lblDescription.trailingAnchor.constraint(equalTo:viewCellBg.trailingAnchor,constant: -8),
            lblDescription.bottomAnchor.constraint(equalTo:viewCellBg.bottomAnchor,constant:-8)
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
        print(imgDisplay.image?.pngData())

    }
}
