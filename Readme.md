# VaccineAvailability

VaccineAvailability is a vaccine tracker MacOS Big Sur Menu bar app to track vaccine availability 
across India by using pincodes and Age limit. The app uses 
[Cowin Public V2 APIs](https://apisetu.gov.in/public/marketplace/api/cowin/cowin-public-v2)

## MacOS App Screens
<img src="screenshot.jpg?raw=true"  alt="App Screens"/>

## Availability Notifications
Key feature of the App is the notifications on MacOS Big Sur. You can leave it running on your Mac and 
when the slot opens for the pincode you have added, it will notify you the Hospitals & the dates available.

VaccinationAvailability app polls CoWin API every 15 seconds for 7-day availability of vaccine slots (for the added pincodes and age group) 

## Download

<a href="https://github.com/nsriram/VaccineAvailability/releases/download/v1.0.1/VaccineAvailability.app.zip">Download v1.0.1</a>

## Setup
* Download the `VaccineAvailability.app.zip`
* Opening the `VaccineAvailability.app.zip` will create `VaccineAvailability.app` (in ~/Downloads folder)
* Right click (secondary click) and open the `VaccineAvailability.app`
* Allow the notifications request to receive notifications from the app  
* Add 3 pincodes in India
* Select 18-44 age group, if you are looking for it 
* Save the preferences
* When the slot opens for the pincode, age group you have added, you will see a notification on your Mac. Clicking on
the notification will open the main app and from there you can click cowin registration website.

## Exit
* At any point 'Exit App' option can be used to exit the app and stop the notifications

## Note 
* App is designed to support dark mode
* App only works on MacOs Big Sur
* App works from Macbooks on network within India 

## Usage

From Mac Terminal
```
open -a VaccineAvailability
```  

## Contributing
(see [Contributing](CONTRIBUTING.md)). 

## License

Copyright © 2021 Sriram Narasimhan

Licensed under MIT License (see [LICENSE](LICENSE)). 
