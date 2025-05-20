# @capgo/capacitor-autofill-save-password

Prompt to display dialog for saving password to keychain from webview app

 <a href="https://capgo.app/"><img src='https://raw.githubusercontent.com/Cap-go/capgo/main/assets/capgo_banner.png' alt='Capgo - Instant updates for capacitor'/></a>

<div align="center">
  <h2><a href="https://capgo.app/?ref=plugin"> ➡️ Get Instant updates for your App with Capgo 🚀</a></h2>
  <h2><a href="https://capgo.app/consulting/?ref=plugin"> Fix your annoying bug now, Hire a Capacitor expert 💪</a></h2>
</div>

Fork of original plugin to work with Capacitor 7 

## Install

```bash
npm install @capgo/capacitor-autofill-save-password
npx cap sync
```

## Prerequisite
You must set up your app’s associated domains. To learn how to set up your app’s associated domains, see [Supporting Associated Domains](https://developer.apple.com/documentation/safariservices/supporting_associated_domains) in Apple Developer document.

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

## API

<docgen-index>

* [`promptDialog(...)`](#promptdialog)
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


### Interfaces


#### Options

| Prop           | Type                | Description           |
| -------------- | ------------------- | --------------------- |
| **`username`** | <code>string</code> | The username to save. |
| **`password`** | <code>string</code> | The password to save. |

</docgen-api>
