# FieldCheck - Field Check-In App
A Flutter mobile application for checking in at locations with photo capture, GPS coordinates, and local storage. Built as a technical test for a Flutter Mobile Developer Intern position.


## (1) FEATURES
  ### Completed Requirements
      1. Three Screens : Home/History, New Check-In, and Detail view
      2. Home Screen : Displays list of saved check-ins with thumbnail, note, and timestamp
      3. Empty State : Shows when no check-ins exist
      4. New Check-In Screen : 
         - Note field with validation (required)
         - Take Photo button with preview
         - Get Location button showing latitude, longitude, and accuracy
         - Loading state while fetching location
         - Save button with validation
      5. Detail Screen : Read-only view of a single record
      6. Red-White Theme : Consistent branding throughout the app
      7. Refresh Button : Manually refreshes the list
      8. Auto-save : Data automatically persists on app close
      9. Permission Handling : Graceful handling when permissions are denied

  ### Hardware Integration (via Flutter plugins)
      | Feature | Implementation | Plugin |
      |---------|----------------|--------|
      | Camera  | Take photo and show preview | `image_picker` |
      | GPS | Get latitude, longitude, and accuracy | `geolocator` + `permission_handler` |
      | Local Storage | Persist check-ins across app restarts | `hive_flutter` |

  ### Not Implemented
    None - all requirements are fully implemented.


## (2) GETTING STARTED
  ### Pre-requisites
    - Flutter SDK (>=3.0.0)
    - Android Studio / VS Code
    - Android Emulator or Physical Device (Android 5.0+ / API 21+)

  ### Installation
    1. **Clone the repository**
      ```bash
    git clone https://github.com/10DIT23F2028/fieldcheck.git
    cd fieldcheck


## (3) SCREENSHOTS
  ### Empty State (No Check-ins)
  ![Empty State](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/empty_state.jpeg)

  ### Home Screen with Check-ins
  ![Home Screen](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/home_screen.jpeg)

  ### New Check-In Form
  ![New Check-In](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/new_check_in.jpeg)

  ### Detail Screen
  ![Detail Screen](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/detail_screen.jpeg)

  ### Photo Capture
  ![Photo Capture](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/photo_capture.jpeg)

  ### GPS Location
  ![GPS Location](https://github.com/10DIT23F2028/fieldcheck/blob/main/SCREENSHOTS/gps_location.jpeg)


## (4) DEMO VIDEO
![Demo](https://github.com/10DIT23F2028/fieldcheck/blob/main/DEMO/fieldcheck_demo_najwa.gif)
