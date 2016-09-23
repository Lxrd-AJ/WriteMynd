//
//  Utilities.swift
//  WriteMynd
//
//  Created by AJ Ibraheem on 04/12/2015.
//  Copyright © 2015 The Leaf. All rights reserved.
//

import Foundation
import UIKit

let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height

/**
 Executes the closure using grand central dispatch on the main queue
 - parameters:
 - delay: The amount in seconds to wait before executing `closure`
 - closure: The lambda block to execute
 */
func delay(_ delay:Double, closure:@escaping ()->()) {
    DispatchQueue.main.asyncAfter(
        deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
}

let dailyQuestion: [String] = [
    "What's going on?",
    "What mood are you in?",
    "How is your health?",
    "What’s the last new thing you tried?",
    "What’s your biggest hope?",
    "What’s the last book you read?",
    "How many photos did you take today?",
    "What do you look for in art?",
    "What did you buy today?",
    "Who do you wish you didn’t have to deal with?",
    "What do you feel secure in knowing?",
    "What has challenged your morals?",
    "What time did you go to bed last night?",
    "What’s the last thing that you wanted but didn’t get?",
    "What stresses you?",
    "What’s your super-power?",
    "What’s the last thing you apologised for?",
    "What’s annoying you?",
    "What would have made today perfect?",
    "What would you do if you had more time?",
    "What’s your favourite gadget?",
    "When is the last time you intentionally ‘wasted’ time?",
    "Does anyone owe you money?",
    "What would make your life easier?",
    "What is the last thing you felt guilty about?",
    "What decision do you wish you didn’t have to make?",
    "What are you questioning?",
    "What was the most recent thing you learned?",
    "Where would you like to go?",
    "What was your last doctor’s appointment about?",
    "What three things should you have done today?",
    "What pressure did you feel today?",
    "How old do you feel?",
    "What was the last gift you received?",
    "How did you spend your free time today?",
    "Have you been a good listener recently?",
    "What’s happened recently to make your week worthwhile?",
    "If you could change today, would you?",
    "What would you have skipped today?",
    "Were you in control of your day?",
    "What do you wish for?",
    "What recent memory do you want to keep?",
    "What makes you sweat?",
    "Did you nurture any relationships today?",
    "What are you passionate about?",
    "Who do you wish had been part of your day?",
    "Are you a positive or negative person today?",
    "What’s one thing you’ve heard recently that you don’t want to forget?",
    "What words are you using too much lately?",
    "How are you expanding your mind?",
    "What was weird about the last few days?",
    "Are you holding any grudges?",
    "How was your day today?",
    "How much of your day do you spend alone?",
    "What’s the first thing you saw when you woke up this morning?",
    "What are three things that you’ll do tomorrow?",
    "What’s the last thing you did online?",
    "Who is the strongest person you know?",
    "What did you control today?",
    "What was your weakness today?",
    "How much did you eat today?",
    "What’s worth fighting for?"
]

let positiveSwipeQuestions: [String] = [
    "Calm",
    "Confident",
    "Content",
    "Eager",
    "Ecstatic",
    "Engaged",
    "Excited",
    "Grateful",
    "Happy",
    "Humourous",
    "Inspired",
    "Loving",
    "Motivated",
    "Optimistic",
    "Passionate",
    "Proud",
    "Reassured",
    "Relaxed",
    "Relieved",
    "Secure",
    "Surprised",
    "Thrilled"
]

let negativeSwipeQuestions: [String] = [
    "Angry",
    "Afraid",
    "Annoyed",
    "Anxious",
    "Ashamed",
    "Bored",
    "Confused",
    "Demoralised",
    "Depressed",
    "Disappointed",
    "Disgusted",
    "Embarassed",
    "Frustrated",
    "Guilty",
    "Insecure",
    "Jealous",
    "Lonely",
    "Resentful",
    "Sad",
    "Self-conscious",
    "Stressed",
    "Worried"
]

let swipeQuestions = positiveSwipeQuestions + negativeSwipeQuestions
