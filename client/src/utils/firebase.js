import * as firebase from 'firebase';
import 'firebase/analytics';
const settings = {timestampsInSnapshots: true};

var config = {
    apiKey: "AIzaSyBI6-6K1AV3fCmObpkzEH2k2aL_KRnux78",
    authDomain: "fantasy-football-8824a.firebaseapp.com",
    databaseURL: "https://fantasy-football-8824a.firebaseio.com",
    projectId: "fantasy-football-8824a",
    storageBucket: "fantasy-football-8824a.appspot.com",
    messagingSenderId: "475547265389",
    appId: "1:475547265389:web:500e21e388548468619264",
    measurementId: "G-TGKGHEE7B5"
  };

firebase.initializeApp(config);
firebase.analytics();

export default firebase;

