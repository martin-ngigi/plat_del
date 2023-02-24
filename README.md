# plat_del

## Local firebase configuration(This will register our applications to firebase and automatically add json files ;-)
- Add firebase .exe
- Add C:\Users\<username>\AppData\Local\Pub\Cache\bin to Environment Path.
- Executed command:
```
dart pub global activate flutterfire_cli
```
- login to firebase:
```
firebase login
```
- configure flutter
```
flutterfire configure
```
- or
```
flutterfire.bat configure
```

# SHA-1 Generation for android Method 1 (NB: MOST RECOMMENDED WAY)
1. Right click on 'gradlew' and go to 'Open in Terminal' This file is found under {{YOUR PROJECT}}/android/gradlew
- OR while inside project directory, navigate to android directory i.e.
```
cd android
```
2. Type in the following command(on mac).
```
gradlew signingReport
```
- or If did not work first try second command(on windows):
```
./gradlew signingReport
```
- Inside project directory, run following command to clean and get:
```
flutter clean
flutter pub get
```
- If facing any issues generating SHAH-1, comment on packages in pubspec.yml then pub get, afterwards uncomment
- Add The SHA-1 to firebase project by pressing 'add fingerprint' in firebase

## enable Firebase In-App Messaging API
- [Firebase In-App Messaging API](https://console.cloud.google.com/marketplace/product/google/firebaseinappmessaging.googleapis.com)
- [e.g. Firebase In-App Messaging API](https://console.cloud.google.com/marketplace/product/google/firebaseinappmessaging.googleapis.com?project=platdel-88265)
- Search for project i.e. 'platdel-88265 (platdel)' and ENABLE
- Inside project directory, run following command to clean and get:
```
flutter clean
flutter pub get
```

