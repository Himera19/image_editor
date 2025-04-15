# Image Filtering  
*An Image Filtering Application Made with Flutter*

## GIF Demo  
<img src="https://github.com/Himera19/image_editor/blob/main/app_preview.gif" height="450">

## Usage  
- **Image Selecting**: Users can select image from device gallery.  
- **Native Filtering**: Users can apply native filters to selected image based C++ & OpenCV.  
- **Phyton Filtering**: Users can apply AI filters to selected image based Phyton & Flask & OpenCV.  
- **History Pipeline**: Users can move in next & previous filters that selected. If the user navigates back to a previous step and select another filter, discarding all steps that occurred after navigated to back filter.  
- **Compare to Before - After**: Users can compare filter applied images to before & after.  

## Key Dependencies  
- **Image Picker**: Used to fetch device gallery and image selection.  
- **Provider**: Ensures app integrity and manages state effectively.  
- **Path Provider**: Used to create cache path direction for fetch filtered image output.  
- **FFI**: Enables comminating between Dart to C++ codes.  
- **HTTP**: Handles API requests and processes the results.  
- **Isolate**: Prevent to UI freezing while filter applying.  

## Prefered Requirements  
- **Dart 3.5.3 or above.**
- **Flutter 3.24.3 or above.**

## Setup  
### OpenCV Configuration  
1. Go to OpenCV [releases page](https://opencv.org/releases/).  
2. Download latest Android SDK and iOS Framework.  

#### Android Setup  
This repository already includes:  
- `CMakeLists.txt` file.  
- Necessary configurations inside `build.gradle` file.  

You must do just these steps:
- Create `jniLibs` folder inside `android/app/src/main`.  
- Move all folders inside of `%Downloaded Library Folder%/sdk/native/libs` to `android/app/src/main/jniLibs`.  
- Move `include` folder inside of `%Downloaded Library Folder%/sdk/native/jni` to root folder of project.  
---
#### iOS Setup
This repository already includes:  
- Necessary linking configurations `open_cv/image_editor.cpp` file.
   
You must do just these steps:  
- Open Runner.xcodeproj in XCode.
- Extract `%Downloaded Library Folder%` and move extracted files under to Runner.
- NOTE: Select action as 'Copy files to destination' section and check Runner target.

### Python Configuration
1. Check Python installation:
- macOS / Linux: `python3 --version`
- Windows: `python --version`
2. If not installed, download from [python.org](https://www.python.org/downloads/).
3. Navigate to the API folder and install dependencies:
   ```bash
   cd python_api
   pip install -r requirements.txt
5. Start the Flask server:
   `python app.py`
6. Now your local server started. You can use Python filters.

## License  
This project is licensed under the MIT License.
