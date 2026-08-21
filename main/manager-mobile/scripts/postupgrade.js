// # Running `pnpm upgrade` will upgrade `uniapp` related dependencies
// # After the upgrade, many useless dependencies are added automatically, which need to be removed to reduce the package size
// # Just run the command below

const { exec } = require('node:child_process')

// Define the command to execute
const dependencies = [
  '@dcloudio/uni-app-harmony',
  // TODO: If a mini program platform is not needed, please delete or comment it out manually
  '@dcloudio/uni-mp-alipay',
  '@dcloudio/uni-mp-baidu',
  '@dcloudio/uni-mp-jd',
  '@dcloudio/uni-mp-kuaishou',
  '@dcloudio/uni-mp-lark',
  '@dcloudio/uni-mp-qq',
  '@dcloudio/uni-mp-toutiao',
  '@dcloudio/uni-mp-xhs',
  '@dcloudio/uni-quickapp-webview',
  // For the i18n template, comment out the following
  'vue-i18n',
]

// Use exec to run the command
exec(`pnpm un ${dependencies.join(' ')}`, (error, stdout, stderr) => {
  if (error) {
    // If there is an error, print the error message
    console.error(`Execution error: ${error}`)
    return
  }
  // Print normal output
  console.log(`stdout: ${stdout}`)
  // If there is error output, also print it
  console.error(`stderr: ${stderr}`)
})
