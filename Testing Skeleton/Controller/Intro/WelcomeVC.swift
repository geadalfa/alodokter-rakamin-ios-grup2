//
//  WelcomeVC.swift
//  Testing Skeleton
//
//  Created by Prince Alvin Yusuf on 08/12/21.
//

import UIKit

class WelcomeVC: UIViewController, UIScrollViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageOneImageView: UIImageView!
    @IBOutlet weak var pageTwoImageView: UIImageView!
    @IBOutlet weak var pageThreeImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    
    let filledImage = UIImage(named: "oval")
    let unFilledImage = UIImage(named: "oval_")
    
    var selectedIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        let slides = createSlides()
        setupScrollView(slides)
        
    }
    
    func createSlides() ->[SlideView]{
        
        let slide1 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide1.welcomeImage.image = UIImage(named: "illustrateOne")
        slide1.underImageLabel.text = "Cari Dokter Dengan Mudah"
        slide1.descriptionLabel.text = "Cari Dokter Sesuai Preferensimu Kini Bisa dilakukan secara instan"
        
        let slide2 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide2.welcomeImage.image = UIImage(named: "illustrateTwo")
        slide2.underImageLabel.text = "Konsultasi Cepat"
        slide2.descriptionLabel.text = "Temukan Doktermu dan jadwalkan konsultasimu"
        
        let slide3 = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! SlideView
        slide3.welcomeImage.image = UIImage(named: "illustrateThree")
        slide3.underImageLabel.text = "Beragam Artikel Kesehatan"
        slide3.descriptionLabel.text = "Tingkatkan pengetahuanmu dengan beragam artikel kesehatan yang bermanfaat"
        
        return [slide1, slide2, slide3]
    }
    
    func setupScrollView(_ slides: [SlideView]){
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: scrollView.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: 1.0)
        scrollView.isPagingEnabled = true
        
        for each in 0..<slides.count{
            slides[each].frame = CGRect(x: view.frame.width * CGFloat(each), y: 0, width: view.frame.width, height: scrollView.frame.height)
            scrollView.addSubview(slides[each])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/scrollView.frame.width)
        if pageIndex == 0{
            
        }else{
            
        }
        
        if pageIndex == 2{
            
            startButton.isHidden = false
        }else{
            
            startButton.isHidden = true
        }
        
        if pageIndex == 0{
            selectedIndex = 0
            pageOneImageView.image = filledImage
            
            pageTwoImageView.image = unFilledImage
            pageThreeImageView.image = unFilledImage
        }else if pageIndex == 1{
            selectedIndex = 1
            pageTwoImageView.image = filledImage
            
            pageOneImageView.image = unFilledImage
            pageThreeImageView.image = unFilledImage
        }else if pageIndex == 2{
            selectedIndex = 2
            pageThreeImageView.image = filledImage
            
            pageOneImageView.image = unFilledImage
            pageTwoImageView.image = unFilledImage
        }else if pageIndex == 3{
            selectedIndex = 3
            
            pageOneImageView.image = unFilledImage
            pageTwoImageView.image = unFilledImage
            pageThreeImageView.image = unFilledImage
        }
    }
    
    
    @IBAction func startPressed(_ sender: UIButton) {
        UserDefaultService.instance.isFirstLaunched = true
        
    }
    
}

