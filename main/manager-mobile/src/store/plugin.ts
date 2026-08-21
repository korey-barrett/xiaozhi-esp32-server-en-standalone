import type { AgentFunction, PluginDefinition } from '@/api/agent/types'
import { defineStore } from 'pinia'
import { ref } from 'vue'

export const usePluginStore = defineStore(
  'plugin',
  () => {
    // All available plugins
    const allFunctions = ref<PluginDefinition[]>([])

    // The current agent's plugin config
    const currentFunctions = ref<AgentFunction[]>([])

    // The agent ID currently being edited
    const currentAgentId = ref('')

    // Set all available plugins
    const setAllFunctions = (functions: PluginDefinition[]) => {
      allFunctions.value = functions
    }

    // Set the current agent's plugin config
    const setCurrentFunctions = (functions: AgentFunction[]) => {
      currentFunctions.value = functions
    }

    // Set the current agent ID
    const setCurrentAgentId = (agentId: string) => {
      currentAgentId.value = agentId
    }

    // Update the plugin config (called when saving)
    const updateFunctions = (functions: AgentFunction[]) => {
      currentFunctions.value = functions
    }

    // Clear the data
    const clear = () => {
      allFunctions.value = []
      currentFunctions.value = []
      currentAgentId.value = ''
    }

    return {
      allFunctions,
      currentFunctions,
      currentAgentId,
      setAllFunctions,
      setCurrentFunctions,
      setCurrentAgentId,
      updateFunctions,
      clear,
    }
  },
  {
    persist: false, // Not persisted; reloaded each time the page is entered
  },
)
