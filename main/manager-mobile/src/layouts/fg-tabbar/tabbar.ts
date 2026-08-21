/**
 * tabbar state, uses storageSync to ensure the correct tabbar page on browser refresh
 * Uses reactive simple state instead of the pinia global state
 */
export const tabbarStore = reactive({
  curIdx: uni.getStorageSync('app-tabbar-index') || 0,
  setCurIdx(idx: number) {
    this.curIdx = idx
    uni.setStorageSync('app-tabbar-index', idx)
  },
})
