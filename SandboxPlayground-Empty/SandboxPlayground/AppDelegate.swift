//
//  AppDelegate.swift
//  SandboxPlayground
//
//  Created by Fernando Rodríguez Romero on 13/05/16.
//  Copyright © 2016 udacity.com. All rights reserved.
//

import UIKit

// MARK: - AppDelegate: UIResponder, UIApplicationDelegate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        sandboxPlayground()
        return true
    }

    // MARK: Sandbox Playground
    func sandboxPlayground() {
        let url =
            FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("file.txt")

        do {
            try "Try to write".write(to: url, atomically: true, encoding: .utf8)
        } catch {
            print("Error while writing")
        }

        do {
            let read = try String(contentsOf: url, encoding: .utf8)
            print(read)
        } catch {
            print("Error while reading")
        }

    }
}
