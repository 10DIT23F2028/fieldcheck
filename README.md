# FieldCheck - Field Check-In App
A Flutter mobile application for checking in at locations with photo capture, GPS coordinates, and local storage. Built as a technical test for a Flutter Mobile Developer Intern position.


## (1) FEATURES

  ### Completed Requirements
      - [x] **Three Screens**: Home/History, New Check-In, and Detail view
      - [x] **Home Screen**: Displays list of saved check-ins with thumbnail, note, and timestamp
      - [x] **Empty State**: Shows when no check-ins exist
      - [x] **New Check-In Screen**: 
        - Note field with validation (required)
        - Take Photo button with preview
        - Get Location button showing latitude, longitude, and accuracy
        - Loading state while fetching location
        - Save button with validation
      - [x] **Detail Screen**: Read-only view of a single record
      - [x] **Red-White Theme**: Consistent branding throughout the app
      - [x] **Refresh Button**: Manually refreshes the list
      - [x] **Auto-save**: Data automatically persists on app close
      - [x] **Permission Handling**: Graceful handling when permissions are denied

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
  ![Empty State](SCREENSHOTS/empty_state.png)

  ### Home Screen with Check-ins
  ![Home Screen](SCREENSHOTS/home_screen.png)

  ### New Check-In Form
  ![New Check-In](SCREENSHOTS/new_checkin.png)

  ### Detail Screen
  ![Detail Screen](SCREENSHOTS/detail_screen.png)

  ### Photo Capture
  ![Photo Capture](SCREENSHOTS/photo_capture.png)

  ### GPS Location
  ![GPS Location](SCREENSHOTS/gps_location.png)


## (4) DEMO VIDEO
![Demo](SCREENSHOTS/fieldcheck_demo_najwa.mp4)