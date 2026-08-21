import type { PublicConfig } from '@/api/auth'
import { defineStore } from 'pinia'
import { ref } from 'vue'
import { getPublicConfig } from '@/api/auth'

// Initial state
const initialConfigState: PublicConfig = {
  enableMobileRegister: false,
  version: '',
  year: '',
  allowUserRegister: false,
  mobileAreaList: [],
  beianIcpNum: '',
  beianGaNum: '',
  sm2PublicKey: '',
  name: import.meta.env.VITE_APP_TITLE,
}

export const useConfigStore = defineStore(
  'config',
  () => {
    // Define the global config
    const config = ref<PublicConfig>({ ...initialConfigState })

    // Set the config info
    const setConfig = (val: PublicConfig) => {
      config.value = val
    }

    // Fetch the public config
    const fetchPublicConfig = async () => {
      try {
        const configData = await getPublicConfig()
        console.log(configData)

        setConfig(configData)
        return configData
      }
      catch (error) {
        console.error('Failed to fetch public config:', error)
        throw error
      }
    }

    // Reset the config
    const resetConfig = () => {
      config.value = { ...initialConfigState }
    }

    return {
      config,
      setConfig,
      fetchPublicConfig,
      resetConfig,
    }
  },
  {
    persist: {
      key: 'config',
      serializer: {
        serialize: state => JSON.stringify(state.config),
        deserialize: value => ({ config: JSON.parse(value) }),
      },
    },
  },
)
