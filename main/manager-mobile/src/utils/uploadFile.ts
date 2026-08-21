import { getEnvBaseUrl } from './index'
import { toast } from './toast'

/**
 * Example of using the file upload hook
 * @example
 * const { loading, error, data, progress, run } = useUpload<IUploadResult>(
 *   uploadUrl,
 *   {},
 *   {
 *     maxSize: 5, // max 5MB
 *     sourceType: ['album'], // only allow choosing from the album
 *     onProgress: (p) => console.log(`Upload progress: ${p}%`),
 *     onSuccess: (res) => console.log('Upload succeeded', res),
 *     onError: (err) => console.error('Upload failed', err),
 *   },
 * )
 */

/**
 * URL configuration for uploading files
 */
export const uploadFileUrl = {
  /** User avatar upload address (dynamically reads the currently active BaseURL) */
  get USER_AVATAR() {
    return `${getEnvBaseUrl()}/user/avatar`
  },
}

/**
 * Generic file upload function (supports passing a file path directly)
 * @param url upload address
 * @param filePath local file path
 * @param formData extra form data
 * @param options upload options
 */
export function useFileUpload<T = string>(url: string, filePath: string, formData: Record<string, any> = {}, options: Omit<UploadOptions, 'sourceType' | 'sizeType' | 'count'> = {}) {
  return useUpload<T>(
    url,
    formData,
    {
      ...options,
      sourceType: ['album'],
      sizeType: ['original'],
    },
    filePath,
  )
}

export interface UploadOptions {
  /** maximum number of selectable images, default 1 */
  count?: number
  /** size of the selected images, original-original image, compressed-compressed image */
  sizeType?: Array<'original' | 'compressed'>
  /** source of the selected images, album-album, camera-camera */
  sourceType?: Array<'album' | 'camera'>
  /** file size limit, unit: MB */
  maxSize?: number //
  /** upload progress callback */
  onProgress?: (progress: number) => void
  /** upload success callback */
  onSuccess?: (res: Record<string, any>) => void
  /** upload failure callback */
  onError?: (err: Error | UniApp.GeneralCallbackResult) => void
  /** upload complete callback (whether successful or failed) */
  onComplete?: () => void
}

/**
 * File upload hook
 * @template T the data type returned after a successful upload
 * @param url upload address
 * @param formData extra form data
 * @param options upload options
 * @returns upload state and control object
 */
export function useUpload<T = string>(url: string, formData: Record<string, any> = {}, options: UploadOptions = {},
  /** pass a file path directly, skipping the picker */
  directFilePath?: string) {
  /** uploading state */
  const loading = ref(false)
  /** upload error state */
  const error = ref(false)
  /** response data after a successful upload */
  const data = ref<T>()
  /** upload progress (0-100) */
  const progress = ref(0)

  /** destructure upload options and set defaults */
  const {
    /** maximum number of selectable images */
    count = 1,
    /** size of the selected images */
    sizeType = ['original', 'compressed'],
    /** source of the selected images */
    sourceType = ['album', 'camera'],
    /** file size limit (MB) */
    maxSize = 10,
    /** progress callback */
    onProgress,
    /** success callback */
    onSuccess,
    /** failure callback */
    onError,
    /** complete callback */
    onComplete,
  } = options

  /**
   * Check whether the file size exceeds the limit
   * @param size file size (bytes)
   * @returns whether the check passes
   */
  const checkFileSize = (size: number) => {
    const sizeInMB = size / 1024 / 1024
    if (sizeInMB > maxSize) {
      toast.warning(`File size cannot exceed ${maxSize}MB`)
      return false
    }
    return true
  }
  /**
   * Trigger file selection and upload
   * Different pickers are used depending on the platform:
   * - the WeChat mini program uses chooseMedia
   * - other platforms use chooseImage
   */
  const run = () => {
    if (directFilePath) {
      // use the passed-in file path directly
      loading.value = true
      progress.value = 0
      uploadFile<T>({
        url,
        tempFilePath: directFilePath,
        formData,
        data,
        error,
        loading,
        progress,
        onProgress,
        onSuccess,
        onError,
        onComplete,
      })
      return
    }

    // #ifdef MP-WEIXIN
    // use the chooseMedia API in the WeChat mini program environment
    uni.chooseMedia({
      count,
      mediaType: ['image'], // only image types are supported
      sourceType,
      success: (res) => {
        const file = res.tempFiles[0]
        // check whether the file size meets the limit
        if (!checkFileSize(file.size))
          return

        // start uploading
        loading.value = true
        progress.value = 0
        uploadFile<T>({
          url,
          tempFilePath: file.tempFilePath,
          formData,
          data,
          error,
          loading,
          progress,
          onProgress,
          onSuccess,
          onError,
          onComplete,
        })
      },
      fail: (err) => {
        console.error('Failed to select media file:', err)
        error.value = true
        onError?.(err)
      },
    })
    // #endif

    // #ifndef MP-WEIXIN
    // use the chooseImage API in non-WeChat mini program environments
    uni.chooseImage({
      count,
      sizeType,
      sourceType,
      success: (res) => {
        console.log('Image selected successfully:', res)

        // start uploading
        loading.value = true
        progress.value = 0
        uploadFile<T>({
          url,
          tempFilePath: res.tempFilePaths[0],
          formData,
          data,
          error,
          loading,
          progress,
          onProgress,
          onSuccess,
          onError,
          onComplete,
        })
      },
      fail: (err) => {
        console.error('Failed to select image:', err)
        error.value = true
        onError?.(err)
      },
    })
    // #endif
  }

  return { loading, error, data, progress, run }
}

