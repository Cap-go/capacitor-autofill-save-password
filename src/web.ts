import { WebPlugin } from '@capacitor/core';

import type { Options, ReadPasswordResult, SavePasswordPlugin } from './definitions';

export class SavePasswordWeb extends WebPlugin implements SavePasswordPlugin {
  readPassword(): Promise<ReadPasswordResult> {
    throw new Error('Method not implemented.');
  }
  async promptDialog(options: Options): Promise<void> {
    throw new Error('Not implemented on web' + JSON.stringify(options));
  }

  async getPluginVersion(): Promise<{ version: string }> {
    return { version: 'web' };
  }
}
