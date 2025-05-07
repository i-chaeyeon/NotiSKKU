importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/9.6.10/firebase-messaging-compat.js');

// Firebase 초기화
firebase.initializeApp({
  apiKey: "AIzaSyDOq4HcsFkWTTgxbLYId1mfoKakZSIluYI",
  authDomain: "notiskku-database.firebaseapp.com",
  projectId: "notiskku-database",
  storageBucket: "notiskku-database.firebasestorage.app",
  messagingSenderId: "816941767036",
  appId: "1:816941767036:web:7b412cfc59dc785b77ecf9"
});

// Firebase Messaging 객체 생성
const messaging = firebase.messaging();

// 백그라운드 메시지 처리
messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification.title || '📢 새 알림';
  const notificationOptions = {
    body: payload.notification.body || '',
    icon: '/icons/icon-192.png' 
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});