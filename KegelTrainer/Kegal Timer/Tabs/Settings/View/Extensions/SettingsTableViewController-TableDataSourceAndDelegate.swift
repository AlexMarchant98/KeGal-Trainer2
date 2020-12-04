//
//  SettingsTableViewController-TableDataSourceAndDelegate.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 27/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import UIKit

extension SettingsTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = KTTableHeaderView()
        
        switch section {
        case 0:
            headerView.titleLabel.text = localizedString(forKey: "workout_settings")
        case 1:
            headerView.titleLabel.text = localizedString(forKey: "workout_cues")
        case 2:
            headerView.titleLabel.text = localizedString(forKey: "help")
        case 3:
            headerView.titleLabel.text = localizedString(forKey: "other")
        default:
            headerView.titleLabel.text = ""
        }
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = Fonts.subHeaderFont
        
        if(indexPath == Constants.removeAdvertsIndexPath) {
            if(adServer.areAdsDisabled) {
                cell.textLabel?.text = localizedString(forKey: "adverts_removed")
                cell.accessoryType = .checkmark
                cell.isUserInteractionEnabled = false
            } else {
                cell.textLabel?.text = localizedString(forKey: "remove_adverts")
                cell.isUserInteractionEnabled = true
                
                let chevron = UIImage(named: "chevron-right")
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = UIImageView(image: chevron!)
            }
        } else if(indexPath == Constants.emailIndexPath ||
                    indexPath == Constants.appWalkthroughIndexPath ||
                    indexPath == Constants.profileWalkthroughIndexPath) {
            let chevron = UIImage(named: "chevron-right")
            cell.accessoryType = .disclosureIndicator
            cell.accessoryView = UIImageView(image: chevron!)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case Constants.emailIndexPath:
            showEmail()
        case Constants.appWalkthroughIndexPath:
            settingsPresenter.showWalkthrough(walkthroughType: .appWalkthrough)
        case Constants.profileWalkthroughIndexPath:
            settingsPresenter.showWalkthrough(walkthroughType: .profileWalkthrough)
        case Constants.removeAdvertsIndexPath:
            settingsPresenter.getAdRemovalIAPInformation()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
