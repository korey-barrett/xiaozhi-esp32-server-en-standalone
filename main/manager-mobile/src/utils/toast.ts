/**
 * toast popup component
 * supports four states: success/error/warning/info
 * configurable duration, position, etc.
 */

type ToastType = 'success' | 'error' | 'warning' | 'info'

interface ToastOptions {
  type?: ToastType
  duration?: number
  position?: 'top' | 'middle' | 'bottom'
  icon?: 'success' | 'error' | 'none' | 'loading' | 'fail' | 'exception'
  message: string
}

export function showToast(options: ToastOptions | string) {
  const defaultOptions: ToastOptions = {
    type: 'info',
    duration: 2000,
    position: 'middle',
    message: '',
  }
  const mergedOptions
    = typeof options === 'string'
      ? { ...defaultOptions, message: options }
      : { ...defaultOptions, ...options }
  // map position to the format supported by uni-app
  const positionMap: Record<ToastOptions['position'], 'top' | 'bottom' | 'center'> = {
    top: 'top',
    middle: 'center',
    bottom: 'bottom',
  }

  // map the icon type
  const iconMap: Record<
    ToastType,
    'success' | 'error' | 'none' | 'loading' | 'fail' | 'exception'
  > = {
    success: 'success',
    error: 'error',
    warning: 'fail',
    info: 'none',
  }

  // call uni.showToast to display the prompt
  uni.showToast({
    title: mergedOptions.message,
    duration: mergedOptions.duration,
    position: positionMap[mergedOptions.position],
    icon: mergedOptions.icon || iconMap[mergedOptions.type],
    mask: true,
  })
}

export const toast = {
  success: (message: string, options?: Omit<ToastOptions, 'type'>) =>
    showToast({ ...options, type: 'success', message }),
  error: (message: string, options?: Omit<ToastOptions, 'type'>) =>
    showToast({ ...options, type: 'error', message }),
  warning: (message: string, options?: Omit<ToastOptions, 'type'>) =>
    showToast({ ...options, type: 'warning', message }),
  info: (message: string, options?: Omit<ToastOptions, 'type'>) =>
    showToast({ ...options, type: 'info', message }),
}
