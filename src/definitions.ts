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
}
