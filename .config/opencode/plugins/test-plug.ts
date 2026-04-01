import type { Plugin } from "@opencode-ai/plugin"

export const TestPlug: Plugin = async ({ project, client, $, directory, worktree }) => {
  return {
    console.log("")
  }
}
