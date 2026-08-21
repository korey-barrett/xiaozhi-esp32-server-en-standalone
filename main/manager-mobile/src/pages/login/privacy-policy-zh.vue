<route lang="jsonc" type="page">
{
  "layout": "default",
  "style": {
    "navigationStyle": "custom",
    "navigationBarTitleText": "Privacy Policy"
  }
}
</route>

<script lang="ts" setup>
import { t } from '@/i18n'

function goBack() {
  uni.navigateBack()
}
</script>

<template>
  <view class="h-screen flex flex-col bg-[#f5f8fd]">
    <wd-navbar
      :title="t('login.privacyPolicy')"
      safe-area-inset-top
      left-arrow
      :bordered="false"
      @click-left="goBack"
    >
      <template #left>
        <wd-icon name="arrow-left" size="18" />
      </template>
    </wd-navbar>
    <scroll-view scroll-y class="box-border flex-1 px-[20rpx] py-[30rpx]" :scroll-with-animation="true">
      <view class="rounded-[16rpx] bg-white px-[30rpx] py-[40rpx] shadow-[0_4rpx_20rpx_rgba(0,0,0,0.05)]">
        <view class="mb-[40rpx] text-center">
          <text class="text-[36rpx] text-[#1a1a1a] font-bold">
            {{ t('login.privacyPolicy') }}
          </text>
        </view>
        <view class="mb-[40rpx] text-center">
          <text class="text-[24rpx] text-[#666666]">
            Last Updated: March 10, 2026
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Introduction
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Welcome to the Xiaozhi Backend Service (hereinafter referred to as "this Service"). This Service is operated by the party that actually deploys and administers it (hereinafter referred to as the "Operator" or "we"). We are well aware of the importance of personal information to you and will make every effort to protect the security of your personal information.
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            Please read this Privacy Policy carefully and fully understand its entire content before using this Service. Once you begin using this Service, you are deemed to have read and agreed to this Privacy Policy.
          </text>
        </view>
        <view class="mb-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            This Privacy Policy applies to the collection, storage, use, sharing, and protection of your personal information by us when you use this Service through the Control Console (administration backend), API interfaces, or by any other means.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            I. Information We Collect
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            To provide you with this Service, we may collect the following information:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.1 Account Registration Information: When you register an account, we collect your mobile phone number or username, password, and other information for the purpose of creating and verifying your account.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.2 Device Information: When you bind a hardware device, we collect the device's identifying information (such as device code and MAC address), device model, firmware version, and other information for device management and service provision.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.3 Agent Configuration Information: When you create and configure agents, we collect the character templates you set, language model selections, voice parameter configurations, and other information for the purpose of providing personalized AI interaction services.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.4 Voice Interaction Data: When you use the voice interaction features, this Service uses voice activity detection (VAD) to determine the start and end of your speech, processes your voice input data, and transmits it to third-party speech recognition (ASR) and language model (LLM) services for processing in order to enable the voice interaction features.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.5 Image Data: When you use the vision model features, we may process image data captured through your device camera and transmit it to third-party vision model services for analysis and understanding, in order to enable functions such as image recognition and scene understanding.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.6 Conversation Memory Data: When you enable the memory feature, this Service stores summaries of your interaction history with agents in order to provide a more coherent and personalized interaction experience in subsequent conversations.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.7 Knowledge Base Data: When you use the knowledge base feature, we collect and store the documents, text, and other content you upload to the knowledge base, for the purpose of enabling agents to perform knowledge retrieval and Q&A during conversations.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.8 Voiceprint Data: When you use the voiceprint recognition feature, we collect and store your voiceprint feature samples for speaker identity verification and personalized services.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.9 Chat History Data: We store your conversation history with agents, including text conversation content, conversation timestamps, and interaction context, for the purpose of providing a continuous conversation experience and history query features.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.10 Conversation Audio Data: When you use the voice interaction features, we may store the audio data of your interactions with agents in order to optimize voice interaction quality and enable retrospective queries.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.11 Agent Configuration Data: When you configure agents, we collect the labels, plugin configurations, context provider settings, and other information you set, for the purpose of providing agent customization services.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.12 Device Firmware Data: When you use the OTA upgrade feature, we record the device firmware version, upgrade history, and other information for device management and firmware traceability.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.13 Log Information: When you use this Service, we automatically collect service log information, including but not limited to access times, IP addresses, browser types, and operation records, for service operations and security assurance.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            1.14 Verification Code Information: When you log in using a mobile phone number, we send you a verification code via SMS services for identity verification.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            II. How We Use the Collected Information
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            The information we collect will be used for the following purposes:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) Providing, maintaining, and improving this Service, including core functions such as account management, device management, and agent configuration.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) Processing your voice interaction requests, identifying voice input through voice activity detection (VAD), and invoking third-party AI model services to complete speech recognition, intent recognition, semantic understanding, and speech synthesis.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (3) Processing your image data and invoking third-party vision model services to complete image recognition and scene understanding.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (4) Storing and managing your conversation memory data in order to provide a more coherent service experience in subsequent interactions.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (5) Storing and retrieving the content you upload to the knowledge base, so that agents can provide you with more accurate knowledge Q&A during conversations.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (6) Safeguarding the security and stability of the Service, including identity verification, security protection, and troubleshooting.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (7) Complying with applicable laws, regulations, and regulatory requirements.
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            We will not use your personal information for any purpose unrelated to the purposes described above. If we need to use your information for any purpose not set forth in this Privacy Policy, we will obtain your prior consent.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            III. Sharing and Disclosure of Information
          </text>
        </view>
        <view class="mb-[24rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            We will not sell your personal information to any third party. We may share or disclose your information only under the following circumstances:
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.1 Invocation of Third-Party Services: To implement functions such as voice interaction and visual understanding, your voice data, image data, and text content may be transmitted to third-party AI service providers (such as providers of language models, speech recognition, speech synthesis, and vision models) for processing. We will select providers with reasonable security assurance capabilities, but please be aware that such third-party providers will process the relevant data in accordance with their own privacy policies.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.2 Legal Requirements: We may be required to disclose your personal information in accordance with applicable laws and regulations, legal procedures, or requirements of competent government authorities.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.3 Security Assurance: To protect the rights, interests, property, or safety of the Operator, other users, or the public from harm, we may use or disclose personal information to the extent reasonably necessary.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            3.4 With Consent: We may share your personal information with third parties with your explicit consent.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            IV. Storage and Protection of Information
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.1 Storage Location: Your personal information will be stored on the servers on which the Operator deploys this Service, including but not limited to databases (MySQL/PostgreSQL) and cache services (Redis).
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.2 Retention Period: We will retain your personal information for the period necessary to provide you with the Service. After you cancel your account, we will delete or anonymize your personal information within a reasonable period of time, except where otherwise required by laws and regulations.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.3 Security Measures: We adopt reasonable technical and administrative measures to protect the security of your personal information, including but not limited to data encryption, access control, and security audits. However, please understand that the Internet is not an absolutely secure environment, and we cannot guarantee the absolute security of information transmission and storage.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.4 Handling of Security Incidents: In the event of a personal information security incident, we will, in accordance with the requirements of laws and regulations, promptly inform you of the basic circumstances of the incident, its potential impact, and the remedial measures that have been or will be taken.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.5 Special Statement on the Open-Source Project: This Service is an open-source project and has two modes of operation:
          </text>
        </view>
        <view class="mb-[8rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (1) Self-Hosting: If you deploy this Service yourself, the Operator merely provides the code, and the actual storage and processing of data are your own responsibility.
          </text>
        </view>
        <view class="mb-[8rpx] ml-[40rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            (2) Test Platform: If you use the test platform deployed by the Operator, your data will be managed and protected by the Operator's personnel.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            4.6 Cross-Border Data Transfer: When providing intelligent interaction features, this Service may need to invoke the interfaces of third-party AI service providers located outside the country.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            V. Your Rights
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.1 Inquiry and Access: You may view and manage your personal information, such as account information, device information, and agent configurations, through the Control Console.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.2 Correction and Modification: When you discover that your personal information is inaccurate, you may correct it yourself through the Control Console, or contact the Operator for assistance.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.3 Deletion: You may request that we delete your personal information under the following circumstances: (1) the processing purpose has been achieved, cannot be achieved, or is no longer necessary; (2) we collect or use personal information in violation of laws and regulations or of our agreement with you; (3) upon cancellation of your account.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.4 Account Cancellation: You may cancel your account through the account settings function in the Control Console, or contact the Operator for processing.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            5.5 Withdrawal of Consent: You may withdraw your consent and authorization previously given to us at any time.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            VI. Protection of Minors' Information
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.1 We attach great importance to the protection of minors' personal information. If you are a minor under 18 years of age, please use this Service under the guidance and with the consent of your guardian.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.2 If a guardian discovers that a minor has provided personal information to us without their consent, please contact the Operator, and we will delete the relevant information as soon as possible.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            6.3 For minors who use this Service with the consent of their guardians, we will provide stricter protection of their personal information in accordance with the provisions of laws and regulations.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            VII. Description of Third-Party Services
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            7.1 When providing intelligent interaction features, this Service requires the invocation of third-party services, including but not limited to: voice activity detection services (VAD), speech recognition services (ASR), large language model services (LLM), speech synthesis services (TTS), vision model services, SMS verification code services, MQTT message broker services, and database services.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            7.2 The aforementioned third-party service providers will process data in accordance with their respective privacy policies. We recommend that you familiarize yourself with the privacy policies of the relevant third-party service providers before using this Service.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            VIII. Use of Cookies and Similar Technologies
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.1 This Service may use cookies and similar technologies to save your login status, record your preferences, and otherwise provide you with a better user experience.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            8.2 You may manage cookies through your browser settings. However, please note that disabling cookies may affect certain functions of this Service.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            IX. Changes to the Privacy Policy
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            9.1 We may revise this Privacy Policy for reasons such as business adjustments or changes in laws and regulations. Any revised Privacy Policy will be published through announcements on this platform.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            9.2 If you continue to use this Service after the revision of the Privacy Policy, you will be deemed to have accepted the revised Privacy Policy.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            X. Information Security Notice
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.1 Please do not disclose sensitive personal information such as your financial account, bank card number, credit card number, password, or national identification number in voice or text interactions with the AI; any losses arising therefrom shall be borne by you.
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.2 Please properly safeguard your account and password, and do not disclose your account information to others or share your account with others.
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            10.3 If you discover that your personal information may have been leaked, please contact the Operator promptly to take appropriate measures.
          </text>
        </view>
        <view class="mb-[32rpx]">
          <text class="text-[30rpx] text-[#1a1a1a] font-bold">
            XI. Governing Law
          </text>
        </view>
        <view class="mb-[16rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            11.1 The formulation, interpretation, enforcement, and dispute resolution of this Privacy Policy shall all be governed by the laws and regulations of the People's Republic of China (for the purposes of this Privacy Policy, excluding the laws of Hong Kong, Macao, and Taiwan).
          </text>
        </view>
        <view class="mb-[40rpx] ml-[20rpx]">
          <text class="text-[28rpx] text-[#333333] leading-[1.8]">
            11.2 If any term of this Privacy Policy conflicts with the laws and regulations currently in force in the People's Republic of China, the provisions of such laws and regulations shall prevail, and the remaining terms shall remain valid.
          </text>
        </view>
      </view>
    </scroll-view>
  </view>
</template>
