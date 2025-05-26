/**
 * @interface Options
 * @description The options for the prompt.
 */
export interface Options {
  /**
   * The username to save.
   */
  username: string;
  /**
   * The password to save.
   */
  password: string;
  /**
   * The url to save the password for. (For example: "web.capgo.app")
   * iOS only.
   */
  url?: string;
}

export interface ReadPasswordResult {
  /**
   * The username of the password.
   */
  username: string;
  /**
   * The password of the password.
   */
  password: string;
}

/**
 * @interface SavePasswordPlugin
 * @description Capacitor plugin for saving passwords to the keychain.
 */
export interface SavePasswordPlugin {
  /**
   * Save a password to the keychain.
   * @param {Options} options - The options for the password.
   * @returns {Promise<void>} Success status
   * @example
   * await SavePassword.promptDialog({
   *   username: 'your-username',
   *   password: 'your-password'
   * });
   */
  promptDialog(options: Options): Promise<void>;

  /**
   * Read a password from the keychain. Requires the developer to setup associated domain for the app for iOS.
   * @returns {Promise<void>} Success status
   */
  readPassword(): Promise<ReadPasswordResult>;
}
