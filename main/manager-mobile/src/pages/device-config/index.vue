<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { t } from '@/i18n'
import UltrasonicConfig from './components/ultrasonic-config.vue'
import WifiConfig from './components/wifi-config.vue'
import WifiSelector from './components/wifi-selector.vue'

// Type definitions
interface WiFiNetwork {
  ssid: string
  rssi: number
  authmode: number
  channel: number
}

// Network provisioning type
const configType = ref<'wifi' | 'ultrasonic'>('wifi')

// Network provisioning mode selector state
const configTypeSelectorShow = ref(false)

// WiFi selector reference
const wifiSelectorRef = ref<InstanceType<typeof WifiSelector>>()

// Selected WiFi network info
const selectedWifiInfo = ref<{
  network: WiFiNetwork | null
  password: string
}>({
  network: null,
  password: '',
})

// Network provisioning mode options
const configTypeOptions = [
  {
    name: t('deviceConfig.wifiConfig'),
    value: 'wifi' as const,
  },
  // {
  //   name: t('deviceConfig.ultrasonicConfig'),
  //   value: 'ultrasonic' as const,
  // },
]

// Show the network provisioning mode selector
function showConfigTypeSelector() {
  configTypeSelectorShow.value = true
}

// Network provisioning mode selector confirm
function onConfigTypeConfirm(item: { name: string, value: 'wifi' | 'ultrasonic' }) {
  configType.value = item.value
  configTypeSelectorShow.value = false
}

// Network provisioning mode selector cancel
function onConfigTypeCancel() {
  configTypeSelectorShow.value = false
}

// WiFi network selection event
function onNetworkSelected(network: WiFiNetwork | null, password: string) {
  selectedWifiInfo.value = { network, password }
}

// ESP32 connection status change event
function onConnectionStatusChange(connected: boolean) {
  console.log('ESP32 connection status:', connected)
}
// Set the navigation bar title after the component is mounted
onMounted(() => {
  uni.setNavigationBarTitle({
    title: t('deviceConfig.pageTitle'),
  })
})
</script>

<template>
  <view class="min-h-screen bg-[#f5f7fb]">
    <wd-navbar :title="t('deviceConfig.pageTitle')" safe-area-inset-top />

    <view class="box-border px-[20rpx]">
      <!-- Network provisioning method selection -->
      <view class="pb-[20rpx] first:pt-[20rpx]">
        <text class="text-[32rpx] text-[#232338] font-bold">
          {{ t('deviceConfig.configMethod') }}
        </text>
      </view>

      <view class="mb-[24rpx] border border-[#eeeeee] rounded-[20rpx] bg-[#fbfbfb] p-[24rpx]" style="box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);">
        <view class="flex cursor-pointer items-center justify-between border border-[#eeeeee] rounded-[12rpx] bg-[#f5f7fb] p-[20rpx] transition-all duration-300 active:border-[#336cff] active:bg-[#eef3ff]" @click="showConfigTypeSelector">
          <text class="text-[28rpx] text-[#232338] font-medium">
            {{ t('deviceConfig.configMethod') }}
          </text>
          <text class="mx-[16rpx] flex-1 text-right text-[26rpx] text-[#65686f]">
            {{ configType === 'wifi' ? t('deviceConfig.wifiConfig') : t('deviceConfig.ultrasonicConfig') }}
          </text>
          <wd-icon name="arrow-right" custom-class="text-[20rpx] text-[#9d9ea3]" />
        </view>
      </view>

      <!-- WiFi network selection -->
      <view class="pb-[20rpx]">
        <text class="text-[32rpx] text-[#232338] font-bold">
          {{ t('deviceConfig.networkConfig') }}
        </text>
      </view>

      <view class="mb-[24rpx] border border-[#eeeeee] rounded-[20rpx] bg-[#fbfbfb] p-[24rpx]" style="box-shadow: 0 2rpx 12rpx rgba(0, 0, 0, 0.04);">
        <wifi-selector
          ref="wifiSelectorRef"
          @network-selected="onNetworkSelected"
          @connection-status="onConnectionStatusChange"
        />
      </view>

      <!-- Network provisioning actions -->
      <view v-if="selectedWifiInfo.network" class="flex-1">
        <!-- WiFi provisioning component -->
        <wifi-config
          v-if="configType === 'wifi'"
          :selected-network="selectedWifiInfo.network"
          :password="selectedWifiInfo.password"
        />

        <!-- Ultrasonic provisioning component -->
        <ultrasonic-config
          v-else-if="configType === 'ultrasonic'"
          :selected-network="selectedWifiInfo.network"
          :password="selectedWifiInfo.password"
        />
      </view>
    </view>

    <!-- Network provisioning mode selector -->
    <wd-action-sheet
      v-model="configTypeSelectorShow"
      :actions="configTypeOptions.map(item => ({ name: item.name, value: item.value }))"
      @close="onConfigTypeCancel"
      @select="({ item }) => onConfigTypeConfirm(item)"
    />
  </view>
</template>

<route lang="jsonc" type="page">
{
  "style": {
    "navigationBarTitleText": "Device Configuration",
    "navigationStyle": "custom"
  }
}
</route>
