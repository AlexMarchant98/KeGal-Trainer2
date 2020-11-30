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
            headerView.titleLabel.text = "Workout Settings"
        case 1:
            headerView.titleLabel.text = "Workout Cues"
        case 2:
            headerView.titleLabel.text = "Help"
        case 3:
            headerView.titleLabel.text = "Other"
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
                cell.textLabel?.text = "Adverts Removed"
                cell.accessoryType = .checkmark
                cell.isUserInteractionEnabled = false
            } else {
                cell.textLabel?.text = "Remove Adverts"
                cell.isUserInteractionEnabled = true
                
                let chevron = UIImage(named: "chevron-right")
                cell.accessoryType = .disclosureIndicator
                cell.accessoryView = UIImageView(image: chevron!)
            }
        } else if(indexPath == Constants.emailIndexPath || indexPath == Constants.appWalkthroughIndexPath) {
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
            settingsPresenter.showWalkthrough()
        case Constants.removeAdvertsIndexPath:
            settingsPresenter.getAdRemovalIAPInformation()
        default:
            break
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
