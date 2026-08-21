// Globally used types are placed here

declare global {
  interface IResData<T> {
    code: number
    msg: string
    data: T
  }

  // uni.uploadFile file upload options
  interface IUniUploadFileOptions {
    file?: File
    files?: UniApp.UploadFileOptionFiles[]
    filePath?: string
    name?: string
    formData?: any
  }

  interface IUserInfo {
    nickname?: string
    avatar?: string
    /** WeChat openid; absent for non-WeChat platforms */
    openid?: string
    token?: string
  }
}

export {} // prevent module pollution
