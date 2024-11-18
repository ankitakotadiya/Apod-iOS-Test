# Apod-iOS-Test
The APOD (Astronomy Picture of the Day) iOS application is designed to provide users with an immersive, interactive experience of viewing daily astronomy images, videos, and GIFs. In this app, users can explore the latest picture of the day as well as navigate through the APOD archive by selecting any date to view the content of that day.

## Project Structure & Architecture:
The app has been built using SwiftUI, with a clear emphasis on a loose coupling and maintainability. The project follows the MVVM (Model-View-ViewModel) architecture to ensure scalability and separation of concerns, which allows for easy testing, debugging, and future extensibility.

Here is the demo of the project!

Here’s a breakdown of the major components of the project:

1. Utilities Folder:
   - This folder contains essential utility classes, extensions, constants, and shared resources that are used across the entire application.
   - Custom fonts and colors
   - Common SwiftUI extensions
   - Helper classes for various utility functions

2. Reusable Views:
   - The Reusable Views folder houses all the common UI components that are used throughout the app. This enables code reuse and reduces redundancy.
   - Custom buttons, image views, and loading indicators.
   - Views like MediaContentView that display media content (images, videos, GIFs).

3. Data Management (DataBaseManager):
   - Core Data is used to handle local data storage, ensuring efficient management and persistence of user data, such as previously viewed APOD images, search history, and user preferences.
- The DataBaseManager handles all Core Data operations and includes methods for saving, fetching, and deleting data. This structure makes it easy to extend the app's data layer in the future if needed.

4. Network Management (NetworkManager):
   - The NetworkManager is responsible for handling all network-related tasks, including fetching the APOD image and metadata from the API.
   - It abstracts the networking layer and allows for easy communication with the server to retrieve daily and historical APOD content.

6. Main Screen and Tabs:
   - The app’s main screen is structured with a Tab Bar, where the first tab shows the 'Today' screen, displaying the APOD content of the current day.
   - Set dummy second screen for future task extension.
   - Both screens are powered by the MVVM pattern, with each screen having its own ViewModel to manage the presentation logic and data binding.

## Testing & Quality Assurance:
The app includes Unit Tests, Integration Tests, and UI Tests to ensure that the core functionality is robust and reliable. These tests cover essential parts of the application, such as:
- NetworkManager: Testing API calls and responses.
- DataBaseManager: Verifying Core Data operations like saving and fetching.
- ViewModel: Testing business logic.
- UI Tests: Ensuring the user interface is responsive and functional.

## Next Steps & Future Considerations:
As the app progresses, the next phase will focus on increasing test coverage like in-memory database testing and enhancing the overall error handling and monitoring strategies. This will help ensure that the app remains stable, scalable, and user-friendly in production.

I can't wait to dive deeper into any of the specific aspects or edge cases!












