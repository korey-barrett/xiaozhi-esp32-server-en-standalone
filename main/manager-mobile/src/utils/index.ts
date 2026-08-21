import smCrypto from 'sm-crypto'
import { pages, subPackages } from '@/pages.json'

import { isMpWeixin } from './platform'

/**
 * Runtime server address override storage key
 */
export const SERVER_BASE_URL_OVERRIDE_KEY = 'server_base_url_override'

/**
 * Set / clear / get the runtime-overridden server address
 */
export function setServerBaseUrlOverride(url: string) {
  uni.setStorageSync(SERVER_BASE_URL_OVERRIDE_KEY, url)
}

export function clearServerBaseUrlOverride() {
  uni.removeStorageSync(SERVER_BASE_URL_OVERRIDE_KEY)
}

export function getServerBaseUrlOverride(): string | null {
  const value = uni.getStorageSync(SERVER_BASE_URL_OVERRIDE_KEY)
  return value || null
}

export function getLastPage() {
  // getCurrentPages() always has at least 1 element, so no extra check is needed
  // const lastPage = getCurrentPages().at(-1)
  // the above throws at build time on older Android versions, so the following is used instead (although I added src/interceptions/prototype.ts, it still throws)
  const pages = getCurrentPages()
  return pages[pages.length - 1]
}

/**
 * Get the path and redirectPath of the current page route
 * path e.g. '/pages/login/index'
 * redirectPath e.g. '/pages/demo/base/route-interceptor'
 */
export function currRoute() {
  const lastPage = getLastPage()
  const currRoute = (lastPage as any).$page
  // console.log('lastPage.$page:', currRoute)
  // console.log('lastPage.$page.fullpath:', currRoute.fullPath)
  // console.log('lastPage.$page.options:', currRoute.options)
  // console.log('lastPage.options:', (lastPage as any).options)
  // after cross-platform testing, only fullPath is reliable; the others are not
  const { fullPath } = currRoute as { fullPath: string }
  // console.log(fullPath)
  // eg: /pages/login/index?redirect=%2Fpages%2Fdemo%2Fbase%2Froute-interceptor (mini program)
  // eg: /pages/login/index?redirect=%2Fpages%2Froute-interceptor%2Findex%3Fname%3Dfeige%26age%3D30(h5)
  return getUrlObj(fullPath)
}

function ensureDecodeURIComponent(url: string) {
  if (url.startsWith('%')) {
    return ensureDecodeURIComponent(decodeURIComponent(url))
  }
  return url
}
/**
 * Parse a url into path and query
 * e.g. input url: /pages/login/index?redirect=%2Fpages%2Fdemo%2Fbase%2Froute-interceptor
 * output: {path: /pages/login/index, query: {redirect: /pages/demo/base/route-interceptor}}
 */
export function getUrlObj(url: string) {
  const [path, queryStr] = url.split('?')
  // console.log(path, queryStr)

  if (!queryStr) {
    return {
      path,
      query: {},
    }
  }
  const query: Record<string, string> = {}
  queryStr.split('&').forEach((item) => {
    const [key, value] = item.split('=')
    // console.log(key, value)
    query[key] = ensureDecodeURIComponent(value) // a unified decodeURIComponent here is needed to be compatible with both h5 and WeChat
  })
  return { path, query }
}
/**
 * Get all pages that require login, including those in the main package and subpackages
 * This is designed to be generic: a key can be passed as the filter criterion, defaulting to needLogin, paired with route-block
 * If no key is passed, all pages are returned; if a key is passed, pages are filtered by that key
 */
export function getAllPages(key = 'needLogin') {
  // handle the main package here
  const mainPages = pages
    .filter(page => !key || page[key])
    .map(page => ({
      ...page,
      path: `/${page.path}`,
    }))

  // handle the subpackages here
  const subPages: any[] = []
  subPackages.forEach((subPageObj) => {
    // console.log(subPageObj)
    const { root } = subPageObj

    subPageObj.pages
      .filter(page => !key || page[key])
      .forEach((page: { path: string } & Record<string, any>) => {
        subPages.push({
          ...page,
          path: `/${root}/${page.path}`,
        })
      })
  })
  const result = [...mainPages, ...subPages]
  // console.log(`getAllPages by ${key} result: `, result)
  return result
}

/**
 * Get all pages that require login, including those in the main package and subpackages
 * Returns only the path array
 */
export const getNeedLoginPages = (): string[] => getAllPages('needLogin').map(page => page.path)

/**
 * Get all pages that require login, including those in the main package and subpackages
 * Returns only the path array
 */
export const needLoginPages: string[] = getAllPages('needLogin').map(page => page.path)

/**
 * Determine which baseUrl to use based on the WeChat mini program environment
 */
export function getEnvBaseUrl() {
  // if a user-set override address exists, return it first
  const override = getServerBaseUrlOverride()
  if (override)
    return override

  // request base address (defaults to the value from env)
  let baseUrl = import.meta.env.VITE_SERVER_BASEURL

  // # some developers may need to set separate upload addresses for develop, trial, release in the WeChat mini program; see sample code below.
  const VITE_SERVER_BASEURL__WEIXIN_DEVELOP = 'https://ukw0y1.laf.run'
  const VITE_SERVER_BASEURL__WEIXIN_TRIAL = 'https://ukw0y1.laf.run'
  const VITE_SERVER_BASEURL__WEIXIN_RELEASE = 'https://ukw0y1.laf.run'

  // WeChat mini program environment distinction
  if (isMpWeixin) {
    const {
      miniProgram: { envVersion },
    } = uni.getAccountInfoSync()

    switch (envVersion) {
      case 'develop':
        baseUrl = VITE_SERVER_BASEURL__WEIXIN_DEVELOP || baseUrl
        break
      case 'trial':
        baseUrl = VITE_SERVER_BASEURL__WEIXIN_TRIAL || baseUrl
        break
      case 'release':
        baseUrl = VITE_SERVER_BASEURL__WEIXIN_RELEASE || baseUrl
        break
    }
  }

  return baseUrl
}

