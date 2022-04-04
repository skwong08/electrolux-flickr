# Electrolux Flickr

## Description
The project is using Flickr photo search API. It allows user to search images by keywords, select the image(s) and save into user's photo library.

## Before running project
1. Open Terminal and install cocoapods is required if the machine to review this project is not having the library.
```js
$ sudo gem install cocoapods
```

2. After cocoapods had been installed, nagivate to the project path in Terminal and run pod install 
e.g.
```js
$ cd /Users/[user_directory]/[project_path]

$ pod install
```

3. Once the pod was installed, you may run and test the project using the `.xcworkspace`

## Optional
If the current Flickr API key is not working anymore, you may apply a new API key from Flickr and change the current API key in the `ELConstant` file and look for `apiKey` variable

You can apply for Flickr API key here: https://www.flickr.com/services/api/misc.api_keys.html 
1. Register an account if you are new user
2. Fill in the information form
3. Submit and you will get the new API key

## Project Features:
1. Display images listing
2. Search images by keywords
3. Save up to 5 images
4. Preview images in full screen
5. Lazy loading for pagination

## Achievements:
1. Ignore pods' files
2. Layout UI programmatically
3. Do not use storyboard and xib files
4. Follow Apple Human Interface Guidelines
5. 8-point grid system
6. MVVM design pattern
7. Written comments and marks
8. Sensible names for variable
9. No compiler errors
10. No runtime layout errors should be visible
11. No runtime crashes
12. Display photos using vertical UICollectionView
13. Show photos for “Electrolux” hashtag from Flickr
14. 3 columns of cell items
15. User able to interact with app while it’s fetching the photos
16. Select multiple images with cell highlighted and able to save 5 images at one time
17. Cache downloaded images
18. Implemented search bar to enable a user to look up his own hashtag
19. The photo displayed right after it has been downloaded, without waiting for processing the others
20. While the image is loading, display the native iOS loading indicator
21. Written 2 Unit Tests
