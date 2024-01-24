const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.addHoliday = functions.https.onRequest(async (request, response) => {
  try {
    const { date, description } = request.body;

    await admin.firestore().collection("holidays").add({
      date: date,
      description: description,
    });

    response.status(200).send('Holiday added successfully');
  } catch (error) {
    console.error(error);
    response.status(500).send('Internal Server Error');
  }
});
