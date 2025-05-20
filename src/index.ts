import { registerPlugin } from "@capacitor/core";
import { SavePasswordPlugin } from "./definitions";

const SavePassword = registerPlugin<SavePasswordPlugin>("SavePassword", {
  web: () => import("./web").then((m) => new m.SavePasswordWeb()),
});

export * from "./definitions";
export { SavePassword };
