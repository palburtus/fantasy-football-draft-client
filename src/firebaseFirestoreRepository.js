import firebase from 'firebase/compat/app';
import 'firebase/compat/auth';
import 'firebase/compat/firestore';

const firebaseConfig = {
    apiKey: 'AIzaSyCoKt9CylzCeMTlY2NxAJjOm1OvJEZByrc',
    authDomain: "aaks-football.firebaseapp.com",
    projectId: 'aaks-football'
};

firebase.initializeApp(firebaseConfig);
const db = firebase.firestore();


export const getAllNotes = () => {
    
    return new Promise((resolve, reject) => {
    
        db.collection('notes').get().then((collection) => {
            let documents = [];
            collection.forEach(doc => {
                
                let data = doc.data();
                
                documents.push(data);
            });
        
            if(documents){
                resolve({documents}); 
            }else{
                reject('Error loading standings');
            }
        }).catch((error) => { 
            reject('Connection error please try again')
        });             
                 
    });
}

export const upsertNote = (playerName, note) => {
    
    let obj = {playerName: playerName, note: note};
    return db.collection('notes').doc(playerName).set(obj, { merge: false });        
}


    
