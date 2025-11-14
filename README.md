# @capgo/capacitor-autofill-save-password

Prompt to display dialog for saving password to keychain from webview app

 <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin_autofill_save_password"> ➡️ Get Instant updates for your App with Capgo</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin_autofill_save_password"> Missing a feature? We’ll build the plugin for you 💪</a></h2>
</div>

Fork of original plugin to work with Capacitor 7 

IOS work for old versions and 18.3

## Documentation

The most complete doc is available here: https://capgo.app/docs/plugins/autofill-save-password/

## Install

```bash
npm install @capgo/capacitor-autofill-save-password
npx cap sync
```

## Prerequisite
You must set up your app’s associated domains. To learn how to set up your app’s associated domains, see [Supporting Associated Domains](https://developer.apple.com/documentation/safariservices/supporting_associated_domains) in Apple Developer document.

Then add in your `App.entitlements`

```xml
	<key>com.apple.developer.associated-domains</key>
	<array>
		<string>webcredentials:YOURDOMAIN</string>
	</array>
```

To associate your domain to your app.

## How to use
```ts
import { Capacitor } from '@capacitor/core';
import { SavePassword } from '@capgo/capacitor-autofill-save-password';
    
login(username: string, password: string) {
    // your login logic here
        
        SavePassword.promptDialog({
            username: username,
            password: password,
        })
        .then(() => console.log('promptDialog success'))
        .catch((err) => console.error('promptDialog failure', err));
}
```


### Android

Add `apply plugin: 'com.google.gms.google-services'` beneath `apply plugin: 'com.android.application'` in `android/app/build.gradle`

this will allow the plugin to import the proper lib.

Then you need to make sure you did set properly your domain and did add google-services.json.

guide here https://developer.android.com/identity/sign-in/credential-manager

You need to have the file at this path `android/google-services.json` set, if you dont use firebase add empty json

then add your domain in `example-app/android/app/src/main/res/values/strings.xml`

with 
```xml
    <string name="asset_statements" translatable="false">
    [{
    \"include\": \"https://YOURDOMAIN/.well-known/assetlinks.json\"
    }]
    </string>
```

## API

<docgen-index>

* [`promptDialog(...)`](#promptdialog)
* [`readPassword()`](#readpassword)
* [`getPluginVersion()`](#getpluginversion)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### promptDialog(...)

```typescript
promptDialog(options: Options) => Promise<void>
```

Save a password to the keychain.

| Param         | Type                                        | Description                     |
| ------------- | ------------------------------------------- | ------------------------------- |
| **`options`** | <code><a href="#options">Options</a></code> | - The options for the password. |

--------------------


### readPassword()

```typescript
readPassword() => Promise<ReadPasswordResult>
```

Read a password from the keychain. Requires the developer to setup associated domain for the app for iOS.

**Returns:** <code>Promise&lt;<a href="#readpasswordresult">ReadPasswordResult</a>&gt;</code>

--------------------


### getPluginVersion()

```typescript
getPluginVersion() => Promise<{ version: string; }>
```

Get the native Capacitor plugin version.

**Returns:** <code>Promise&lt;{ version: string; }&gt;</code>

**Since:** 1.0.0

--------------------


### Interfaces


#### Options

| Prop           | Type                | Description                                                                    |
| -------------- | ------------------- | ------------------------------------------------------------------------------ |
| **`username`** | <code>string</code> | The username to save.                                                          |
| **`password`** | <code>string</code> | The password to save.                                                          |
| **`url`**      | <code>string</code> | The url to save the password for. (For example: "console.capgo.app") iOS only. |


#### ReadPasswordResult

| Prop           | Type                | Description                   |
| -------------- | ------------------- | ----------------------------- |
| **`username`** | <code>string</code> | The username of the password. |
| **`password`** | <code>string</code> | The password of the password. |

</docgen-api>