/**
 * File upload options interface
 * @template T the data type returned after a successful upload
 */
interface UploadFileOptions<T> {
  /** upload address */
  url: string
  /** temporary file path */
  tempFilePath: string
  /** extra form data */
  formData: Record<string, any>
  /** response data after a successful upload */
  data: Ref<T | undefined>
  /** upload error state */
  error: Ref<boolean>
  /** uploading state */
  loading: Ref<boolean>
  /** upload progress (0-100) */
  progress: Ref<number>
  /** upload progress callback */
  onProgress?: (progress: number) => void
  /** upload success callback */
  onSuccess?: (res: Record<string, any>) => void
  /** upload failure callback */
  onError?: (err: Error | UniApp.GeneralCallbackResult) => void
  /** upload complete callback */
  onComplete?: () => void
}

/**
 * Execute the file upload
 * @template T the data type returned after a successful upload
 * @param options upload options
 */
function uploadFile<T>({
  url,
  tempFilePath,
  formData,
  data,
  error,
  loading,
  progress,
  onProgress,
  onSuccess,
  onError,
  onComplete,
}: UploadFileOptions<T>) {
  try {
    // create the upload task
    const uploadTask = uni.uploadFile({
      url,
      filePath: tempFilePath,
      name: 'file', // the key corresponding to the file
      formData,
      header: {
        // in the H5 environment, Content-Type does not need to be set manually; let the browser handle the multipart format automatically
        // #ifndef H5
        'Content-Type': 'multipart/form-data',
        // #endif
      },
      // ensure the file name is valid
      success: (uploadFileRes) => {
        console.log('File upload succeeded:', uploadFileRes)
        try {
          // parse the response data
          const { data: _data } = JSON.parse(uploadFileRes.data)
          // upload succeeded
          data.value = _data as T
          onSuccess?.(_data)
        }
        catch (err) {
          // response parsing error
          console.error('Failed to parse the upload response:', err)
          error.value = true
          onError?.(new Error('Failed to parse the upload response'))
        }
      },
      fail: (err) => {
        // upload request failed
        console.error('File upload failed:', err)
        error.value = true
        onError?.(err)
      },
      complete: () => {
        // execute whether successful or failed
        loading.value = false
        onComplete?.()
      },
    })

    // listen for upload progress
    uploadTask.onProgressUpdate((res) => {
      progress.value = res.progress
      onProgress?.(res.progress)
    })
  }
  catch (err) {
    // failed to create the upload task
    console.error('Failed to create the upload task:', err)
    error.value = true
    loading.value = false
    onError?.(new Error('Failed to create the upload task'))
  }
}
