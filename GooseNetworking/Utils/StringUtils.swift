/**
 Utility functions related to Strings
 - author: Ali H. Shah
 - date: 03/14/2019
 */
import Foundation

// Function to get the localized string based on a String Key.
func LocalString(_ key: String) -> String {
    return NSLocalizedString(key, comment: "")
}
