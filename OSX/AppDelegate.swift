//
//  AppDelegate.swift
//  OSX
//
//  Created by Kirill Botalov on 30.06.17.
//
//


import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
/*
    @IBAction func exit(_ sender: Any) {
 
        if exitDialog() {
            NSApplication.shared().terminate(self)
        }
    }
    
    func exitDialog() -> Bool {
        
        let exitPanel = NSAlert()
        exitPanel.alertStyle = .informational
        exitPanel.messageText = "Do you really want to exit?"
        exitPanel.informativeText = " "
        exitPanel.addButton(withTitle: "Yes")
        exitPanel.addButton(withTitle: "No")
        return exitPanel.runModal() == NSAlertFirstButtonReturn
    }
*/
}
