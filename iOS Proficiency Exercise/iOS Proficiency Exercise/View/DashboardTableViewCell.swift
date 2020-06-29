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
    var titleHeightAnchor:NSLayoutConstraint!
    
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
        label.font = UIFont.boldSystemFont(ofSize:CGFloat(Constants.ConfigurationItems.txtSize))
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
        img.backgroundColor = UIColor.clear
        img.contentMode = .scaleAspectFit // without this your image will shrink and looks ugly
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
                
        viewCellBg.addSubview(imgDisplay)
        viewCellBg.addSubview(lblTitle)
        viewCellBg.addSubview(lblDescription)
        NSLayoutConstraint.activate([
            
            imgDisplay.leftAnchor.constraint(equalTo: viewCellBg.leftAnchor, constant:20 ),
            imgDisplay.topAnchor.constraint(equalTo:viewCellBg.topAnchor,constant: 10),
            
        ])
        self.imageWidthAnchor =  self.imgDisplay.widthAnchor.constraint(equalToConstant: CGFloat(Constants.ConfigurationItems.constant))
        self.imageWidthAnchor.isActive = true
        self.imageHeightAnchor =  self.imgDisplay.heightAnchor.constraint(equalToConstant: CGFloat(Constants.ConfigurationItems.constant))
        self.imageHeightAnchor.isActive = true
        
        NSLayoutConstraint.activate([
            lblTitle.leadingAnchor.constraint(equalTo:imgDisplay.trailingAnchor,constant:-10),
            lblTitle.topAnchor.constraint(equalTo:viewCellBg.topAnchor,constant: 10),
            lblTitle.trailingAnchor.constraint(equalTo:viewCellBg.trailingAnchor),
lblTitle.heightAnchor.constraint(equalToConstant:CGFloat(Constants.ConfigurationItems.constant))
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
        imageWidthAnchor.isActive  = false
        imageHeightAnchor.isActive = false
        
        if(!viewModel.imageURL.isEmpty){
            imgDisplay.loadImageUsingCacheWithURLString(viewModel.imageURL, placeHolder: nil) { (bool) in
                if(bool){
                    self.updateContraintsWith(constant: CGFloat(Constants.ConfigurationItems.constant))
                }else{
                    self.updateContraintsWith(constant: 0)
                }
            }
        }
        else{
            self.updateContraintsWith(constant: 0)
        }
    }
    
    func updateContraintsWith(constant :CGFloat)  {
        DispatchQueue.main.async {
            self.imageWidthAnchor =  self.imgDisplay.widthAnchor.constraint(equalToConstant: constant)
            self.imageWidthAnchor.isActive = true
            self.imageHeightAnchor =  self.imgDisplay.heightAnchor.constraint(equalToConstant: constant)
            self.imageHeightAnchor.isActive = true
        }
    }
    
}
