# Image Filtering  
*An Image Filtering Application Made with Flutter*

---

## GIF Demo  
<img src="https://github.com/Himera19/image_editor/blob/master/app_preview.gif" height="450">

---

## Features  

- **Image Selecting**: Users can select image from device gallery.  
- **Native Filtering**: Users can apply native filters to selected image based C++ & OpenCV.  
- **AI Filtering**: Users can apply AI filters to selected image based Phyton & Flask & OpenCV.  
- **History Pipeline**: User can move in next & previous filters that selected. If the user navigates back to a previous step and select another filter, discarding all steps that occurred after navigated to back filter.  
- **Compare to Before - After**: User can compare filter applied images to before & after.  

---

## Key Dependencies  

- **Image Picker**: Used to fetch device gallery and image selection.  
- **Provider**: Ensures app integrity and manages state effectively.  
- **Path Provider**: Used to create cache path direction for fetch filtered image output.  
- **FFI**: Enables comminating between Dart to C++ codes.  
- **HTTP**: Handles API requests and processes the results.  
- **Isolate**: Prevent to UI freezing while filter applying.  

---

## Usage  

1. **API Access**: The app fetches word information from an external API.  
2. **Local Storage**: The last 5 searched words are saved in Hive, allowing offline access.  
3. **Word Details**: Detailed information about the searched word is displayed.  
4. **Synonym Details**: The top 5 synonyms for the searched word are shown.  
5. **Filtering**: Users can filter word meanings based on word types.  

---

## Requirements  

- **Dart**: 3.5.3  
- **Flutter**: 3.24.3  

---

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

#### iOS Setup  

This repository already includes:  
- Necessary linking configurations `open_cv/image_editor.cpp` file.  

You must do just these steps:  
- Open Runner.xcodeproj in XCode.
- Extract `%Downloaded Library Folder%` and move extracted files under to Runner.
- NOTE: Select action as 'Copy files to destination' section and check Runner target.

### Phyton Configuration  
  
---

## License  

This project is licensed under the MIT License.
