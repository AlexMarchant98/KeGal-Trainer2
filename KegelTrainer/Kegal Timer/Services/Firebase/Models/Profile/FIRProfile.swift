//
//  FIRProfile.swift
//  Kegal Timer
//
//  Created by Alex Marchant on 13/11/2020.
//  Copyright © 2020 Alex Marchant. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct FIRProfile: Equatable, Codable, FIRIdentifiable {
    
    var id: String? = nil
    
    var owner_uid: String
    var username: String
    
    var workout_days_streak: Int = 0
    var daily_points: Int = 0
    var streak_protectors: Int = 0
    var rank: Int? = nil
    
    var total_points: Int64 = 0
    var total_workouts: Int = 0
    var total_workout_time: Int64 = 0
    var total_number_of_reps: Int64 = 0
    var total_rest_time: Int64 = 0
    
    var lost_streak: Int? = nil
    var days_left_to_reclaim_streak: Int? = nil
    
    var level: Int64 = 0
    var join_date: Date
    var has_exercised_today: Bool = false
    var has_reviewed_app: Bool = false
    var has_rated_app: Bool = false
    var profile_picture: String? = nil
    var images_to_delete: [String] = [String]()
    
    init(ownerUid: String, username: String, joinDate: Date) {
        self.owner_uid = ownerUid
        self.username = username
        self.join_date = joinDate
    }
    
}
