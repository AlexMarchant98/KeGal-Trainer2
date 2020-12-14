//
//  EarnPointsView.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 14/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import UIKit

protocol EarnPointsViewDelegate {
    func showAdvert()
    func ratedApp()
    func reviewedApp()
}

class EarnPointsView: UIView {
    
    @IBOutlet var view: UIView!
    @IBOutlet weak var earnPointsHeader: KTHeader!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var watchAdvertButton: KTSecondaryButton!
    @IBOutlet weak var rateAppButton: KTSecondaryButton!
    @IBOutlet weak var reviewAppButton: KTSecondaryButton!
    
    var delegate: EarnPointsViewDelegate?
    
    var model: EarnPointsViewModel? {
        didSet {
            
            guard let model = model else {
                return
            }
            
            delegate = model.delegate
            
            self.watchAdvertButton.isEnabled = true
            self.rateAppButton.isEnabled = true
            self.reviewAppButton.isEnabled = true
            
            loadingIndicator.isHidden = true
            loadingIndicator.stopAnimating()
            
            if(model.hasRatedApp) {
                self.rateAppButton.setTitle(localizedString(forKey: "app_rated"), for: .normal)
                self.rateAppButton.setBackgroundColor(.appGreen)
                self.rateAppButton.isUserInteractionEnabled = false
                self.rateAppButton.setTitleColor(.backgroundColour, for: .normal)
            }
            
            if(model.hasReviewedApp) {
                self.reviewAppButton.setTitle(localizedString(forKey: "app_reviewed"), for: .normal)
                self.reviewAppButton.setBackgroundColor(.appGreen)
                self.reviewAppButton.isUserInteractionEnabled = false
                self.reviewAppButton.setTitleColor(.backgroundColour, for: .normal)
            }
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.backgroundColour
        
        let name = String(describing: type(of: self))
        
        Bundle.main.loadNibNamed(name, owner: self, options: nil)
        
        self.addSubview(self.view)
        
        self.view.frame = self.bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupView()
    }
    
    func setupView() {
        self.view.backgroundColor = UIColor.backgroundColour
        
        self.earnPointsHeader.textColor = .appGreen
        
        self.watchAdvertButton.titleLabel?.numberOfLines = 0
        self.rateAppButton.titleLabel?.numberOfLines = 0
        self.reviewAppButton.titleLabel?.numberOfLines = 0
        
        self.watchAdvertButton.setTitle(localizedString(forKey: "watch_an_advert"), for: .normal)
        self.rateAppButton.setTitle(localizedString(forKey: "rate_the_app"), for: .normal)
        self.reviewAppButton.setTitle(localizedString(forKey: "review_the_app"), for: .normal)
        
        self.watchAdvertButton.titleLabel?.textAlignment = .center
        self.rateAppButton.titleLabel?.textAlignment = .center
        self.reviewAppButton.titleLabel?.textAlignment = .center
        
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
        loadingIndicator.color = .white
    }
    
    @IBAction func watchAdvertButtonTapped(_ sender: Any) {
        self.delegate?.showAdvert()
    }
    
    func showRatingLoading() {
        self.rateAppButton.setTitle(localizedString(forKey: "sending_rating"), for: .normal)
        self.rateAppButton.isEnabled = false
        
        self.watchAdvertButton.isEnabled = false
        self.reviewAppButton.isEnabled = false
        
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    @IBAction func rateAppButtonTapped(_ sender: Any) {
        RequestReview.requestReview(forceReview: true)
        
        showRatingLoading()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(25), execute: {
            self.delegate?.ratedApp()
        })
        
    }
    
    @IBAction func reviewAppButtonTapped(_ sender: Any) {
        self.delegate?.reviewedApp()
        RequestReview.requestWrittenReview()
    }


}
