 # @capgo/capacitor-ios-autofill-save-password

 <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin"> ➡️ Get Instant updates for your App with Capgo 🚀</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin"> Fix your annoying bug now, Hire a Capacitor expert 💪</a></h2>
</div>

Fork of original plugin to work with Capacitor 7 

## Installation
````batch
npm i capacitor-ios-autofill-save-password
npx cap sync
````
## Prerequisite
You must set up your app’s associated domains. To learn how to set up your app’s associated domains, see [Supporting Associated Domains](https://developer.apple.com/documentation/safariservices/supporting_associated_domains) in Apple Developer document.

## How to use
```ts
import { Capacitor } from '@capacitor/core';
import { SavePassword } from 'capacitor-ios-autofill-save-password';
    
login(username: string, password: string) {
    // your login logic here
        
    // call the plugin if login is successful on iOS
    if (Capacitor.getPlatform() === 'ios') {
        SavePassword.promptDialog({
            username: username,
            password: password,
        })
        .then(() => console.log('promptDialog success'))
        .catch((err) => console.error('promptDialog failure', err));
    }
}
```

## API

<docgen-index>

* [`promptDialog(...)`](#promptdialog)
* [Interfaces](#interfaces)

</docgen-index>

