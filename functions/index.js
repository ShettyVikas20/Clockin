const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.addSundays = functions.pubsub
    .schedule("0 0 1 * *")
    .timeZone("Asia/Kolkata")
    .onRun(async (context) => {
      try {
        const firstDayOfMonth = new Date();
        firstDayOfMonth.setDate(1);

        const lastDayOfMonth = new Date(firstDayOfMonth);
        lastDayOfMonth.setMonth(firstDayOfMonth.getMonth() + 1);
        lastDayOfMonth.setDate(0);

        const sundays = [];
        const currentDay = new Date(firstDayOfMonth);
        while (currentDay <= lastDayOfMonth) {
          if (currentDay.getDay() === 0) {
            sundays.push({
              date: admin.firestore.Timestamp.fromDate(currentDay),
              description: "Sunday",
            });
          }
          currentDay.setDate(currentDay.getDate() + 1);
        }

        const monthKey = `month_${firstDayOfMonth.getMonth() + 1}_${firstDayOfMonth.getFullYear()}`;
        const holidaysRef = admin.firestore().collection("holidays").doc(monthKey);

        const holidaysSnapshot = await holidaysRef.get();
        const existingHolidays = holidaysSnapshot.exists ? holidaysSnapshot.data().holidays : [];

        await holidaysRef.set({
          holidays: [...existingHolidays, ...sundays],
        });

        console.log("Sundays added successfully.");
        return null;
      } catch (error) {
        console.error("Error adding Sundays:", error);
        return null;
      }
    });
