 <img src="https://github.com/SLRAM/FairShare/assets/28938900/7f376694-daa8-4ad7-8c37-034810d41126">

# FairShare
FairShare is an iOS app designed to simplify the management and sharing of receipts among users. The app leverages technologies such as SwiftUI, Firebase Firestore, and VisionKit to provide a seamless user experience for capturing, organizing, and sharing receipts.

## Key Features
- Receipt Capture: Use VisionKit to extract text from receipts, making it easy to digitize and store them.
- Firebase Integration: Utilize Firebase services for secure user authentication, cloud Firestore for real-time storage and synchronization of receipt data, and cloud Storage for managing receipt images.
- Contact Integration: Users can designate receipt items to their contacts, facilitating easy sharing and collaboration on shared expenses.

## Technologies Used
- SwiftUI: Modern UI framework for building declarative user interfaces.
- Firebase Authentication: Securely authenticate users with email/password or other federated identity providers.
- Firebase Firestore: NoSQL cloud database for scalable and flexible data storage, used for storing receipt data and user contacts.
- Firebase Storage: Cloud storage for managing and serving receipt images.
- VisionKit: Apple’s framework for text recognition and image analysis, used for extracting text from receipt images.
- Core Image: Process images to extract text using OCR.
- ContactsUI: Integrate with iOS Contacts framework for selecting contacts.

