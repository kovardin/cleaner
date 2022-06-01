# Cleaner - Full application - Ready to monetize

## Description

This is application for cleaning android device from different junk files.

Application has four main buttons on home screen. This is:

1. Cache cleaning. User can remove old caches from his phone
2. Removing old apk files. This functionality allows you to find already unused apk files and remove it.
3. Downloaded files. We often forget to delete downloaded files. This functionality allows you to find such files and delete them.
4. Large files. Users can search for large files and delete them if necessary.

It is totally ready for monetization.  Application integrated with admob. You just need to specify
the correct publisher ID and placements IDs. You can find full instructions in README.md file in downloaded archive.

Application UI developed on Flutter. It is a modern framework for mobile development from Google.
Flutter is Google's UI toolkit for building beautiful, natively compiled applications for mobile,
web, desktop, and embedded devices from a single codebase.

With Flutter you can build Expressive and Flexible UI and quickly ship features with a focus on native end-user experiences.

Native part developed on Kotlin. It is a modern statically typed programming language used by over 60% of professional
Android developers that helps boost productivity, developer satisfaction, and code safety

## Documentation

##№ AdMob

If you have any difficulties with the AdMob, please refer to the [documentation](https://developers.google.com/admob/android/quick-start)

1. Update admob settings in `android/app/src/main/AndroidManifest.xml` file. Set real admob application id there

```xml
<meta-data
            android:name="com.google.android.gms.ads.APPLICATION_ID"
            android:value="ca-app-pub-xxxxxxxxxxxxxxxx~yyyyyyyyyy"/>
```

2. Update file `constants.dart` and set read admob unit ids

```dart
// admob
const AdmobApplicationId = 'ca-app-pub-9850683128627512~7585723935';
const AdmobUnitBanner = 'ca-app-pub-3940256099942544/6300978111';
const AdmobUnitInterstitial = 'ca-app-pub-3940256099942544/1033173712';
```

You can rea more about how to [create placements here](https://developers.google.com/admob/android/banner)

##№ Publication to store

You can change application name in `android/app/src/main/AndroidManifest.xml` file

```axml
 <application
        android:name="ru.kodazm.cleaner.App"
        android:label="cleaner"
        android:icon="@mipmap/launcher_icon">
```

After this application will be ready for publication in Google Play. Detailed information on how to publish the 
application [can be found here](https://developer.android.com/studio/publish)

### Advanced development

Generate pigeons files fo

```
flutter pub run pigeon \
  --input pigeons/junk/search.dart \
  --dart_out lib/pigeons/junk/search.dart \
  --java_out ./android/app/src/main/java/ru/kodazm/cleaner/pigeons/junk/Search.java \
  --java_package "ru.kodazm.cleaner.pigeons.junk"
  
  
flutter pub run pigeon \
  --input pigeons/junk/cleaning.dart \
  --dart_out lib/pigeons/junk/cleaning.dart \
  --java_out ./android/app/src/main/java/ru/kodazm/cleaner/pigeons/junk/Cleaning.java \
  --java_package "ru.kodazm.cleaner.pigeons.junk"
  
flutter pub run pigeon \
  --input pigeons/junk/stats.dart \
  --dart_out lib/pigeons/junk/stats.dart \
  --java_out ./android/app/src/main/java/ru/kodazm/cleaner/pigeons/junk/Stats.java \
  --java_package "ru.kodazm.cleaner.pigeons.junk"
```

Update `Copy with` extension

```
flutter pub run build_runner build
```