/**
 * Determine which UPLOAD_BASEURL to use based on the WeChat mini program environment
 */
export function getEnvBaseUploadUrl() {
  // request base address
  let baseUploadUrl = import.meta.env.VITE_UPLOAD_BASEURL

  const VITE_UPLOAD_BASEURL__WEIXIN_DEVELOP = 'https://ukw0y1.laf.run/upload'
  const VITE_UPLOAD_BASEURL__WEIXIN_TRIAL = 'https://ukw0y1.laf.run/upload'
  const VITE_UPLOAD_BASEURL__WEIXIN_RELEASE = 'https://ukw0y1.laf.run/upload'

  // WeChat mini program environment distinction
  if (isMpWeixin) {
    const {
      miniProgram: { envVersion },
    } = uni.getAccountInfoSync()

    switch (envVersion) {
      case 'develop':
        baseUploadUrl = VITE_UPLOAD_BASEURL__WEIXIN_DEVELOP || baseUploadUrl
        break
      case 'trial':
        baseUploadUrl = VITE_UPLOAD_BASEURL__WEIXIN_TRIAL || baseUploadUrl
        break
      case 'release':
        baseUploadUrl = VITE_UPLOAD_BASEURL__WEIXIN_RELEASE || baseUploadUrl
        break
    }
  }

  return baseUploadUrl
}

/**
 * Generate an SM2 key pair (hex format)
 * @returns {object} object containing the public key and private key
 */
export function generateSm2KeyPairHex() {
  // generate an SM2 key pair using the sm-crypto library
  const sm2 = smCrypto.sm2
  const keypair = sm2.generateKeyPairHex()

  return {
    publicKey: keypair.publicKey,
    privateKey: keypair.privateKey,
    clientPublicKey: keypair.publicKey, // client public key
    clientPrivateKey: keypair.privateKey, // client private key
  }
}

/**
 * SM2 public key encryption
 * @param {string} publicKey public key (hex format)
 * @param {string} plainText plaintext
 * @returns {string} encrypted ciphertext (hex format)
 */
export function sm2Encrypt(publicKey: string, plainText: string): string {
  if (!publicKey) {
    throw new Error('Public key must not be null or undefined')
  }

  if (!plainText) {
    throw new Error('Plaintext must not be empty')
  }

  const sm2 = smCrypto.sm2
  // SM2 encryption, add the 04 prefix to indicate an uncompressed public key
  const encrypted = sm2.doEncrypt(plainText, publicKey, 1)
  // convert to hex format (consistent with the backend, adding the 04 prefix)
  const result = `04${encrypted}`

  return result
}

/**
 * SM2 private key decryption
 * @param {string} privateKey private key (hex format)
 * @param {string} cipherText ciphertext (hex format)
 * @returns {string} decrypted plaintext
 */
export function sm2Decrypt(privateKey: string, cipherText: string): string {
  const sm2 = smCrypto.sm2
  // remove the 04 prefix (consistent with the backend)
  const dataWithoutPrefix = cipherText.startsWith('04') ? cipherText.substring(2) : cipherText
  // SM2 decryption
  return sm2.doDecrypt(dataWithoutPrefix, privateKey, 1)
}

type AnyFunction = (...args: any[]) => any

interface DebouncedFunction extends AnyFunction {
  cancel: () => void
}

/**
 * Debounce function
 * @param fn the function to debounce
 * @param delay delay time (milliseconds), default 500ms
 * @param immediate whether to execute immediately, default false
 * @returns the debounced function
 */
export function debounce<T extends AnyFunction>(
  fn: T,
  delay = 500,
  immediate = false,
): DebouncedFunction {
  let timer: ReturnType<typeof setTimeout> | null = null

  const debounced = function (this: any, ...args: Parameters<T>) {
    if (timer) {
      clearTimeout(timer)
    }

    if (immediate && !timer) {
      fn.apply(this, args)
    }

    timer = setTimeout(() => {
      if (!immediate) {
        fn.apply(this, args)
      }
      timer = null
    }, delay)
  } as DebouncedFunction

  debounced.cancel = () => {
    if (timer) {
      clearTimeout(timer)
      timer = null
    }
  }

  return debounced
}

type DeepCloneTarget = string | number | boolean | null | undefined | object

/**
 * Deep clone method
 * @param target the object to clone
 * @returns the cloned new object
 */
export function deepClone<T extends DeepCloneTarget>(target: T): T {
  if (target === null || typeof target !== 'object') {
    return target
  }

  if (target instanceof Date) {
    return new Date(target.getTime()) as any
  }

  if (Array.isArray(target)) {
    return target.map(item => deepClone(item)) as any
  }

  if (target instanceof Object) {
    const clonedObj = {} as T
    for (const key in target) {
      if (Object.prototype.hasOwnProperty.call(target, key)) {
        (clonedObj as any)[key] = deepClone((target as any)[key])
      }
    }
    return clonedObj
  }

  return target
}
