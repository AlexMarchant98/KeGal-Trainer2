const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.dailyReset = functions.pubsub.schedule('every day 00:00').onRun(async context => {

    return admin.firestore().collection('profiles').get().then(snapshot => {
        
        const promises = [];
        var allProfiles = []

        snapshot.forEach(doc => {
            const profileData = doc.data();
            const profile = profileData
            allProfiles.push({profile, doc})
        });

        allProfiles = allProfiles.sort((a, b) => a.profile.total_points > b.profile.total_points);

        allProfiles.forEach((data, i) => {

            const { profile, doc } = data

            var workoutDaysStreak = profile.workout_days_streak;
            var streakProtectors = profile.streak_protectors;
            var lostStreak = profile.lost_streak;
            var daysLeftToReclaimStreak = profile.days_left_to_reclaim_streak;

            var rank = i + 1

            if(profile.has_exercised_today === false) {

                // If they own a streak protector, don't reset the streak, only -1 from streak_protectors

                if(streakProtectors > 0) {

                    streakProtectors = profile.streak_protectors - 1

                    // TODO:
                    // Send a remote notification to the user informing them they have lost a streak protector
                    // Recommend they buy another

                } else {

                    if(lostStreak === 0) {
                        lostStreak = profile.workout_days_streak;
                        daysLeftToReclaimStreak = 3;
                    } else {
                        lostStreak = lostStreak + profile.workout_days_streak;
                    }

                    streakProtectors = 0;
                    workoutDaysStreak = 0;

                    // TODO:
                    // Send a notification to the user informing them they can still save their old streak
                    // They can then buy a streak saver to get their old streak back

                }

            }

            if(daysLeftToReclaimStreak <= 0) {
                lostStreak = 0;
                daysLeftToReclaimStreak = 0;
            } else {
                daysLeftToReclaimStreak -= 1;
            }

            promises.push(
                doc.ref.update({
                    streak_protectors: streakProtectors,
                    workout_days_streak: workoutDaysStreak,
                    lost_streak: lostStreak,
                    days_left_to_reclaim_streak: daysLeftToReclaimStreak,
                    has_exercised_today: false,
                    daily_points: 0,
                    rank
                })
            );

        });

        return Promise.all(promises)

    })
    .catch(error => {

      console.log(error);
      return null;

    });

});

exports.dailyResetManual = functions.https.onRequest((req, res) => {

    return admin.firestore().collection('profiles').get().then(snapshot => {
        
        const promises = [];
        var allProfiles = []

        snapshot.forEach(doc => {
            const profileData = doc.data();
            const profile = profileData
            allProfiles.push({profile, doc})
        });

        allProfiles = allProfiles.sort((a, b) => a.profile.total_points > b.profile.total_points);

        allProfiles.forEach((data, i) => {

            const { profile, doc } = data

            var workoutDaysStreak = profile.workout_days_streak;
            var streakProtectors = profile.streak_protectors;
            var lostStreak = profile.lost_streak;
            var daysLeftToReclaimStreak = profile.days_left_to_reclaim_streak;

            var rank = i + 1

            if(profile.has_exercised_today === false) {

                // If they own a streak protector, don't reset the streak, only -1 from streak_protectors

                if(streakProtectors > 0) {

                    streakProtectors = profile.streak_protectors - 1

                    // TODO:
                    // Send a remote notification to the user informing them they have lost a streak protector
                    // Recommend they buy another

                } else {

                    if(lostStreak === 0) {
                        lostStreak = profile.workout_days_streak;
                        daysLeftToReclaimStreak = 3;
                    } else {
                        lostStreak = lostStreak + profile.workout_days_streak;
                    }

                    streakProtectors = 0;
                    workoutDaysStreak = 0;

                    // TODO:
                    // Send a notification to the user informing them they can still save their old streak
                    // They can then buy a streak saver to get their old streak back

                }

            }

            if(daysLeftToReclaimStreak <= 0) {
                lostStreak = 0;
                daysLeftToReclaimStreak = 0;
            } else {
                daysLeftToReclaimStreak -= 1;
            }

            promises.push(
                doc.ref.update({
                    streak_protectors: streakProtectors,
                    workout_days_streak: workoutDaysStreak,
                    lost_streak: lostStreak,
                    days_left_to_reclaim_streak: daysLeftToReclaimStreak,
                    has_exercised_today: false,
                    daily_points: 0,
                    rank
                })
            );

        });

        return Promise.all(promises)

    })
    .catch(error => {

      console.log(error);
      return null;

    });

});