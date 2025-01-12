<p align="center">
    <img src="https://github.com/bow-swift/bow-art/blob/master/assets/nef-brand-xcode-shadow.png?raw=true" alt="nef: an Xcode 11 plugin" width="30%"/>
</p>

<p align="center">
    <a href="https://github.com/bow-swift/nef">
    <img src="https://img.shields.io/badge/nef-%E2%9C%93-blueviolet" alt="nef">
    </a>
    <a href="https://developer.apple.com/xcode/swiftui">
    <img src="https://img.shields.io/badge/Swift%20UI-%E2%9C%93-orange" alt="Swift UI">
    </a>
    <a href="https://swift.org/download">
    <img src="https://img.shields.io/badge/Swift-5.1-orange" alt="Swift 5.1">
    </a>
    <a href="https://developer.apple.com/xcode">
    <img src="https://img.shields.io/badge/IDE-Xcode%2011-blue" alt="Xcode 11+">
    </a>
    <a href="https://www.apple.com/macos/catalina/">
    <img src="https://img.shields.io/badge/macOS-10.15%2B-blue" alt="macOS 10.15+">
    </a>
</p>

&nbsp;

This project provides an extension for Xcode to integrate some nef features directly in the IDE. Using the core of `nef`, you can [export snippets](https://github.com/bow-swift/nef#-exporting-carbon-code-snippets) from your code selection directly in Xcode.

### Features

💡 Exports a [__code selection__](#-export-code-selection-to-image) to images for given Xcode Playgrounds.

💡 Generates [__Markdown__](#-generates-markdown-file-from-playground) files from Xcode Playground.

💡 Builds a [__Playground Book__](#-create-a-playground-book-from-your-swift-package) with external dependencies defined in a Swift Package.

&nbsp;

## 📥 Installation

You can install `nef` plugin from [Mac App Store](https://apps.apple.com/app/nef/id1479391704?mt=8) or download the last binary from the [releases](https://github.com/bow-swift/nef-plugin/releases) section.

To complete the installation, you should enable `nef` extension from `System Preferences > Extensions > Xcode Source Editor`

<p align="center">
    <img src="assets/nef-plugin-extensions.png" alt="nef: enable Xcode extension" width="90%"/>
</p>

## Usage
### 🌁 Export code selection to image

In Xcode you can find the nef plugin options in `Editor`.

If you want to export your current code selection into a snippet, you only need to select the action `Editor > nef > Code selection → Image`

<p align="center">
    <img src="assets/nef-plugin-action-export.png" alt="nef: action for exporting code selection to snippet" width="90%"/>
</p>
<p align="center">
    <img src="assets/arrow-down.png" alt="nef: action for exporting code selection to snippet" width="8%"/>
</p>
<p align="center">
    <img src="assets/nef-plugin-action-snippet.png" alt="nef: action for exporting code selection to snippet" width="55%"/>
</p>

#### 🔧 Preferences

You can customize the output image using the preferences action `Editor > nef > Preferences`

<p align="center">
    <img src="assets/nef-xcode-preferences.png" alt="nef: preferences Xcode extension" width="80%"/>
</p>

&nbsp;

### 📃 Generates markdown file from Playground

Xcode Playgrounds let you write comments in markdown format using the symbols //: for single line comments, or /*: */ for multiline comments. Markup for playgrounds includes page level formatting for headings and other elements, formatting spans of characters, showing inline images, and several other features. You can read more in the [Markup Formatting Reference](https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/index.html).

You can create a markdown file from playground page with the nef action `Editor > nef > Playground → Markdown`

&nbsp;

### 📲 Create a Playground Book from your Swift package

You can create a Playground compatible with you iPad from a Swift package. You only need to open the swift package in Xcode,
and select the action `Editor > nef > Swift Package → Playground Book`

It will ask you where to save the Playground Book, and it will start to build it.

<p align="center">
    <img src="assets/nef-plugin-playgroundbook.png" alt="nef: action for making a Playground Book" width="90%"/>
</p>

> This feature needs to use SwiftPM tool. Consequently, it will need to disable the sandbox thus it is not allowed in the App Store; but if you want to enjoy this feature, you only need to install the `.dmg` you'll find in the [releases](https://github.com/bow-swift/nef-plugin/releases) section.

&nbsp;

## 🔨 Xcode navigation keyboard shortcuts

To make you a more productive developer, you can associate a keyboard shortcut to each `nef` action.
Open the shortcuts menu in `Xcode > Preferences... > Key Bindings` and set your command.

<p align="center">
    <img src="assets/nef-xcode-shortcuts.png" alt="nef: set keyboard shortcut"/>
</p>

# ⚖️ License

    Copyright (C) 2019 The nef Authors

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
