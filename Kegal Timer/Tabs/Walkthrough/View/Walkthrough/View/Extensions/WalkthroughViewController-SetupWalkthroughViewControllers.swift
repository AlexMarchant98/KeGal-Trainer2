//
//  WalkthroughViewController-SetupWalkthroughViewControllers.swift
//  PTHub
//
//  Created by Alex Marchant on 20/10/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation

extension WalkthroughViewController {
    
    internal func setupWalkthroughViewControllers() {
        let trainerListVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        trainerListVc.setupScreenInformation(
            imageName: "trainers-list",
            stepTitle: "Get Discovered",
            stepDescription: "PTFinder will now show your profile in the list of trainers for every user within your local area.\n\nUsers can filter trainers based on their requirements; if your profile meets these filters, PTFinder will display it to the user. \n\nAs a trainer, you can only view other trainer profiles in the list; clients are not listed (at the moment).",
            delegate: self)
        
        let connectWithTrainerVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        connectWithTrainerVc.setupScreenInformation(
            imageName: "trainer-profile",
            stepTitle: "Create leads",
            stepDescription: "When PTFinder displays your profile in the list, a user can click it to view your full profile. \n\nYour profile is how you promote your services to clients, therefore, to generate as many new leads as possible, we recommend you keep your profile up-to-date with high-quality information and photos.\n\nIf a user likes your profile, they can connect with you to begin chatting in the app, or, they can use your provided contact information, if available, to contact you directly.",
            delegate: self)
        
        let chatsVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        chatsVc.setupScreenInformation(
            imageName: "chats",
            stepTitle: "Chat with others",
            stepDescription: "Once you have connected with another user, you can start chatting with them in the chats tab.\n\nYou can view their profile by opening the chat and clicking their name in the top bar.",
            delegate: self)
        
        let trainerProfileVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        trainerProfileVc.setupScreenInformation(
            imageName: "trainer-my-profile",
            stepTitle: "Update your profile",
            stepDescription: "If you want to update information on your profile, you can do so on the profile tab. Here you can see your profile as another user would see it when they view your profile from the list.\n\nYou can edit everything on your profile by using the provided edit button (pencil) in each section.",
            delegate: self)
        
        let shareProfileVc = WalkthroughPageViewController.instantiate(storyboard: "WalkthroughPage")
        
        shareProfileVc.setupScreenInformation(
            imageName: "share-profile",
            stepTitle: "Share your profile",
            stepDescription: "You can share a link to your profile so that anyone can view it, even if they don't have an account!\n\nTo do this, use the 'Share' button on the profile tab.",
            buttonText: "End Walkthrough",
            delegate: self)
        
        orderedWalkthroughSteps = [trainerListVc, connectWithTrainerVc, chatsVc, trainerProfileVc, shareProfileVc]
    }
    
}
