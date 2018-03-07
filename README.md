# KnowCanada
IOS app that displays information about Canada in a tabular format with images

## Build and Runtime Requirements ##
Xcode 9.0 or later iOS 8.0 or later OS X v10.12 or later

## Configuring the Project ##
Please clone the project in your local machine and open with the latest version of Xcode. Build and run the project after selecting a device from the device inspector.

## About KnowCanada ##
Written using Swift 4.0. The app accesses the api to fetch information about Canada display it to the user in realtime. The app refreshes latest poperties as soon as the user launches the app or if the user decides to pull the tableview to refresh.

### Unit Tests ###
Unit tests are written to test asynchronous code (creating the request to be sent to the InfoRequestRouter) and Helper code which processes String data to return height. Mocking the response from the InfoRequestRouter and processing json data.

### Performance test :
To test processing time required to process dictionary of data fetched from Api.

### Code Coverage :
Approx 75%

### Steps to Execute tests:
In XCode menu bar goto>> Product and in the dropdown menu click test.

## Design Goal:
Design consideration : Design goal is to mimimise dependencies between controllers and models. Fetch, filter and model data asynchronously and populate the views on the main queue and make use of protocol oriented principles of the swift language to maintain decent level of decoupling within the application logic.

### Repo Owner 
Navdeep Singh
