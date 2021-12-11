//
//  IllustrateLogin2.swift
//  Alodokter
//
//  Created by Geadalfa Giyanda on 11/12/21.
//

import UIKit

class IlustrateImage2 {
    
    func getImage(view: UIView) {
        let illustrationImage = UIImage(named: "unlockPic.png")
        
        let myImageView:UIImageView = UIImageView()
        myImageView.contentMode = UIView.ContentMode.scaleAspectFit
        myImageView.frame.size.width = 300
        myImageView.frame.size.height = 300
        myImageView.image = illustrationImage
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        label.font = UIFont.boldSystemFont(ofSize: 16.0)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Harap login dahulu untuk menikmati fitur ini"

        //imageview constraint
        view.addSubview(myImageView)
        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        myImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        myImageView.widthAnchor.constraint(equalToConstant: 300 ).isActive = true
        myImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        //label constraint
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: myImageView.bottomAnchor, constant: 20).isActive = true
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

}
