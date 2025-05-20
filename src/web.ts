import { WebPlugin } from "@capacitor/core";
import { Options, SavePasswordPlugin } from "./definitions";

export class SavePasswordWeb extends WebPlugin implements SavePasswordPlugin {
  async promptDialog(options: Options): Promise<void> {
    throw new Error("Not implemented on web" + JSON.stringify(options));
  }
}
