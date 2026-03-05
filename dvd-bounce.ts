// @i-know-the-amp-plugin-api-is-wip-and-very-experimental-right-now
import type { PluginAPI } from "@ampcode/plugin";
import { spawn, type Subprocess } from "bun";
import { join, dirname } from "path";

let child: Subprocess | null = null;

const SCRIPT_PATH = join(dirname(import.meta.path), "dvd-bounce-render.sh");

function killBounce() {
  if (child) {
    child.kill("SIGTERM");
    child = null;
  }
  // Belt-and-suspenders: also kill via PID file in case Bun lost the handle
  try {
    const pid = require("fs").readFileSync("/tmp/dvd-bounce.pid", "utf8").trim();
    if (pid) process.kill(Number(pid), "SIGTERM");
  } catch {}
}

export default function (amp: PluginAPI) {
  amp.on("agent.start", (_event, ctx) => {
    killBounce();

    try {
      child = spawn({
        cmd: ["bash", SCRIPT_PATH],
        stdout: "ignore",
        stderr: "ignore",
        stdin: "ignore",
      });
      ctx.logger.log("🎬 DVD bounce started");
    } catch (e) {
      ctx.logger.log(`DVD bounce failed to start: ${e}`);
    }

    return undefined;
  });

  amp.on("agent.end", (_event, ctx) => {
    killBounce();
    ctx.logger.log("🛑 DVD bounce stopped");
  });
}
